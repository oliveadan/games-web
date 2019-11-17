package upgrading

import (
	. "games-web/models/common"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"html/template"
	"phage/controllers/sysmanage"
	. "phage/models"

	. "games-web/models/gamedetail/upgrading"
)

type UpgradingAttribute struct {
	sysmanage.BaseController
}

func (this *UpgradingAttribute) Get() {
	beego.Informational("query UpgradingAttribute")
	gId, _ := this.GetInt64("gameId", 0)
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(UpgradingConfig).Paginate(page, limit, gId)
	pagination.SetPaginator(this.Ctx, limit, total)
	this.Data["gameList"] = GetGames("upgrading")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/upgrading/upgradingconfig/index.tpl"
}

func (this *UpgradingAttribute) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	upgrading := UpgradingConfig{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	_, err := o.Delete(&upgrading, "Id")
	if err != nil {
		beego.Error("Delete upgradingconfig error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type AddUpgradingAttribute struct {
	sysmanage.BaseController
}

func (this *AddUpgradingAttribute) Get() {
	beego.Informational("add upgradingconfig")
	this.Data["gameList"] = GetGames("upgrading")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/upgrading/upgradingconfig/add.tpl"
}

func (this *AddUpgradingAttribute) Post() {
	var code int
	var msg string
	url := beego.URLFor("UpgradingAttribute.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	upgrading := UpgradingConfig{}
	if err := this.ParseForm(&upgrading); err != nil {
		msg = "参数异常"
		return
	}
	upgrading.Creator = this.LoginAdminId
	upgrading.Modifior = this.LoginAdminId
	_, err1 := upgrading.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert upgradingconfig error", err1)
	} else {
		code = 1
		msg = "添加成功"
		return
	}
}

type EditUpgradingAttribute struct {
	sysmanage.BaseController
}

func (this *EditUpgradingAttribute) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	upgrading := UpgradingConfig{BaseModel: BaseModel{Id: id}}
	err := o.Read(&upgrading)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("UpgradingAttribute.get"), 302)
	} else {
		this.Data["data"] = upgrading
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/upgrading/upgradingconfig/edit.tpl"
	}
}

func (this *EditUpgradingAttribute) Post() {
	var code int
	var msg string
	url := beego.URLFor("UpgradingAttribute.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	upgrading := UpgradingConfig{}
	if err := this.ParseForm(&upgrading); err != nil {
		msg = "参数异常"
		return
	}
	cols := []string{"Level", "TotalAmount", "LevelGift", "WeekAmount", "MonthAmount"}
	upgrading.Modifior = this.LoginAdminId
	_, err := upgrading.Update(cols...)
	if err != nil {
		msg = "更新失败"
		beego.Error("Update upgradingconfig error", err)
	} else {
		code = 1
		msg = "更新成功"
	}
}
