package tigerapi

import (
	. "games-web/controllers/front"
	. "phage/utils"

	"github.com/astaxie/beego"
)

type TigerApiController struct {
	beego.Controller
}

func (this *TigerApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *TigerApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/tiger/index-wap.tpl"
	} else {
		this.TplName = "front/tiger/index-pc.tpl"
	}
}
