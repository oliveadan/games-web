package signinapi

import (
	"fmt"
	. "games-web/controllers/front"
	. "games-web/models/common"
	. "games-web/models/gamedetail/signin"
	. "games-web/models/gift"
	. "games-web/models/rewardlog"
	"games-web/utils"
	"net/http"
	. "phage/models"
	. "phage/utils"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	"phage/controllers/sysmanage"
	"regexp"
	"unicode/utf8"
)

type SigninApiController struct {
	beego.Controller
}

func (this *SigninApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *SigninApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	list := SetRewardList(&this.Controller, &gId)
	game := GetGame(gId)
	var rlList []RewardLog
	var rlList1 []RewardLog
	today, _ := time.ParseInLocation("2006-01-02", time.Now().Format("2006-01-02"), time.Local)
	qb, _ := orm.NewQueryBuilder("mysql")
	o := orm.NewOrm()
	//签到奖金排行
	qb.Select("*").From("ph_reward_log").Where("game_id=?").And("category = 0").And("create_date >= ?").OrderBy("gift_content+0 Desc").Limit(6)
	sql := qb.String()
	_, err := o.Raw(sql, gId, today).QueryRows(&rlList)
	if err != nil {
		beego.Error("查询奖金失败", err)
	}
	//只有版本3的时候才进行查询
	if game.GameVersion == 3 {
		//签到翻倍奖金排行
		qb1, _ := orm.NewQueryBuilder("mysql")
		qb1.Select("*").From("ph_reward_log").Where("game_id=?").And("category = 3").And("create_date >= ?").OrderBy("gift_name+0 DESC,gift_content+0 DESC").Limit(6)
		sql1 := qb1.String()
		_, err := o.Raw(sql1, gId, today).QueryRows(&rlList1)
		if err != nil {
			beego.Error("查询翻倍奖金失败", err)
		}
	}
	var endtimeformat = game.EndTime.Format("2006/01/02 15:04:05")
	this.Data["gameid"] = gId
	this.Data["rlList1"] = rlList1
	this.Data["rlList"] = rlList
	this.Data["endtime"] = endtimeformat
	this.Data["rrlList"] = list
	version := fmt.Sprintf("%d", game.GameVersion)
	if version == "5" && IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/signin/index-wap-v" + version + ".tpl"
	} else {
		this.TplName = "front/signin/index-pc-v" + version + ".tpl"
	}
}

