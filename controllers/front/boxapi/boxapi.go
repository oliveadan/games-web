package boxapi

import (
	"fmt"
	. "games-web/controllers/front"
	. "games-web/models/common"
	. "games-web/models/gamedetail/box"
	. "games-web/models/rewardlog"
	. "games-web/utils"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"phage/models/system"
	. "phage/utils"
	"strconv"
	"strings"
	"time"
)

type BoxApiController struct {
	beego.Controller
}

func (this *BoxApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *BoxApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	o := orm.NewOrm()
	SetGameData1(&this.Controller, &gId)
	//将四个宝箱对应的id传入前端，用于抽奖
	var box Box
	o.QueryTable(new(Box)).Filter("GameId", gId).One(&box)
	//查询次数
	var account string
	if accountSes := this.GetSession("frontloginaccount"); accountSes != nil {
		account = accountSes.(string)
	}
	//会员账号不为空时，取会员数据
	//青铜宝箱次数
	var bronzebox int
	if account != "" {
		var ml MemberLottery
		err := o.QueryTable(new(MemberLottery)).Filter("Gameid", box.BronzeboxId).Filter("Account", account).One(&ml, "LotteryNums")
		if err == nil {
			bronzebox = ml.LotteryNums
		}
	}
	//白银宝箱次数
	var silverbox int
	if account != "" {
		var ml MemberLottery
		err := o.QueryTable(new(MemberLottery)).Filter("Gameid", box.SilverboxId).Filter("Account", account).One(&ml, "LotteryNums")
		if err == nil {
			silverbox = ml.LotteryNums
		}
	}
	//黄金宝箱次数
	var goldbox int
	if account != "" {
		var ml MemberLottery
		err := o.QueryTable(new(MemberLottery)).Filter("Gameid", box.GoldboxId).Filter("Account", account).One(&ml, "LotteryNums")
		if err == nil {
			goldbox = ml.LotteryNums
		}
	}
	//至尊宝箱次数
	var extremebox int
	if account != "" {
		var ml MemberLottery
		err := o.QueryTable(new(MemberLottery)).Filter("Gameid", box.ExtremeboxId).Filter("Account", account).One(&ml, "LotteryNums")
		if err == nil {
			extremebox = ml.LotteryNums
		}
	}
	SetRewardList1(&this.Controller, box)
	this.Data["bronzeboxNums"] = bronzebox
	this.Data["silverboxNums"] = silverbox
	this.Data["goldboxNums"] = goldbox
	this.Data["extremeboxNums"] = extremebox
	this.Data["bronzeboxId"] = box.BronzeboxId
	this.Data["silverboxId"] = box.SilverboxId
	this.Data["goldboxId"] = box.GoldboxId
	this.Data["extremeboxId"] = box.ExtremeboxId
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/box/index-wap.tpl"
	} else {
		this.TplName = "front/box/index-pc.tpl"
	}
}

func (this *BoxApiController) LotteryQuery() {
	var code int
	var msg string
	var data = make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	var page int
	if page, err = this.GetInt("page", 1); err != nil {
		page = 1
	}
	var limit int
	if limit, err = this.GetInt("pagesize", 5); err != nil {
		limit = 5
	}

	// 验证
	if err != nil {
		msg = "活动获取失败，请刷新后重试(1)"
		return
	}
	if account == "" {
		msg = "会员账号不能为空"
		return
	}
	limit = 10000
	offset := (page - 1) * limit
	o := orm.NewOrm()
	//获取绑定的宝箱id
	var box Box
	err1 := o.QueryTable(new(Box)).Filter("GameId", gId).One(&box)
	if err1 != nil {
		msg = "系统异常,刷新后重试"
		return
	}
	var rlList []RewardLog
	var list = make([]map[string]string, 0)
	qs := o.QueryTable(new(RewardLog))
	qs = qs.Filter("GameId__in", box.BronzeboxId, box.SilverboxId, box.GoldboxId, box.ExtremeboxId).Filter("Account", account)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	if _, err = qs.All(&rlList, "Account", "GiftContent", "GiftName", "Delivered", "CreateDate"); err != nil {
		msg = "查询失败，请刷新后重试(2)"
		return
	}
	var gift string
	for _, v := range rlList {
		if v.GiftContent == "" {
			gift = v.GiftName
		} else {
			gift = v.GiftContent + " - " + v.GiftName
		}

		list = append(list, map[string]string{
			"account":    v.Account,
			"gift":       gift,
			"delivered":  strconv.FormatInt(int64(v.Delivered), 10),
			"createDate": v.CreateDate.Format("2006-01-02 15:04")})
	}
	var total int64
	if total, err = qs.Count(); err != nil {
		msg = "查询失败，请刷新后重试(3)"
		return
	}
	data["total"] = total
	data["list"] = list
	code = 1
	msg = "查询成功"
}

func SetRewardList1(c *beego.Controller, box Box) []map[string]string {
	var list []RewardLog
	o := orm.NewOrm()
	o.QueryTable(new(RewardLog)).Filter("GameId__in", box.BronzeboxId, box.SilverboxId, box.GoldboxId, box.ExtremeboxId).Limit(40).OrderBy("-Id").All(&list, "Account", "GiftName", "GiftContent")
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

// 设置首页通用数据
func SetGameData1(c *beego.Controller, gId *int64) {
	var game1 Game
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
	//匹配id
	var matchId Box
	cond := orm.NewCondition()
	err := qs.One(&game1)
	qs1 := o.QueryTable(new(Box))
	cond1 := cond.And("GameId", game1.Id).Or("BronzeboxId", gId).Or("SilverboxId", gId).Or("GoldboxId", gId).Or("ExtremeboxId", gId)
	qs = qs.SetCond(cond1)
	qs1.One(&matchId, "GameId")
	var game Game
	o.QueryTable(new(Game)).Filter("Id", matchId.GameId).One(&game)
	// 站点信息
	sc := system.GetSiteConfigMap(Scname, Sccust, Scofficial, Scregister, Scpartner, Scpromotion, Scfqa, Screcharge)
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
	c.Data["officialRegist"] = sc[Scregister]
	c.Data["officialPartner"] = sc[Scpartner]
	c.Data["officialPromot"] = sc[Scpromotion]
	c.Data["officialFqa"] = sc[Scfqa]
	c.Data["nowdt"] = time.Now()
	var starttimeformat = game.StartTime.Format("2006/01/02 15:04:05")
	c.Data["starttime"] = starttimeformat
}
