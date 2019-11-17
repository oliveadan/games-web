package KingRaceapi

import (
	. "games-web/controllers/front"
	. "phage/utils"

	"github.com/astaxie/beego"
)

type KingRaceApiController struct {
	beego.Controller
}

func (this *KingRaceApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *KingRaceApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	rlList := SetRewardList(&this.Controller, &gId)
	this.Data["rlList"] = rlList[:len(rlList)/2]
	this.Data["rlList1"] = rlList[len(rlList)/2:]

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.Data["phone"] = "phone"
		this.TplName = "front/kingrace/index-wap.tpl"
	} else {
		this.TplName = "front/kingrace/index-pc.tpl"
	}
}
