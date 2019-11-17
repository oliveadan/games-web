package rankingconfig

import (
	. "games-web/models/common"
	. "games-web/models/gamedetail/ranking"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"html/template"
	"phage/controllers/sysmanage"
	. "phage/models"
)

type RankingConfigIndexController struct {
	sysmanage.BaseController
}

func (this *RankingConfigIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *RankingConfigIndexController) Get() {
	beego.Informational("query rankingconfig")
	rankingtype, _ := this.GetInt64("RankingType", 5)
	gId, _ := this.GetInt64("gameId", 0)
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(RankingConfig).Paginate(page, limit, gId, rankingtype)
	pagination.SetPaginator(this.Ctx, limit, total)
	this.Data["condArr"] = map[string]interface{}{"rankingType": rankingtype}
	this.Data["gameList"] = GetGames("ranking")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/ranking/rankingconfig/index.tpl"
}

func (this *RankingConfigIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	rankingconfig := RankingConfig{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	_, err := o.Delete(&rankingconfig, "Id")
	if err != nil {
		beego.Error("Delete rankingconfig error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type AddRankingConfigController struct {
	sysmanage.BaseController
}

func (this *AddRankingConfigController) Get() {
	beego.Informational("add rankingconfig")
	gId, _ := this.GetInt64("gameId", 0)
	if gId == 0 {
		gId, _ = this.GetSession("currentGameId").(int64)
	}
	this.Data["gameList"] = GetGames("ranking")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/ranking/rankingconfig/add.tpl"
}

func (this *AddRankingConfigController) Post() {
	var code int
	var msg string
	url := beego.URLFor("RankingConfigIndexController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	rankingconfig := RankingConfig{}
	if err := this.ParseForm(&rankingconfig); err != nil {
		msg = "参数异常"
		return
	}
	rankingconfig.Creator = this.LoginAdminId
	rankingconfig.Modifior = this.LoginAdminId
	_, err1 := rankingconfig.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert ranking error", err1)
	} else {
		code = 1
		msg = "添加成功"
		return
	}
}

type EditRankingConfigController struct {
	sysmanage.BaseController
}

func (this *EditRankingConfigController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	rankingconfig := RankingConfig{BaseModel: BaseModel{Id: id}}
	err := o.Read(&rankingconfig)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("RankingConfigIndexController.get"), 302)
	} else {
		this.Data["data"] = rankingconfig
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/ranking/rankingconfig/edit.tpl"
	}
}

func (this *EditRankingConfigController) Post() {
	var code int
	var msg string
	url := beego.URLFor("RankingConfigIndexController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	rankingconfig := RankingConfig{}
	if err := this.ParseForm(&rankingconfig); err != nil {
		msg = "参数异常"
		return
	}
	cols := []string{"MinRank", "MaxRank", "EffectiveBetting", "Prize"}
	rankingconfig.Modifior = this.LoginAdminId
	_, err := rankingconfig.Update(cols...)
	if err != nil {
		msg = "更新失败"
		beego.Error("Update rankingconfig", err)
	} else {
		code = 1
		msg = "更新成功"
	}
}
