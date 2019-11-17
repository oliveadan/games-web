package upgradingapi

import (
	"github.com/astaxie/beego"
	. "phage-games-web/controllers/front"
)

type UpgradingIframeController struct {
	beego.Controller
}

func (this *UpgradingIframeController) Prepare() {
	this.EnableXSRF = false
}

func (this *UpgradingIframeController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	SetGameData(&this.Controller, &gId)
	this.TplName = "front/upgrading/iframe.html"
}