func (this *SigninApiController) Post() {
	var code int
	var msg string
	var data = make(map[string]string)
	defer Retjson(this.Ctx, &msg, &code, &data)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	if err != nil {
		msg = "活动获取失败，请刷新后重试"
		return
	}
	account := strings.TrimSpace(this.GetString("account"))
	// 验证接口
	o := orm.NewOrm()
	var game Game
	if err = o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "GameType"); err != nil {
		msg = "活动获取失败，请刷新后重试！"
		return
	}
	if game.GameType != "signin" {
		beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
		msg = "违法使用接口，警告一次！"
		return
	}
	// 活动验证，会员不验证
	var ok bool
	if ok, msg = CheckGame(gId, "-1"); !ok {
		return
	}
	// 查询会员信息
	var member Member
	if err := o.QueryTable(new(Member)).Filter("Account", account).Limit(1).One(&member, "Level", "LevelName", "Force", "LastSigninDate", "SignEnable"); err != nil {
		if err == orm.ErrNoRows {
			msg = "会员账号不存在，请注册后再进行签到！~"
			return
		} else {
			msg = "会员获取失败，请重试"
		}
		return
	}
	/*
		只有永利暂使用
		if member.SignEnable != gId {
			msg = "温馨提示：账户不符合签到资格"
			return
		}*/
	today, _ := time.ParseInLocation("2006-01-02", time.Now().Format("2006-01-02"), time.Local)
	if today.Before(member.LastSigninDate) {
		code = 2
		msg = "今日您已签到过，请明天再来吧！"
		return
	}
	// 查询活动属性配置
	var gaList []GameAttribute
	if _, err := o.QueryTable(new(GameAttribute)).Filter("GameId", gId).All(&gaList, "Code", "Value"); err != nil {
		msg = "活动获取失败，请重试"
		return
	}
	var signinper int64
	var signinunit string
	for _, v := range gaList {
		switch v.Code {
		case utils.Signinper:
			signinper, _ = strconv.ParseInt(v.Value, 10, 64)
		case utils.Signinunit:
			signinunit = v.Value
		}
	}
	// 查询签到等级配置信息，当前积分 + 签到积分 后查询
	var sl SigninLevel
	var force = member.Force + int(signinper)
	data["force"] = fmt.Sprintf("%d", force)
	data["unit"] = signinunit
	data["per"] = fmt.Sprintf("%d", signinper)
	qs := o.QueryTable(new(SigninLevel)).Filter("GameId", gId)
	qs = qs.Filter("MinForce__lte", force).Filter("MaxForce__gte", force)
	err = qs.Limit(1).One(&sl)
	if err != nil {
		beego.Info("gamdeid", gId, "fore", force)
		beego.Error("query level error", err)
		msg = "系统异常(0),请联系客服处理"
		return
	}
	//如果点数达到最大返回，不再进行操作
	var signinlevel SigninLevel
	err10 := o.QueryTable(new(SigninLevel)).Filter("GameId", gId).OrderBy("-Level").One(&signinlevel)
	if err10 != nil {
		beego.Error("没有查询到最大的等级", err10)
		msg = "签到异常（10）,请联系客服处理~"
		return
	}
	if signinlevel.MaxForce <= member.Force {
		msg = "您的签到点数已经达到最大"
		return
	}
	//获取下一等级信息,计算到下一等级所需要的点数
	var sl1 SigninLevel
	err11 := o.QueryTable(new(SigninLevel)).Filter("GameId", gId).Filter("Level", sl.Level+1).One(&sl1)
	if err11 != nil {
		data["force1"] = fmt.Sprintf("%d", 0)
	} else {
		ss := sl1.MinForce - force
		data["force1"] = fmt.Sprintf("%d", ss)
	}
	//如果后台签到活动，等级配置，中签到金额最大和最小值相同的话，系统会报错。
	if sl.MinAmount == sl.MaxAmount {
		beego.Info("eoor", sl)
		msg = "签到异常（1）,请联系客服处理！~"
		return
	}
	if err != nil && err != orm.ErrNoRows {
		msg = "签到失败，请重试"
		return
	}
	// 事务开始
	o.Begin()
	var level int
	var levelName string
	var nextlevlelNme string
	var rl RewardLog
	var rl1 RewardLog
	var giftContent string
	if err != nil && err == orm.ErrNoRows {
		// 没有匹配的等级
		level = member.Level
		levelName = member.LevelName
		rl = RewardLog{}
	} else {
		// 有匹配的等级
		level = sl.Level
		levelName = sl.Name
		nextlevlelNme = sl1.Name
		n1 := RandNum(sl.MinAmount, sl.MaxAmount-1)
		n2 := RandNum(0, 99)
		//生成签到中奖记录
		rl = RewardLog{
			BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
			GameId:      gId,
			Account:     account,
			GiftId:      sl.Id,
			GiftName:    sl.Name,
			GiftContent: fmt.Sprintf("%d.%d", n1, n2),
			Delivered:   0}
		giftContent = fmt.Sprintf("%d.%d", n1, n2)
		//抽奖
		// -----------开始抽奖--------------
		// 先判断是否内定, 内定成功则返回奖品，否则继续进行随机抽奖
		var am AssignMember
		qs := o.QueryTable(new(AssignMember)).Filter("GameId", gId).Filter("Account", account).Filter("Enabled", 0)
		qs = qs.Limit(1)
		err = qs.One(&am, "Id", "GiftId")
		if err == nil {
			gift := Gift{BaseModel: BaseModel{Id: am.GiftId}}
			err = o.Read(&gift)
			if err == nil {
				var num int64
				// 抽中则减掉1个奖品
				num, err = o.QueryTable(new(Gift)).Filter("Id", gift.Id).Filter("Quantity__gt", 0).Update(orm.Params{
					"Quantity": orm.ColValue(orm.ColMinus, 1),
				})
				rl1 = RewardLog{
					BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
					GameId:      gId,
					Account:     account,
					GiftId:      gift.Id,
					GiftName:    gift.Name,
					GiftContent: gift.Content,
					Category:    1,
					Delivered:   0}
				giftContent = fmt.Sprintf("%d.%d", n1, n2)
				if num != 1 || err != nil {
					beego.Error("Lotterycontroller error", err)
					o.Rollback()
				}
				//更新内定记录
				am := AssignMember{BaseModel: BaseModel{Id: am.Id}, Enabled: 1}
				_, err = o.Update(&am, "Enabled")
				if err != nil {
					beego.Error("Lotterycontroller error", err)
					o.Rollback()
					code = 0
					msg = "操作失败，请刷新后重试"
					return
				}

				data["gift"] = gift.Content
				data["photo"] = gift.Photo
				data["seq"] = strconv.FormatInt(int64(gift.Seq), 10)
			}
		} else {
			// 非内定的情况
			var giftList []Gift
			qs = o.QueryTable(new(Gift))
			cond := orm.NewCondition()
			cond = cond.AndCond(cond.AndCond(cond.And("Probability__gt", 0).And("Quantity__gt", 0)).Or("GiftType", 0))
			cond = cond.And("GameId", gId)
			qs = qs.SetCond(cond)
			// 按礼物类型降序，目的是为了防止设置了多个未中奖的情况，让未中奖的排在最后，选出随机数后，判断区间的时候不会重复计算
			// 按概率降序，目的是判断区间的时候尽快判断出所在区间
			qs = qs.OrderBy("-GiftType", "-Probability", "Id")
			num, err := qs.All(&giftList, "Id", "Seq", "Name", "Probability", "Quantity", "GiftType", "Content", "Photo", "BroadcastFlag")
			if err != nil {
				beego.Error("Lotterycontroller error", err)
				msg = "活动获取错误，请刷新后重试(4)"
				return
			}
			//如果奖品不为0生成额外的中奖记录;
			if num > 0 {
				var total int
				for _, v := range giftList {
					total = total + v.Probability
				}
				// 当概率小于100时，做一个概率调整，增加未中奖的概率，使总和达到100
				if total < 100 {
					total = 100
				}
				rand := RandNum(1, total)
				total = 0 // 重置为0，用于第二次统计
				for _, v := range giftList {
					total = total + v.Probability
					if rand > total {
						continue
					}
					/*var num int64*/
					// 抽中则减掉1个奖品
					_, err = o.QueryTable(new(Gift)).Filter("Id", v.Id).Filter("Quantity__gt", 0).Update(orm.Params{
						"Quantity": orm.ColValue(orm.ColMinus, 1),
					})
					rl1 = RewardLog{
						BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
						GameId:      gId,
						Account:     account,
						GiftId:      v.Id,
						GiftName:    v.Name,
						GiftContent: v.Content,
						Category:    1,
						Delivered:   0}
					giftContent = fmt.Sprintf("%d.%d", n1, n2)
					if err != nil {
						beego.Error("Lotterycontroller error", err)
						o.Rollback()
						code = 0
						msg = "操作失败，请刷新后重试"
						return
					}
					data["gift"] = v.Content
					data["photo"] = v.Photo
					data["seq"] = strconv.FormatInt(int64(v.Seq), 10)
					break
				}
			}
		}
	}
	data["levelName"] = levelName
	data["nextlevlelNme"] = nextlevlelNme
	// 更新会员签到信息
	time1, err5 := time.ParseInLocation("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+"00:00:00", time.Local)
	//time1,err5 := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+"00:00:00")
	if err5 != nil {
		msg = "签到异常，请重试（时间）"
		return
	}
	var member2 Member
	err3 := o.QueryTable(new(Member)).Filter("Account", account).One(&member2)
	if err3 != nil {
		msg = "签到失败请联系客服（6）"
		return
	}
	//因为会员首次导入时间为默认的，所以签到的时候无法过滤时间
	/*lastsignindate := member2.LastSigninDate.Format("2006-01-02 15:04:05")
	defaultlastsignindate := "0001-01-01 00:00:00"*/
	if member2.LastSigninDate.IsZero() {
		if num, err := o.QueryTable(new(Member)).Filter("Account", account).Update(orm.Params{
			"LastSigninDate": time.Now(),
			"Level":          level,
			"LevelName":      levelName,
			"Force":          orm.ColValue(orm.ColAdd, signinper),
		}); err != nil || num != 1 {
			o.Rollback()
			beego.Error("时间错误", err)
			msg = "签到异常，请重试(8)"
			return
		}
	} else {
		if num, err := o.QueryTable(new(Member)).Filter("Account", account).Filter("LastSigninDate__lt", time1).Update(orm.Params{
			"LastSigninDate": time.Now(),
			"Level":          level,
			"LevelName":      levelName,
			"Force":          orm.ColValue(orm.ColAdd, signinper),
		}); err != nil || num != 1 {
			o.Rollback()
			beego.Error("时间错误", err)
			msg = "签到异常，请重试(9)"
			return
		}
	}
	if rl.GiftContent != "" {
		if _, err := o.Insert(&rl); err != nil {
			o.Rollback()
			msg = "签到失败，请重试(11)"
			return
		}
		data["giftContent"] = giftContent
	}
	if rl1.GiftContent != "" {
		if _, err := o.Insert(&rl1); err != nil {
			o.Rollback()
			msg = "签到失败，请重试(12)"
			return
		}
	}
	o.Commit()
	msg = "签到成功！"
	code = 1
}

