package goldeggapi

import (
	"github.com/astaxie/beego"
	. "phage-games-web/controllers/front"
)

type GoldeggIframeController struct {
	beego.Controller
}

func (this *GoldeggIframeController) Prepare() {
	this.EnableXSRF = false
}

func (this *GoldeggIframeController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)

	this.TplName = "front/goldegg/iframe.html"
}
