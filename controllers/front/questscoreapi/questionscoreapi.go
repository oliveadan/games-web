package questscoreapi

import (
	. "games-web/controllers/front"
	. "games-web/models/common"
	. "games-web/models/gamedetail/questionscore"
	. "games-web/models/gift"
	. "games-web/models/rewardlog"
	"games-web/utils"
	"phage/controllers/sysmanage"
	. "phage/models"
	utils2 "phage/utils"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type QuestscoreApiController struct {
	beego.Controller
}

func (this *QuestscoreApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *QuestscoreApiController) Login() {
	gId, err := this.GetInt64("gid", 0)
	if this.Ctx.Request.Method == "POST" {
		var code int
		var msg string
		url := beego.URLFor("CategoryapiController.get", "gid", gId)
		defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
		//登录验证
		account := strings.TrimSpace(this.GetString("name"))
		mobile := strings.TrimSpace(this.GetString("mobile"))
		//category := this.GetString("category")
		if err != nil || gId == 0 {
			msg = "活动获取失败，请刷新后重试(1)"
			return
		}
		o := orm.NewOrm()
		// 活动情况校验
		var game Game
		err = o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "Deleted", "Enabled", "StartTime", "EndTime", "GameType")
		if err != nil {
			beego.Error("Lotterycontroller error", err)
			msg = "问卷活动获取错误，请刷新后重试(2)"
			return
		}
		if game.Deleted != 0 || game.Enabled != 1 {
			msg = "答题活动已停止！"
			return
		}
		if game.StartTime.After(time.Now()) {
			msg = "答题活动将于" + game.StartTime.Format("2006-01-02 15:04:05") + "开启，敬请关注！"
			return
		}
		if game.EndTime.Before(time.Now()) {
			msg = "答题活动已结束！"
			return
		}
		if account == "" {
			msg = "会员账号不能为空"
			return
		}
		exist := o.QueryTable(new(Member)).Filter("Account", account).Exist()
		if !exist {
			msg = "您输入的会员账号不存在,请核对后重新输入"
			return
		}
		if mobile != "" {
			_, err := o.QueryTable(new(Member)).Filter("Account", account).Update(orm.Params{"Mobile": mobile})
			if err != nil {
				beego.Error("update member mobile error", err)
			}
		}
		var ml MemberLottery
		err1 := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).One(&ml, "LotteryNums")
		if err1 != nil {
			msg = "您没有答题次数了"
			beego.Error("查询会员答题次数失败", err1)
			return
		}

		if ml.LotteryNums <= 0 {
			msg = "您没有答题次数了"
			return
		}

		this.SetSession("questaccount", account)
		code = 1
		msg = "登录成功"
	} else {
		SetGameData(&this.Controller, &gId)
		this.TplName = "front/questscore/login.html"
	}
}

func (this *QuestscoreApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	session := this.GetSession("questaccount")
	if session == nil {
		this.Redirect(beego.URLFor("QuestscoreApiController.get", "gid", gId), 301)
	}
	category, _ := this.GetInt64("questcategory", 0)
	SetGameData(&this.Controller, &gId)
	// 问卷内容
	var list1 []Questionscore
	var slice = make([]int64, 0)
	var must = make([]int64, 0)
	o := orm.NewOrm()
	_, e := o.QueryTable(new(Questionscore)).Filter("GameId", gId).Filter("Pid", 0).Filter("Category", category).All(&list1)
	if e != nil {
		beego.Error("获取非必出题目失败", e)
	}
	for _, v := range list1 {
		//选出必出题目
		if v.Required == 1 {
			must = append(must, v.Id)
			continue
		}
		slice = append(slice, v.Id)
	}
	//随机选出5道题目
	var gameattributes GameAttribute
	o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code", "questionquantity").One(&gameattributes)
	i, _ := strconv.Atoi(gameattributes.Value)
	if i < 2 {
		i = 2
	}
	ids, _ := utils.RandomInt64s(slice, i)
	for _, v := range must {
		ids = append(ids, v)
	}
	var list []Questionscore
	cond := orm.NewCondition()
	qs := o.QueryTable(new(Questionscore))
	cond1 := cond.And("Pid__in", ids).And("GameId", gId).And("Category", category).Or("Id__in", ids)
	qs.SetCond(cond1).OrderBy("-Required", "Pid", "Seq", "Id").All(&list)
	questiontoken := utils2.GetGuid()
	// token 用于防止用户和重复提交
	this.SetSession("questiontoken", questiontoken)
	//储存随机出来的题目的ID,用于正确答案展示
	this.DelSession("ids")
	this.SetSession("ids", ids)
	this.Data["category"] = category
	this.Data["token"] = questiontoken
	this.Data["titlenumbers"] = len(ids)
	this.Data["gameid"] = gId
	this.Data["questList"] = list

	this.TplName = "front/questscore/answer.html"
}

