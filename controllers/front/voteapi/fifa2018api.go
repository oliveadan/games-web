package voteapi

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/vote"
	. "phage/utils"
	"strings"
)

type Fifa2018ApiController struct {
	beego.Controller
}

func (this *Fifa2018ApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *Fifa2018ApiController) Get() {
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
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/vote/fifa2018/index-wap.tpl"
	} else {
		this.TplName = "front/vote/fifa2018/index-pc.tpl"
	}
}

func (this *Fifa2018ApiController) Teams() {
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
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/vote/fifa2018/teams-wap.tpl"
	} else {
		this.TplName = "front/vote/fifa2018/teams-pc.tpl"
	}
}

func (this *Fifa2018ApiController) Vote() {
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
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	var list []VoteItem
	o := orm.NewOrm()
	qs := o.QueryTable(new(VoteItem))
	qs = qs.Filter("GameId", gId)
	qs = qs.OrderBy("Seq", "Id")
	qs.All(&list, "Id", "Name", "NumVote", "NumAdjust")

	var prize string
	gaAttrs := GetGameAttributes(gId)
	if len(gaAttrs) > 0 {
		prize = gaAttrs[0].Value
	}

	this.Data["prize"] = prize
	this.Data["voteItemList"] = list
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/vote/fifa2018/vote-wap.tpl"
	} else {
		this.TplName = "front/vote/fifa2018/vote-pc.tpl"
	}
}
