package pokerapi

import (
	. "games-web/controllers/front"
	. "phage/utils"

	"github.com/astaxie/beego"
)

type PokerApiController struct {
	beego.Controller
}

func (this *PokerApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *PokerApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/poker/index-wap.tpl"
	} else {
		this.TplName = "front/poker/index-pc.tpl"
	}
}
