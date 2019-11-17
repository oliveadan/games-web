package front

import (
	"fmt"
	. "games-web/models/common"
	. "games-web/models/gift"
	. "games-web/models/rewardlog"
	. "games-web/utils"
	"net/http"
	"phage/models/system"
	. "phage/utils"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context"
	"github.com/astaxie/beego/orm"
	"net/url"
	"phage/controllers/sysmanage"
)

type DoorController struct {
	beego.Controller
}

func (this *DoorController) Prepare() {
	this.EnableXSRF = false
}

func (this *DoorController) Get() {
	isNavOpen := system.GetSiteConfigValue(Scnavopen)
	if isNavOpen == "1" { // 开启导航模式
		this.GetNav()
	} else {
		this.GetGame()
	}
}

func (this *DoorController) GetNav() {
	var list []Game
	o := orm.NewOrm()
	qs := o.QueryTable(new(Game)).Filter("Deleted", 0).Limit(50)
	qs.OrderBy("-StartTime", "-Id").All(&list, "Id", "Name", "Announcement", "GameType", "StartTime", "EndTime", "Enabled")

	sc := system.GetSiteConfigMap(Scname, Sccust, Scofficial, Scregister, Scpartner, Scpromotion, Scfqa, Screcharge)

	this.Data["list"] = list
	this.Data["siteName"] = sc[Scname]
	this.Data["rechargeSite"] = sc[Screcharge]
	this.Data["custServ"] = sc[Sccust]
	this.Data["officialSite"] = sc[Scofficial]
	this.Data["officialRegist"] = sc[Scregister]
	this.Data["officialPartner"] = sc[Scpartner]
	this.Data["officialPromot"] = sc[Scpromotion]
	this.Data["officialFqa"] = sc[Scfqa]
	this.Data["nowdt"] = time.Now()
	this.TplName = "front/index-pc.tpl"
}

func (this *DoorController) GetGame() {
	// 判断在微信，qq内访问，则提示使用浏览器
	ua := this.Ctx.Input.UserAgent()
	if strings.Contains(ua, "MicroMessenger") {
		this.Data["isWap"] = IsWap(ua)
		this.TplName = "front/tencent.tpl"
		return
	} else if strings.Contains(ua, "QQ/") && IsWap(ua) {
		this.Data["isWap"] = true
		this.TplName = "front/tencent.tpl"
		return
	}
	domain := strings.TrimPrefix(this.Ctx.Input.Domain(), "www.")

	var game Game
	o := orm.NewOrm()
	qs := o.QueryTable(new(Game))
	qs = qs.Filter("Deleted", 0).Filter("BindDomain__contains", domain)
	qs.Limit(1)
	err := qs.One(&game, "Id", "GameType")
	if err == nil && game.GameType != "" {
		this.Redirect(fmt.Sprintf("/%s?gid=%d", game.GameType, game.Id), http.StatusFound)
		return
	} else if err != nil {
		beego.Info(domain, this.Ctx.Input.IP(), "doorerr get err-1", err)
	}

	qs = o.QueryTable(new(Game))
	qs = qs.Filter("Deleted", 0).Filter("Enabled", 1).Filter("BindDomain", "")
	qs = qs.Filter("StartTime__lte", time.Now().Format("2006-01-02 15:04:05"))
	qs = qs.Filter("EndTime__gte", time.Now().Format("2006-01-02 15:04:05"))
	qs = qs.OrderBy("-Id")
	qs.Limit(1)
	err = qs.One(&game, "Id", "GameType")
	if err == nil && game.GameType != "" {
		this.Redirect(fmt.Sprintf("/%s?gid=%d", game.GameType, game.Id), http.StatusFound)
		return
	} else if err != nil {
		beego.Info(domain, this.Ctx.Input.IP(), "doorerr get err-2", err)
	}
	this.TplName = "404.tpl"
}

func Retjson(ctx *context.Context, msg *string, code *int, data ...interface{}) {
	ret := make(map[string]interface{})
	ret["code"] = code
	ret["msg"] = msg
	if len(data) > 0 {
		ret["data"] = data[0]
	}
	ctx.Output.JSON(ret, false, false)
}