func (this *QuestscoreApiController) Post() {
	var code int
	var msg string
	var sumscore int64
	var url string
	o := orm.NewOrm()
	gId, err := this.GetInt64("gid", 0)
	token := this.GetString("token")
	category, _ := this.GetInt64("category")
	ids := this.GetString("ids")
	newids := strings.Split(ids, ",")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	account := this.GetSession("questaccount").(string)
	if err != nil || gId == 0 {
		msg = "系统异常,请返回后刷新重试"
		return
	}
	var questioncategory string
	switch category {
	case 1:
		questioncategory = "直播彩票"
		break
	case 2:
		questioncategory = "刺激真人"
		break
	case 3:
		questioncategory = "电子棋牌"
		break
	case 4:
		questioncategory = "实时体育"
		break
	default:
		questioncategory = ""
	}
	var mutex sync.Mutex
	mutex.Lock()
	lasttoken := this.GetSession("questiontoken")
	if lasttoken == nil {
		msg = "系统异常(01)"
		return
	}
	if token == lasttoken.(string) {
		this.DelSession("questiontoken")
	} else {
		msg = "系统异常(0)"
		return
	}
	mutex.Unlock()
	var ml MemberLottery
	err5 := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).One(&ml, "LotteryNums")
	if err5 != nil {
		msg = "您没有答题次数了"
		beego.Error("查询会员答题次数失败", err5)
		return
	}
	if ml.LotteryNums <= 0 {
		msg = "您没有答题次数了"
		return
	} else {
		var rewardlognum int64
		var content string
		// 获取会员得分
		var qss []Questionscore
		_, err3 := o.QueryTable(new(Questionscore)).Filter("GameId", gId).Filter("Id__in", newids).All(&qss, "Score")
		if err3 != nil {
			beego.Error("获取会员得分失败", err3)
			msg = "系统异常,请刷新后重试"
		}
		for _, v := range qss {
			if v.Score == 0 {
				continue
			}
			sumscore += v.Score
		}
		o.Begin()
		//生成中奖记录
		var gifts []Gift
		_, err1 := o.QueryTable(new(Gift)).Filter("GameId", gId).OrderBy("-Seq").All(&gifts)
		if err1 == nil {
			for _, v := range gifts {
				if sumscore >= int64(v.Seq) {
					if v.Quantity >= 1 {
						now, _ := time.ParseInLocation("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:04:05"), time.Local)
						rewardlog := RewardLog{GameId: gId, Account: account, BaseModel: BaseModel{CreateDate: now}}
						rewardlog.GiftContent = v.Content
						rewardlog.GiftName = questioncategory + "-" + v.Name
						rewardlog.ModifyDate = now
						rewardlog.Version = 0
						rewardlog.GiftId = v.Id
						content = v.Content
						_, num, err2 := o.ReadOrCreate(&rewardlog, "GameId", "Account", "CreateDate")
						rewardlognum = num
						if err2 != nil {
							beego.Error("创建中奖记录失败", err2)
							o.Rollback()
							msg = "系统异常(3)"
							return
						} else {
							// 抽中则减掉1个奖品
							_, err3 := o.QueryTable(new(Gift)).Filter("Id", v.Id).Filter("Quantity__gt", 0).Update(orm.Params{
								"Quantity": orm.ColValue(orm.ColMinus, 1),
							})
							if err3 != nil {
								beego.Error("减掉奖品数量失败", err3)
								o.Rollback()
								msg = "系统异常(4)"
								return
							}
						}
					}
					break
				}

			}
		}
		//减掉会员一次抽奖次数
		_, err4 := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Update(orm.Params{
			"ModifyDate":  time.Now(),
			"LotteryNums": orm.ColValue(orm.ColMinus, 1),
		})
		if err4 != nil {
			beego.Error("减掉会员抽奖次数失败", err4)
			o.Rollback()
			msg = "系统异常(5)"
			return
		}
		//将会员得分情况插入得分排行榜
		var qr QuestionscoreRanking
		qr.Account = account
		qr.Score = sumscore
		qr.GameId = gId
		bool, _, err5 := qr.ReadOrCreate("Account")
		if err5 != nil {
			beego.Error("insert QuestionscoreRanking error ", err5)
			o.Rollback()
			msg = "系统异常(6)"
			return
		}
		if !bool {
			_, err := o.QueryTable(new(QuestionscoreRanking)).Filter("GameId", gId).Filter("Account", account).Update(orm.Params{
				"GameId":     gId,
				"ModifyDate": time.Now(),
				"Score":      sumscore})
			if err != nil {
				beego.Error("update QuestionscoreRanking error", err)
				o.Rollback()
				msg = "系统异常(7)"
				return
			}
		}
		o.Commit()
		code = 1

		if rewardlognum >= 1 {
			msg = "恭喜您获得" + content + ","
		} else {
			msg = "很遗憾您未获得奖品,感谢您的参与"
		}
	}
	url = beego.URLFor("QuestscoreApiController.Result", "gid", gId, "scoure", sumscore, "msg", msg)
}