func (this *SigninApiController) SigninPage() {
	data := make(map[string]interface{})
	gId, err := this.GetInt64("gid", 0)
	if err != nil {
		gId = 0
	}
	page, err := this.GetInt("page", 1)
	if err != nil {
		page = 1
	}
	commentlist, total := new(Comment).PaginateFront(page, 10, gId)
	setAccount(commentlist)
	data["commentlist"] = commentlist
	data["total"] = total
	this.Data["json"] = data
	this.ServeJSON()
}

//会员账号不存在
func nomember(member string, gId int64) (code int, msg string, data1 map[string]string) {
	var data = make(map[string]string)
	//验证手机号是否正确
	if hasError, errMsg := validate(member); hasError {
		msg = errMsg
		return 0, msg, data
	}
	//查询中奖记录，查看是否已经签到过
	var rewardlog RewardLog
	o := orm.NewOrm()
	o.QueryTable(new(RewardLog)).Filter("GameId", gId).Filter("Account", member).OrderBy("-CreateDate").One(&rewardlog)
	today, _ := time.ParseInLocation("2006-01-02", time.Now().Format("2006-01-02"), time.Local)
	if today.Before(rewardlog.CreateDate) {
		code = 2
		msg = "今日您已签到过，请明天再来吧！"
		return code, msg, data
	}
	// 查询活动属性配置
	var gaList []GameAttribute
	if _, err := o.QueryTable(new(GameAttribute)).Filter("GameId", gId).All(&gaList, "Code", "Value"); err != nil {
		msg = "活动获取失败，请重试"
		return
	}
	var signinper int64
	var signinunit string
	for _, v := range gaList {
		switch v.Code {
		case utils.Signinper:
			signinper, _ = strconv.ParseInt(v.Value, 10, 64)
		case utils.Signinunit:
			signinunit = v.Value
		}
	}
	// 查询签到等级配置信息
	var sl SigninLevel
	data["unit"] = signinunit
	data["per"] = fmt.Sprintf("%d", signinper)
	qs := o.QueryTable(new(SigninLevel)).Filter("GameId", gId).OrderBy("Level")
	err := qs.Limit(1).One(&sl)
	if err != nil && err != orm.ErrNoRows {
		msg = "签到失败，请重试"
		return 0, msg, data
	}
	// 事务开始
	o.Begin()
	// 有匹配的等级
	n1 := RandNum(sl.MinAmount, sl.MaxAmount-1)
	n2 := RandNum(0, 99)
	rl := RewardLog{
		BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
		GameId:      gId,
		Account:     member,
		GiftId:      sl.Id,
		GiftName:    sl.Name,
		GiftContent: fmt.Sprintf("%d.%d", n1, n2),
		Delivered:   0}
	if _, err := o.Insert(&rl); err != nil {
		o.Rollback()
		msg = "签到失败，请重试"
		return
	}
	data["giftContent"] = rl.GiftContent
	o.Commit()
	return 3, "签到成功", data
}

