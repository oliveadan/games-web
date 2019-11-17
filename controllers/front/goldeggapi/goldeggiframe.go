package goldeggapi

import (
	. "games-web/controllers/front"
	"github.com/astaxie/beego"
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
