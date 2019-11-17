package questionscore

import (
	"fmt"
	"github.com/360EntSecGroup-Skylar/excelize"
	"html/template"
	"net/url"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/questionscore"
	"phage/controllers/sysmanage"
	"phage/utils"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
)

func validate(model *Questionscore) (hasError bool, errMsg string) {
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

type QuestionscoreIndexController struct {
	sysmanage.BaseController
}

func (this *QuestionscoreIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *QuestionscoreIndexController) Get() {
	gId, _ := this.GetInt64("gameId", 0)
	category := this.GetString("category")
	o := orm.NewOrm()
	var list []Questionscore
	if gId == 0 {
		gId, _ = this.GetSession("currentGameId").(int64)
	}
	if category == "" {
		o.QueryTable(new(Questionscore)).Filter("GameId", gId).OrderBy("Pid", "Seq", "Id").All(&list)

	} else {
		o.QueryTable(new(Questionscore)).Filter("GameId", gId).Filter("Category", category).OrderBy("Pid", "Seq", "Id").All(&list)
	}
	//题目数量
	var gameattributes GameAttribute
	o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code", "questionquantity").One(&gameattributes)
	// 返回值
	this.Data["quantity"] = gameattributes.Value
	this.Data["category"] = category
	this.Data["gameList"] = GetGames("questscore")
	this.Data["dataList"] = list
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/questionscore/questionscore/index.tpl"
}

func (this *QuestionscoreIndexController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	model := Questionscore{}
	o := orm.NewOrm()
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
		var qs Questionscore
		err := o.QueryTable(new(Questionscore)).Filter("Id", model.Pid).One(&qs, "Category")
		if err != nil {
			beego.Error("get Questionscore error", err)
		}
		model.Category = qs.Category
	}
	model.Content = strings.TrimSpace(model.Content)
	var err error
	if model.Id == 0 {
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		_, err = model.Create()
	} else {
		model.Modifior = this.LoginAdminId
		_, err = model.Update("Seq", "ContentType", "Content", "Required", "Score", "Category")
		if model.Pid == 0 {
			o.Begin()
			_, err := o.QueryTable(new(Questionscore)).Filter("GameId", model.GameId).Filter("Pid", model.Id).Update(orm.Params{
				"Category": model.Category})
			if err != nil {
				o.Rollback()
				beego.Error("update Questionscore category error", err)
			}
			o.Commit()
		}
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

func (this *QuestionscoreIndexController) Batchdel() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	name := this.GetString("name")
	category := this.GetString("category")
	if name == "" {
		msg = "请选择活动名称"
		return
	}
	if category == "" {
		msg = "请选择活动类型"
		return
	}
	o := orm.NewOrm()
	titlecount, _ := o.QueryTable(new(Questionscore)).Filter("GameId", name).Filter("Category", category).Filter("Pid", 0).Count()
	optioncount, _ := o.QueryTable(new(Questionscore)).Filter("GameId", name).Filter("Category", category).Filter("Pid__gt", 0).Count()
	o.Begin()
	_, e := o.QueryTable(new(Questionscore)).Filter("GameId", name).Filter("Category", category).Delete()
	if e != nil {
		beego.Error("QuestionscoreIndexController batchdel error", e)
		o.Rollback()
		msg = "删除失败"
		return
	}
	o.Commit()
	code = 1
	msg = fmt.Sprintf("成功删除%d个题目和%d个选项", titlecount, optioncount)
}

func (this *QuestionscoreIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	model := Questionscore{}
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

func (this *QuestionscoreIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	if err != nil {
		beego.Error("questionscore import file get file error", err)
		msg = "上传失败,请重试(1)"
		return
	}
	fname := url.QueryEscape(h.Filename)
	suffix := utils.SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".xlsx" {
		msg = "文件后缀必须为xlsx"
		return
	}
	o := orm.NewOrm()
	models := make([]Questionscore, 0)

	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("questionscore import, open excel error", err)
		msg = "读取excel失败,请重试"
		return
	}
	if xlsx.GetSheetIndex("答题活动") == 0 {
		msg = "不存在<<答题活动>>"
	}
	rows := xlsx.GetRows("答题活动")
	for i, row := range rows {
		if i == 0 {
			continue
		}
		if len(row) < 4 {
			msg = fmt.Sprintf("%s第%d行账号为空<br>", msg, i+1)
		}
		gid := strings.TrimSpace(row[0])
		if gid == "" {
			msg = fmt.Sprintf("%s第%d行活动Id不能为空<br>", msg, i+1)
		}
		content := strings.TrimSpace(row[1])
		if content == "" {
			msg = fmt.Sprintf("%s第%d行内容不能为空<br>", msg, i+1)
		}
		timu := strings.TrimSpace(row[2])
		if timu == "" {
			msg = fmt.Sprintf("%s第%d行内容不能为空<br>", msg, i+1)
		}
		category := strings.TrimSpace(row[3])
		if category == "" {
			msg = fmt.Sprintf("%s第%d行类别不能为空<br>", msg, i+1)
		}
		seq := strings.TrimSpace(row[4])
		if seq == "" {
			msg = fmt.Sprintf("%s第%d排序字段不能为空<br>", msg, i+1)
		}
		rand := strings.TrimSpace(row[5])
		if rand == "" {
			msg = fmt.Sprintf("%s第%d行随机出现/必出不能为空<br>", msg, i+1)
		}
		score := strings.TrimSpace(row[6])
		if score == "" {
			msg = fmt.Sprintf("%s第%d行活动Id不能为空<br>", msg, i+1)
		}
		pid := strings.TrimSpace(row[7])
		if pid == "" {
			msg = fmt.Sprintf("%s第%d行pid不能为空<br>", msg, i+1)
		}
		model := Questionscore{}
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		model.CreateDate = time.Now()
		model.ModifyDate = time.Now()
		model.Version = 0
		gameid, _ := strconv.ParseInt(gid, 10, 64)
		model.GameId = gameid
		tm, _ := strconv.Atoi(timu)
		model.ContentType = tm
		model.Content = content
		cg, _ := strconv.Atoi(category)
		model.Category = cg
		seqq, _ := strconv.Atoi(seq)
		model.Seq = seqq
		r, _ := strconv.ParseInt(rand, 10, 64)
		model.Required = int8(r)
		s, _ := strconv.ParseInt(score, 10, 64)
		model.Score = s
		p, _ := strconv.ParseInt(pid, 10, 64)
		model.Pid = p
		if p != 0 {
			model.ContentType = 0
			model.Required = 0
			var qs Questionscore
			err := o.QueryTable(new(Questionscore)).Filter("Id", p).One(&qs)
			if err != nil {
				beego.Error("get Questionscore error", err)
			}
			model.Category = qs.Category
		}
		models = append(models, model)
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
		return
	}
	if len(models) == 0 {
		msg = "导入表格为空,请确认"
		return
	}
	o.Begin()
	var susNums int64
	//将数组拆分导入，一次1000条
	mlen := len(models)
	for i := 0; i <= mlen/1000; i++ {
		end := 0
		if (i+1)*1000 >= mlen {
			end = mlen
		} else {
			end = (i + 1) * 1000
		}
		if i*1000 == end {
			continue
		}
		tmpArr := models[i*1000 : end]
		if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
			o.Rollback()
			beego.Error("questionscore import, insert error", err)
			msg = "上传失败，请重试(2)"
			return
		} else {
			susNums += nums
		}
	}
	o.Commit()
	code = 1
	msg = fmt.Sprintf("成功导入%d条记录", susNums)
	return
}

func (this *QuestionscoreIndexController) ModifyAttr() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, err := this.GetInt64("gid", 0)
	if err != nil || gId == 0 {
		msg = "活动获取失败，请重新查询"
		return
	}
	quantity := strings.TrimSpace(this.GetString("quantity"))
	sper, err := this.GetInt64("quantity", 0)
	if err != nil || sper == 0 {
		msg = "数量必须为大于0的数字"
		return
	}

	o := orm.NewOrm()
	o.Begin()
	if _, err := o.Delete(&GameAttribute{GameId: gId}, "GameId"); err != nil {
		o.Rollback()
		msg = "修改失败，请刷新后重试"
		return
	}
	model := new(GameAttribute)
	model.GameId = gId
	model.Code = "questionquantity"
	model.Value = quantity
	model.CreateDate = time.Now()
	model.Creator = this.LoginAdminId
	model.ModifyDate = time.Now()
	model.Modifior = this.LoginAdminId
	model.Version = 0
	if _, err := o.Insert(model); err != nil {
		o.Rollback()
		msg = "修改失败，请刷新后重试"
		return
	}
	o.Commit()
	code = 1
	msg = "修改成功"
	return
}