//验证信息
func validate(account string) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Mobile(account, "errmsg").Message("未注册会员账号，请填写手机号进行签到")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type SigninCarveUPApiController struct {
	beego.Controller
}

func (this *SigninCarveUPApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *SigninCarveUPApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	//获取瓜分图片
	var gameattributes GameAttribute
	o := orm.NewOrm()
	err := o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code", "signinimg").One(&gameattributes)
	if err != nil || gameattributes.Value == "" {
		this.Redirect(fmt.Sprintf("/signin?gid=%d", gId), http.StatusFound)
	}
	this.Data["carveimg"] = gameattributes.Value
	this.TplName = "front/signin/carveup.tpl"
}

func (this *SigninCarveUPApiController) Post() {
	id, _ := this.GetInt64("id")
	var code int
	var msg string
	var url = beego.URLFor("SigninCarveUPApiController.Get", "gid", id)
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	account := strings.TrimSpace(this.GetString("account"))
	mobile := strings.TrimSpace(this.GetString("mobile"))
	name := strings.TrimSpace(this.GetString("name"))
	o := orm.NewOrm()
	//查询瓜分奖励
	var ga GameAttribute
	err := o.QueryTable(new(GameAttribute)).Filter("GameId", id).Filter("Code", "signincarve").One(&ga)
	if err != nil {
		beego.Error("获取瓜分奖励失败", err)
		code = 2
	}
	//在抽奖次数中验证，会员是否有瓜分资格
	bool := o.QueryTable(new(MemberLottery)).Filter("GameId", id).Filter("Account", account).Exist()
	if bool {
		giftname := "有资格"
		code = 1
		msg = ga.Value
		//生成中奖记录
		if mobile != "" {
			if hasError, errMsg := validatee(mobile); hasError {
				code = 2
				msg = errMsg
				return
			}
			o.Begin()
			str := name + " " + mobile
			rl := RewardLog{
				BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
				GameId:      id,
				GiftName:    giftname,
				Account:     account,
				GiftId:      0,
				GiftContent: str,
				Delivered:   0}
			_, err := o.Insert(&rl)
			if err != nil {
				beego.Error("signin insert error", err)
				o.Rollback()
			}
			o.Commit()
		}
		this.StopRun()
	} else {
		msg = "您未达到瓜分条件，不能进行瓜分"
		giftname := "没有资格"
		code = 2
		//生成中奖记录
		if mobile != "" {
			if hasError, errMsg := validatee(mobile); hasError {
				code = 2
				msg = errMsg
				return
			}
			o.Begin()
			str := name + " " + mobile
			rl := RewardLog{
				BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
				GameId:      id,
				GiftName:    giftname,
				Account:     account,
				GiftId:      0,
				GiftContent: str,
				Delivered:   0}
			_, err := o.Insert(&rl)
			if err != nil {
				beego.Error("signin insert error", err)
				o.Rollback()
			}
			o.Commit()
		}
		this.StopRun()
	}
}