// 设置首页通用数据
func SetGameData(c *beego.Controller, gId *int64) {
	var game Game
	var msg string
	o := orm.NewOrm()
	qs := o.QueryTable(new(Game))
	qs = qs.Filter("Deleted", 0)
	if *gId != 0 {
		qs = qs.Filter("Id", *gId)
	} else {
		gameType := strings.TrimLeft(c.Ctx.Input.URL(), "/")
		qs = qs.Filter("GameType", gameType).Filter("Enabled", 1)
		qs = qs.OrderBy("-Id")
		qs = qs.Limit(1)
	}
	err := qs.One(&game)
	// 站点信息
	sc := system.GetSiteConfigMap(Scname, Sccust, Scofficial, Scregister, Scpartner, Scpromotion, Scfqa, Screcharge, Scplatformreg)
	var timeing string
	var gameStatus int
	var countDown int64
	if err == orm.ErrNoRows {
		msg = "活动未开始"
	} else {
		*gId = game.Id
		if game.StartTime.Unix() > time.Now().Unix() {
			gameStatus = 1 // 等待开始
			countDown = game.StartTime.Unix() - time.Now().Unix()
			msg = fmt.Sprintf("%s开启活动，敬请关注！", game.StartTime.Format("2006-01-02 15:04"))
		} else if game.EndTime.Unix() < time.Now().Unix() {
			gameStatus = 2 // 活动已结束
			msg = fmt.Sprintf("长路漫漫，%s常相伴！", sc[Scname])
		} else {
			var periodList []GamePeriod
			nums, err := o.QueryTable(new(GamePeriod)).Filter("GameId", gId).OrderBy("StartTime").All(&periodList, "StartTime", "EndTime")
			if err != nil {
				beego.Error("DoorController SetGameData error", err)
				msg = "活动获取错误，请刷新后重试(3)"
			} else if nums > 0 { // 配置了时间段
				now, _ := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:04:05"))
				var firstStart time.Time
				for i, v := range periodList {
					start, err := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+v.StartTime)
					if err != nil {
						continue
					}
					if i == 0 {
						firstStart = start
					}
					end, err := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+v.EndTime)
					if err != nil {
						continue
					}
					if start.After(now) {
						gameStatus = 1 // 等待开始
						countDown = start.Unix() - now.Unix()
						break
					}
					if end.After(now) {
						timeing = v.StartTime
						gameStatus = 3 // 活动进行中
						countDown = end.Unix() - now.Unix()
						break
					}
				}
				if gameStatus == 0 { // 今天活动已结束，等待明天开始时间
					gameStatus = 1
					countDown = firstStart.AddDate(0, 0, 1).Unix() - now.Unix()
				}
			} else { // 未配置时间段
				gameStatus = 3 // 活动进行中
				countDown = game.EndTime.Unix() - time.Now().Unix()
			}
			subT := game.EndTime.Sub(time.Now())
			msg = fmt.Sprintf("活动进行中，还剩%d天%d小时%d分！", int(subT.Hours()/24), int(subT.Hours())%24, int(subT.Minutes())%60)
		}
	}
	c.Data["gameVersion"] = game.GameVersion
	c.Data["gameMsg"] = msg
	c.Data["gameStatus"] = gameStatus // 1:等待开始;2:活动已结束;3:活动进行中
	c.Data["countDown"] = countDown
	c.Data["gameId"] = *gId
	c.Data["gameDesc"] = game.Description
	c.Data["announcement"] = game.Announcement
	c.Data["gameRule"] = game.GameRule
	c.Data["gameStatement"] = game.GameStatement
	c.Data["siteName"] = sc[Scname]
	c.Data["rechargeSite"] = sc[Screcharge]
	c.Data["custServ"] = sc[Sccust]
	c.Data["officialSite"] = sc[Scofficial]
	if sc[Scplatformreg] != "" {
		c.Data["officialRegist"] = c.URLFor("RegisterController.Get", "tpl", sc[Scplatformreg], "redirect", url.QueryEscape(fmt.Sprintf("/%s?gid=%d", game.GameType, game.Id)))
	} else {
		c.Data["officialRegist"] = sc[Scregister]
	}
	c.Data["officialPartner"] = sc[Scpartner]
	c.Data["officialPromot"] = sc[Scpromotion]
	c.Data["officialFqa"] = sc[Scfqa]
	c.Data["nowdt"] = time.Now()
	c.Data["timeing"] = timeing
}

// 展示随机中奖记录接口
func (this *DoorController) RlList() {
	gId, _ := this.GetInt64("gid", 0)
	SetRewardList(&this.Controller, &gId)
	this.Data["json"] = this.Data["rlList"]
	this.ServeJSON()
}

