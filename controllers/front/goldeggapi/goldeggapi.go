package goldeggapi

import (
	. "phage-games-web/controllers/front"
	. "phage/utils"

	"github.com/astaxie/beego"
)

type GoldeggApiController struct {
	beego.Controller
}

func (this *GoldeggApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *GoldeggApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/goldegg/index-wap.tpl"
	} else {
		this.TplName = "front/goldegg/index-pc.tpl"
	}
}