func (this *QuestscoreApiController) Result() {
	gid, _ := this.GetInt64("gid", 0)
	scoure := this.GetString("scoure")
	msg := this.GetString("msg")
	this.Data["scoure"] = scoure
	this.Data["msg"] = msg
	this.Data["gid"] = gid
	this.TplName = "front/questscore/result.html"
}

func (this *QuestscoreApiController) Ranking() {
	gid, _ := this.GetInt64("gid")
	o := orm.NewOrm()
	var qks []QuestionscoreRanking
	_, e := o.QueryTable(new(QuestionscoreRanking)).Filter("GameId", gid).OrderBy("-Score").Limit(10).All(&qks)
	if e != nil {
		beego.Error("query QuestionscoreRanking error", e)
	}
	this.Data["list"] = qks
	this.TplName = "front/questscore/top.html"
}

type CategoryapiController struct {
	beego.Controller
}

func (this *CategoryapiController) Prepare() {
	this.EnableXSRF = false
}

func (this *CategoryapiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	this.Data["gid"] = gId
	this.TplName = "front/questscore/often.html"
}

func (this *CategoryapiController) Post() {
	category, _ := this.GetInt64("questcategory")
	gid, _ := this.GetInt64("gid")
	var code int
	var msg string
	url := beego.URLFor("QuestscoreApiController.get", "gid", gid, "questcategory", category)
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	//验证这道目有没有超过10题
	o := orm.NewOrm()
	i, e := o.QueryTable(new(Questionscore)).Filter("GameId", gid).Filter("Category", category).Filter("Pid", 0).Count()
	if e != nil {
		code = 0
		msg = "系统异常，请刷新后重试"
		beego.Error("查询题目类型失败", e)
		return
	}
	if i < 6 {
		code = 0
		msg = "这个题库暂时没有题目请选择其他题库"
		return
	}
	code = 1
}

type CorrectapiController struct {
	beego.Controller
}

func (this *CorrectapiController) Prepare() {
	this.EnableXSRF = false
}

func (this *CorrectapiController) Get() {
	gid, _ := this.GetInt64("gid", 0)
	ids := this.GetSession("ids")
	o := orm.NewOrm()
	var list []Questionscore
	cond := orm.NewCondition()
	qs := o.QueryTable(new(Questionscore))
	cond1 := cond.And("Pid__in", ids).And("GameId", gid).Or("Id__in", ids)
	qs.SetCond(cond1).OrderBy("-Required", "Pid", "Seq", "Id").All(&list)
	this.Data["list"] = list
	this.TplName = "front/questscore/detail.html"
}
