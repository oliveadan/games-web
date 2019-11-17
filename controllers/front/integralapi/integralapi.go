package integralapi

import (
	. "games-web/controllers/front"
	. "games-web/models/common"
	. "games-web/models/gift"
	. "games-web/models/rewardlog"
	. "phage/models"
	. "phage/utils"
	"strings"
	"time"

	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type IntegralApiController struct {
	beego.Controller
}

func (this *IntegralApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *IntegralApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)
	game := GetGame(gId)
	version := fmt.Sprintf("%d", game.GameVersion)
	var giftList []Gift
	o := orm.NewOrm()
	qs := o.QueryTable(new(Gift)).Filter("GameId", gId).Filter("Quantity__gt", 0)
	qs = qs.OrderBy("Probability", "Seq", "Id")
	qs.All(&giftList, "Id", "Seq", "Name", "Content", "Photo", "BroadcastFlag")
	var travel []Gift
	var phone []Gift
	var money []Gift
	var thing []Gift
	for _, v := range giftList {
		switch v.Name {
		case "旅游券":
			travel = append(travel, v)
			break
		case "话费券":
			phone = append(phone, v)
			break
		case "现金券":
			money = append(money, v)
			break
		case "实物券":
			thing = append(thing, v)
			break
		default:
			break
		}
	}
	this.Data["giftList"] = giftList
	this.Data["travel"] = travel
	this.Data["phone"] = phone
	this.Data["money"] = money
	this.Data["thing"] = thing
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/integral/index-wap-v" + version + ".tpl"
	} else {
		this.TplName = "front/integral/index-pc-v" + version + ".tpl"
	}
}

func (this *IntegralApiController) Iframe() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)

	var giftList []Gift
	o := orm.NewOrm()
	qs := o.QueryTable(new(Gift)).Filter("GameId", gId).Filter("Quantity__gt", 0)
	qs = qs.OrderBy("Probability", "Seq", "Id")
	qs.All(&giftList, "Id", "Seq", "Name", "Content", "Photo", "BroadcastFlag")
	this.Data["giftList"] = giftList
	this.TplName = "front/integral/iframe.html"
}

func (this *IntegralApiController) Post() {
	var code int
	var msg string
	defer Retjson(this.Ctx, &msg, &code)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	if err != nil {
		msg = "活动获取失败，请刷新后重试(1)"
		return
	}
	//验证接口
	o := orm.NewOrm()
	var game Game
	if err = o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "GameType"); err != nil {
		msg = "活动获取失败，请刷新后重试！"
		return
	}
	if game.GameType != "integral" {
		beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
		msg = "违法使用接口，警告一次！"
		return
	}

	giftId, err := this.GetInt64("giftid", 0)
	if err != nil {
		msg = "活动获取失败，请刷新后重试(2)"
		return
	}
	if this.GetSession("frontloginaccount") == nil || this.GetSession("frontloginaccount").(string) != account {
		msg = "登录过期，请重新登录"
		return
	}
	// 通用验证
	var ok bool
	if ok, msg = CheckGame(gId, account); !ok {
		return
	}
	var gift Gift
	if err = o.QueryTable(new(Gift)).Filter("Id", giftId).Filter("GameId", gId).One(&gift); err != nil {
		beego.Error("IntegralApiController error", err)
		msg = "兑换失败，请刷新后重试"
		return
	}
	o.Begin()
	qs := o.QueryTable(new(MemberLottery))
	qs = qs.Filter("GameId", gId).Filter("Account", account).Filter("LotteryNums__gte", gift.Seq)
	num, err := qs.Update(orm.Params{
		"LotteryNums": orm.ColValue(orm.ColMinus, gift.Seq),
	})
	if err != nil {
		beego.Error("IntegralApiController error", err)
		msg = "兑换失败，请刷新后重试"
		o.Rollback()
		return
	}
	if num != 1 {
		msg = "兑换失败，请检查积分是否充足。"
		o.Rollback()
		return
	}
	// 抽奖记录中添加一条记录
	rl := RewardLog{
		BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
		GameId:      gId,
		Account:     account,
		GiftId:      gift.Id,
		GiftName:    gift.Name,
		GiftContent: gift.Content,
		Delivered:   0}
	_, err = o.Insert(&rl)
	if err != nil {
		beego.Error("IntegralApiController error", err)
		o.Rollback()
		msg = "操作失败，请刷新后重试"
		return
	}
	o.Commit()
	code = 1
	msg = "恭喜您！积分兑换成功！"
}

func (this *IntegralApiController) Explain() {

	this.TplName = "front/integral/explain.html"
}
