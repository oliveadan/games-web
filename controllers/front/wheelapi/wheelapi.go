package wheelapi

import (
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	"phage-games-web/utils"
	. "phage/utils"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type WheelApiController struct {
	beego.Controller
}

func (this *WheelApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *WheelApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)

	var ga GameAttribute
	o := orm.NewOrm()
	o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code", utils.Wheelphoto).One(&ga, "Value")

	this.Data["wheelphoto"] = ga.Value
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/wheel/index-wap.tpl"
	} else {
		this.TplName = "front/wheel/index-pc.tpl"
	}
}
