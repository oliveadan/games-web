package gameperiod

import (
	. "games-web/models/common"
	"phage/controllers/sysmanage"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	"html/template"
	. "phage/models"
)

type GamePeriodIndexController struct {
	sysmanage.BaseController
}

func validate(gameperiod *GamePeriod) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(gameperiod.StartTime, "errmsg").Message("开始时间必填")
	valid.Required(gameperiod.EndTime, "errmsg").Message("结束时间必填")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

func (this *GamePeriodIndexController) Get() {
	id, _ := this.GetInt64("GameId") //获取要编辑活动的ID
	list := GetGamePeriod(id)
	this.Data["GameId"] = id
	this.Data["dataList"] = list
	this.TplName = "common/gameperiod/index.tpl"
}

func (this *GamePeriodIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	member := GamePeriod{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&member)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&GamePeriod{BaseModel: BaseModel{Id: id}})
	if err1 != nil {
		beego.Error("Delete member error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type GamePeriodAddController struct {
	sysmanage.BaseController
}

func (this *GamePeriodAddController) Get() {
	id, _ := this.GetInt64("GameId") //获取要编辑活动的ID
	this.Data["GameId"] = id
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "common/gameperiod/addtime.tpl"
}

func (this *GamePeriodAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	game := GamePeriod{}
	if err := this.ParseForm(&game); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&game); hasError {
		msg = errMsg
		return
	}
	game.Creator = this.LoginAdminId
	game.Modifior = this.LoginAdminId
	_, err1 := game.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert game error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}

}
