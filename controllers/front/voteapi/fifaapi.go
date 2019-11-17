package voteapi

import (
	"fmt"
	. "games-web/controllers/front"
	. "games-web/models/common"
	. "games-web/models/gamedetail/vote"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/utils"
	"strconv"
	"strings"
)

type FifaApiController struct {
	beego.Controller
}

func (this *FifaApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *FifaApiController) Get() {
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
		this.TplName = "front/vote/fifa/index-wap.tpl"
	} else {
		this.TplName = "front/vote/fifa/index-pc.tpl"
	}
}

func (this *FifaApiController) Teams() {
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
		this.TplName = "front/vote/fifa/teams-wap.tpl"
	} else {
		this.TplName = "front/vote/fifa/teams-pc.tpl"
	}
}

func (this *FifaApiController) Vote() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	var list []VoteItem
	o := orm.NewOrm()
	qs := o.QueryTable(new(VoteItem))
	qs = qs.Filter("GameId", gId)
	qs = qs.OrderBy("Seq", "Id")
	qs.All(&list, "Id", "Name", "NumVote", "NumAdjust")

	gaAttrs := GetGameAttributes(gId)
	var prizeMap = make(map[int64]string)
	if len(gaAttrs) > 0 {
		voteFactor, err := strconv.ParseFloat(gaAttrs[0].Value, 64)
		if err == nil {
			// map的key为选票id，[]float64中，0：奖池金额；1：每人分得金额
			// 计算奖池
			var totalVote int // 所有选票的总票数
			for _, v := range list {
				totalVote = totalVote + v.NumVote + v.NumAdjust
			}
			for _, v := range list {
				nums := v.NumVote + v.NumAdjust
				if nums < 0 {
					prizeMap[v.Id] = "0"
				} else {
					amount := float64(totalVote-nums) * voteFactor
					prizeMap[v.Id] = fmt.Sprintf("%.2f", amount)
				}
			}
		}
	}

	this.Data["prizeMap"] = prizeMap
	this.Data["voteItemList"] = list
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/vote/fifa/vote-wap.tpl"
	} else {
		this.TplName = "front/vote/fifa/vote-pc.tpl"
	}
}
