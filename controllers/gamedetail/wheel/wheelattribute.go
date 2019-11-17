package wheel

import (
	"html/template"
	. "phage-games-web/models/common"
	"phage-games-web/utils"
	"phage/controllers/sysmanage"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type WheelAttributeIndexController struct {
	sysmanage.BaseController
}

func (this *WheelAttributeIndexController) Get() {
	beego.Informational("query rich attribute ")
	gId, _ := this.GetInt64("gameId", 0)
	if gId == 0 {
		gId, _ = this.GetSession("currentGameId").(int64)
	}
	var ga GameAttribute
	o := orm.NewOrm()
	o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code", utils.Wheelphoto).One(&ga, "Value")

	// 返回值
	this.Data["attr"] = ga
	this.Data["gameList"] = GetGames("wheel")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/wheel/wheelattribute/index.tpl"
}

func (this *WheelAttributeIndexController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	ga := GameAttribute{}
	if err := this.ParseForm(&ga); err != nil {
		msg = "参数异常"
		return
	}
	var photo = ga.Value
	if photo == "" {
		msg = "图片为空，请刷新后重新上传"
		return
	}
	ga.Code = utils.Wheelphoto
	ga.Creator = this.LoginAdminId
	ga.Modifior = this.LoginAdminId
	created, _, err := ga.ReadOrCreate("GameId", "Code")
	if err != nil {
		msg = "添加失败"
		beego.Error("Insert gift error", err)
		return
	}
	if !created {
		ga.Value = photo
		_, err = ga.Update("Value")
	}
	if err != nil {
		msg = "添加失败"
		beego.Error("Insert gift error", err)
		return
	} else {
		code = 1
		msg = "添加成功"
		this.SetSession("currentGameId", ga.GameId)
	}
}
