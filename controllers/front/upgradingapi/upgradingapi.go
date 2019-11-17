package upgradingapi

import (
	"github.com/astaxie/beego"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/gamedetail/upgrading"
	"strings"
)

type UpgradingApiController struct {
	beego.Controller
}

func (this *UpgradingApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *UpgradingApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	SetGameData(&this.Controller, &gId)
	this.TplName = "front/upgrading/index-pc.tpl"
}

func (this *UpgradingApiController) Query() {
	var data = make(map[string]interface{})
	account := strings.TrimSpace(this.GetString("account"))
	//获取周榜信息
	data["weekup"] = GetUpGradingWeeks(account)
	data["totalup"] = GetUpGrading(account)
	this.Ctx.Output.JSON(data, false, false)
}