func validatee(mobile string) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Length(mobile, 11, "errmsg").Message("手机号码格式不正确请重新输入")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

//添加评论

type AddMomentApiController struct {
	sysmanage.BaseController
}

func (this *AddMomentApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *AddMomentApiController) Post() {
	account := strings.TrimSpace(this.GetString("account"))
	content := this.GetString("content")
	gameid, _ := this.GetInt64("gameid")

	//会员如果不存在，不能进行评论
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	o := orm.NewOrm()
	booll, mssg := CheckGame(gameid, account)
	if !booll {
		msg = mssg
		return
	}
	bool := o.QueryTable(new(Member)).Filter("Account", account).Exist()
	if bool == false {
		msg = "会员账号不存在，请注册后进行评论"
		return
	}
	//判断今天留过言的话，不能再进行留言
	var commet Comment
	o.QueryTable(new(Comment)).Filter("Account", account).OrderBy("-CreateDate").One(&commet)
	today, _ := time.ParseInLocation("2006-01-02", time.Now().Format("2006-01-02"), time.Local)
	if today.Before(commet.CreateDate) {
		msg = "今天您已经留过言了，明天再来吧"
		return
	}
	//留言内容不能为空
	if len(content) == 0 {
		msg = "留言内容不能为空~~~"
		return
	}
	//留言内容不能超过100字
	if utf8.RuneCountInString(content) > 99 {
		msg = "留言内容不能超过100个字，请重新留言~~"
		return
	}
	var comment Comment
	comment.Account = account
	comment.Content = content
	comment.GameId = gameid
	comment.Tag = 0
	comment.Status = 0
	if err := this.ParseForm(&comment); err != nil {
		beego.Error("添加评论失败", err)
		msg = "参数异常，请重试"
		return
	}
	if _, err := comment.Create(); err != nil {
		beego.Error("生成评论失败", err)
		msg = "添加失败，请重试"
		return
	}

	code = 1
	msg = "恭喜您,留言成功！~"
	return
}

func setAccount(commentList []Comment) {
	for i, wish := range commentList {
		//判断会员账号中是否存在中文字符，如果存在跳过（一个中文字字符占3位，在下面进行截取的时候会出现下标越界的问题）
		var hzRegexp = regexp.MustCompile("^[\u4e00-\u9fa5]$")
		if hzRegexp.MatchString(wish.Account) {
			continue
		}
		wish.Account = SubString(wish.Account, 0, 2) + "***" + SubString(wish.Account, len(wish.Account)-2, 2)
		commentList[i] = wish
	}
}

func (this *SigninApiController) QueryDynamic() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	account := strings.TrimSpace(this.GetString("account"))
	var member Member
	o := orm.NewOrm()
	err := o.QueryTable(new(Member)).Filter("Account", account).One(&member)
	if err != nil {
		beego.Error("获取会员信息失败", err)
		msg = "会员账号不存在"
		return
	}
	code = 1
	msg = fmt.Sprintf("您的活力值为%d", member.Dynamic)
	return
}
