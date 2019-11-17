package vipvalue

import (
	"fmt"
	. "games-web/models/gamedetail/vipvalue"
	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"html/template"
	"net/url"
	"phage/controllers/sysmanage"
	. "phage/models"
	"phage/utils"
	"strconv"
	"strings"
	"time"
)

type VipValueIndexController struct {
	sysmanage.BaseController
}

func (this *VipValueIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *VipValueIndexController) Get() {
	//gId, _ := this.GetInt64("gameId", 0)
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(VipValue).Paginate(page, limit, 0)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["dataList"] = list
	this.TplName = "gamedetail/vipvalue/index.tpl"
}

func (this *VipValueIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	vipvalue := VipValue{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&vipvalue)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&vipvalue, "Id")
	if err1 != nil {
		beego.Error("Delete vipvalue error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

func (this *VipValueIndexController) BatchDel() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	o := orm.NewOrm()
	i, e := o.QueryTable(new(VipValue)).Filter("Id__gt", 0).Delete()
	if e != nil {
		beego.Error("batchdel vipvlaue error", e)
		msg = "删除失败"
		return
	}
	code = 1
	msg = fmt.Sprintf("成功删除%d条数据", i)
}

func (this *VipValueIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("VipValue upload file get file error", err)
		msg = "上传失败，请重试(1)"
		return
	}
	fname := url.QueryEscape(h.Filename)
	suffix := utils.SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".xlsx" {
		msg = "文件必须为 xlsx"
		return
	}

	o := orm.NewOrm()
	models := make([]VipValue, 0)

	// xlsx
	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("VipValue import, open excel error", err)
		msg = "读取excel失败，请重试"
		return
	}
	if xlsx.GetSheetIndex("VIP账号价值") == 0 {
		msg = "不存在《VIP账号价值》sheet页"
		return
	}
	// Get all the rows in the Sheet1.
	rows := xlsx.GetRows("VIP账号价值")
	for i, row := range rows {
		if i == 0 {
			continue
		}
		if len(row) < 4 {
			msg = fmt.Sprintf("%s第%d行会员账号、注册日期、注册天数、账号价值不能为空<br>", msg, i+1)
			continue
		}
		account := strings.TrimSpace(row[0])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
			continue
		}
		registerdate := strings.TrimSpace(row[1])
		if registerdate == "" {
			msg = fmt.Sprintf("%s第%d行注册日期不能为空<br>", msg, i+1)
			continue
		}
		registerdays, err := strconv.ParseInt(strings.TrimSpace(row[2]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行注册天数必须为数字<br>", msg, i+1)
			continue
		}
		value := strings.TrimSpace(row[3])
		if value == "" {
			msg = fmt.Sprintf("%s第%d账号价值不能为空<br>", msg, i+1)
			continue
		}
		viplevel, err := strconv.ParseInt(strings.TrimSpace(row[4]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行注册天数必须为数字<br>", msg, i+1)
			continue
		}
		var vipvalue VipValue
		vipvalue.CreateDate = time.Now()
		vipvalue.ModifyDate = time.Now()
		vipvalue.Creator = this.LoginAdminId
		vipvalue.Modifior = this.LoginAdminId
		vipvalue.Account = account
		vipvalue.VipLevel = viplevel
		paretime, err := time.Parse("01-02-06", registerdate)
		if err != nil {
			beego.Error("change time error", err)
		}
		vipvalue.RegisterDate = paretime
		vipvalue.RegisterDays = registerdays
		vipvalue.Value = value
		models = append(models, vipvalue)
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
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
			beego.Error("vipvalue import, insert error", err)
			msg = fmt.Sprintf("%v %v", "上传失败", err)
			return
		} else {
			susNums += nums
		}
	}
	msg = fmt.Sprintf("%s成功新增%d条记录", msg, susNums)
	o.Commit()
	code = 1
	return
}

type VipValueAddController struct {
	sysmanage.BaseController
}

func (this *VipValueAddController) Get() {
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/vipvalue/add.tpl"
}

func (this *VipValueAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	model := VipValue{}
	if err := this.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	}
	model.Creator = this.LoginAdminId
	model.Modifior = this.LoginAdminId
	_, err1 := model.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert VipValue error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type VipValueEditController struct {
	sysmanage.BaseController
}

func (this *VipValueEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	vipvalue := VipValue{BaseModel: BaseModel{Id: id}}

	err := o.Read(&vipvalue)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("VipValueIndexController.get"), 302)
	} else {
		this.Data["data"] = vipvalue
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/vipvalue/edit.tpl"
	}
}

func (this *VipValueEditController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	vipvalue := VipValue{}
	if err := this.ParseForm(&vipvalue); err != nil {
		msg = "参数异常"
		return
	}

	cols := []string{"Account", "RegisterDate", "RegisterDays", "Value", "VipLevel"}
	vipvalue.Modifior = this.LoginAdminId
	_, err1 := vipvalue.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("Update member error", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}