// 设置中奖记录，用于滚动显示(随机从奖品中抽取展示)
// 格式为map的列表rlList： []map[string]string{account:"abc***",gift:"礼物1"}
func SetRewardListRand(c *beego.Controller, gId *int64) {
	var list []Gift
	o := orm.NewOrm()
	o.QueryTable(new(Gift)).Filter("GameId", gId).Filter("GiftType", 1).OrderBy("ModifyDate").All(&list, "Name", "Content")
	var rlList = make([]map[string]string, 0)
	var listlen = len(list)
	if listlen > 0 {
		var index = RandNum(0, listlen)
		for a := 0; a < 40; a++ {
			var gift string
			var v = list[(index+a)%listlen]
			if v.Content != "" {
				gift = v.Content
			} else {
				gift = v.Name
			}
			rlList = append(rlList, map[string]string{"account": RandStringLowerWithNum(3) + "***", "gift": gift})
		}
	}
	c.Data["rlList"] = rlList
}

// 设置中奖记录，用于滚动显示(真实中奖记录)
// 格式为map的列表rlList： []map[string]string{account:"abc***",gift:"礼物1"}
func SetRewardList(c *beego.Controller, gId *int64) []map[string]string {
	var list []RewardLog
	o := orm.NewOrm()
	o.QueryTable(new(RewardLog)).Filter("GameId", gId).Limit(40).OrderBy("-Id").All(&list, "Account", "GiftName", "GiftContent")
	var rlList = make([]map[string]string, 0)
	for _, v := range list {
		var gift string
		if v.GiftContent != "" {
			gift = v.GiftContent
		} else {
			gift = v.GiftName
		}
		rlList = append(rlList, map[string]string{"account": SubString(v.Account, 0, 3) + "***", "gift": gift})
	}
	c.Data["rlList"] = rlList
	return rlList
}

// 使用验证码的登录
func (this *DoorController) LoginCpt() {
	if !GetCpt().VerifyReq(this.Ctx.Request) {
		this.Data["json"] = map[string]interface{}{"code": 0, "msg": "验证码错误"}
		this.ServeJSON()
		return
	}
	this.Login()
}

// 参数：gid,account
// 返回：code,msg,data{lotteryNums:1}
// code=0 登录失败；code=1 登录成功   登录成功后将账号放入session中,session的键为frontloginaccount
func (this *DoorController) Login() {
	var code int
	var msg string
	var data = make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	// 验证
	if err != nil || gId == 0 {
		msg = "活动获取失败，请刷新后重试(1)"
		return
	}
	if account == "" {
		msg = "会员账号不能为空！~~"
		return
	}
	o := orm.NewOrm()
	if isExists := o.QueryTable(new(Member)).Filter("Account", account).Exist(); !isExists {
		msg = "该账号暂无资格，请您确认活动要求"
		return
	}
	if isExist := o.QueryTable(new(Game)).Filter("Id", gId).Exist(); !isExist {
		msg = "活动获取失败，请刷新后重试(2)"
		return
	}

	// -------------------获取会员数据-------------------
	// 剩余次数
	var ml MemberLottery
	err = o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).One(&ml, "LotteryNums")
	//if err == orm.ErrNoRows {
	//	msg = "您还未达标，无法参与"
	//	return
	//} else if err != nil && err != orm.ErrNoRows {
	//	msg = "活动获取失败，请刷新后重试(3)"
	//	return
	//}
	this.SetSession("frontloginaccount", account)
	data["lotteryNums"] = ml.LotteryNums
	code = 1
	msg = "登录成功"
}

func (this *DoorController) Logout() {
	this.DelSession("frontloginaccount")
	homepage := this.GetString("url")
	if homepage != "" {
		this.Redirect(homepage, http.StatusFound)
	} else {
		this.ServeJSON()
	}

}

func (this *DoorController) Query() {
	gId, _ := this.GetInt64("gid", 0)
	this.Data["gameId"] = gId
	this.TplName = "front/query-wap.tpl"
}

//查询邀请码
func (this *DoorController) QueryInvitationCode() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	account := strings.TrimSpace(this.GetString("account"))
	var member Member
	o := orm.NewOrm()
	err := o.QueryTable(new(Member)).Filter("Account", account).One(&member)
	if err != nil {
		msg = "会员账号不存在哦~~"
		return
	}
	if member.InvitationCode == "" {
		msg = "您没有邀请码"
		return
	}
	code = 1
	msg = member.InvitationCode
	return
}
