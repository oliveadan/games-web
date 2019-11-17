package box

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"html/template"
	"phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/box"
	"phage/controllers/sysmanage"
)

type BoxIndexController struct {
	sysmanage.BaseController
}

func (this *BoxIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *BoxIndexController) Get() {
	beego.Informational("query boxapi")
	this.Data["boxList"] = GetBoxs()
	this.TplName = "gamedetail/box/index.tpl"
}

func (this *BoxIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	box := Box{Id: id}
	o := orm.NewOrm()
	err := o.Read(&box)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}

	_, err1 := o.Delete(&box, "Id")
	if err1 != nil {
		beego.Error("Delete boxapi error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type BoxAddController struct {
	sysmanage.BaseController
}

func (this *BoxAddController) Get() {
	var list []common.Game
	o := orm.NewOrm()
	o.QueryTable(new(common.Game)).Filter("Deleted", 0).Filter("GameType", "box").All(&list)
	this.Data["gameList"] = list
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/box/add.tpl"
}

func (this *BoxAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	GameId, _ := this.GetInt64("GameId")
	BronzeboxId, _ := this.GetInt64("BronzeboxId")
	SilverboxId, _ := this.GetInt64("SilverboxId")
	GoldboxId, _ := this.GetInt64("GoldboxId")
	ExtremeboxId, _ := this.GetInt64("ExtremeboxId")
	box := Box{}
	box.GameId = GameId
	box.SilverboxId = SilverboxId
	box.GoldboxId = GoldboxId
	box.ExtremeboxId = ExtremeboxId
	box.BronzeboxId = BronzeboxId
	_, err1 := box.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert boxapi error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}
