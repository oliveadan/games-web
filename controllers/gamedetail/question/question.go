package question

import (
	"html/template"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/question"
	"phage/controllers/sysmanage"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

func validate(model *Question) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(model.Content, "errmsg").Message("内容必填")
	valid.MaxSize(model.Content, 255, "errmsg").Message("内容最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type QuestionIndexController struct {
	sysmanage.BaseController
}

func (this *QuestionIndexController) Get() {
	gId, _ := this.GetInt64("gameId", 0)
	if gId == 0 {
		gId, _ = this.GetSession("currentGameId").(int64)
	}

	var list []Question
	o := orm.NewOrm()
	o.QueryTable(new(Question)).Filter("GameId", gId).OrderBy("Pid", "Seq", "Id").All(&list)

	// 返回值
	this.Data["gameList"] = GetGames("quest")
	this.Data["dataList"] = list
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/question/question/index.tpl"
}

func (this *QuestionIndexController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	model := Question{}
	if err := this.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&model); hasError {
		msg = errMsg
		return
	}
	if model.GameId == 0 {
		msg = "请先选择活动名称"
		return
	}
	if model.Pid != 0 {
		model.ContentType = 0
	}
	model.Content = strings.TrimSpace(model.Content)
	var err error
	if model.Id == 0 {
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		_, err = model.Create()
	} else {
		model.Modifior = this.LoginAdminId
		_, err = model.Update("Seq", "Content", "Required")
	}

	if err != nil {
		msg = "操作失败"
		beego.Error("Insert questionscore error", err)
	} else {
		code = 1
		msg = "操作成功"
		this.SetSession("currentGameId", model.GameId)
	}
}

func (this *QuestionIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	model := Question{}
	model.Id = id
	model.Pid = id
	o := orm.NewOrm()
	o.Begin()
	if _, err := o.Delete(&model, "Id"); err != nil {
		msg = "删除失败"
		o.Rollback()
		return
	}
	if _, err := o.Delete(&model, "Pid"); err != nil {
		msg = "删除失败"
		o.Rollback()
		return
	}
	o.Commit()
	code = 1
	msg = "删除成功"

}
