package assignmember

import (
	"fmt"
	"html/template"
	"net/url"
	"os"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gift"
	"phage/controllers/sysmanage"
	. "phage/models"
	"phage/utils"
	"strconv"
	"strings"
	"time"

	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
)

func validate(assignMember *AssignMember) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(assignMember.Account, "errmsg").Message("会员账号必填")
	valid.MaxSize(assignMember.Account, 255, "errmsg").Message("会员账号最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type AssignMemberIndexController struct {
	sysmanage.BaseController
}

func (this *AssignMemberIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *AssignMemberIndexController) Get() {

	gId, _ := this.GetInt64("gameId", 0)
	//导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export(gId)
		return
	}
	account := strings.TrimSpace(this.GetString("account"))
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(AssignMember).Paginate(page, limit, gId, account)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	gifts := GetGifts(gId)
	giftMap := make(map[int64]string)
	for _, v := range gifts {
		giftMap[v.Id] = fmt.Sprintf("%d-%s(%s)", v.Seq, v.Name, v.Content)
	}
	this.Data["account"] = account
	this.Data["giftMap"] = giftMap
	this.Data["gameList"] = GetGames()
	this.Data["dataList"] = list
	this.TplName = "gift/assignmember/index.tpl"
}

func (this *AssignMemberIndexController) Delbatch() {
	beego.Informational(this.LoginAdminId, "删除所有内定会员")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	// 条件 要和Get函数保持一致
	gId, _ := this.GetInt64("gameId", 0)
	// 条件 要和Get函数保持一致
	o := orm.NewOrm()
	model := AssignMember{GameId: gId}

	if num, err := o.Delete(&model, "GameId"); err != nil {
		beego.Error("Delete batch memberLottery error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功删除%d条记录", num)
	}
}
func (this *AssignMemberIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	assignMember := AssignMember{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&assignMember)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&assignMember, "Id")
	if err1 != nil {
		beego.Error("Delete assignMember error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

func (this *AssignMemberIndexController) Enabled() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	assignMember := AssignMember{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&assignMember)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		msg = "数据不存在，请确认"
		return
	}
	if assignMember.Enabled == 0 {
		assignMember.Enabled = 1
	} else {
		assignMember.Enabled = 0
	}
	assignMember.Modifior = this.LoginAdminId
	_, err1 := assignMember.Update("Enabled")
	if err1 != nil {
		beego.Error("Enabled assignMember error", err1)
		msg = "操作失败"
	} else {
		code = 1
		msg = "操作成功"
	}

}

func (this *AssignMemberIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("AssignMember upload file get file error", err)
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
	models := make([]AssignMember, 0)

	// xlsx
	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("AssignMember import, open excel error", err)
		msg = "读取excel失败，请重试"
		return
	}
	if xlsx.GetSheetIndex("内定会员导入") == 0 {
		msg = "不存在《内定会员导入》sheet页"
		return
	}
	rows := xlsx.GetRows("内定会员导入")
	for i, row := range rows {
		if i == 0 {
			continue
		}
		if len(row) < 3 {
			msg = fmt.Sprintf("%s第%d行活动ID、账号、奖品ID不能为空<br>", msg, i+1)
			continue
		}
		gid, err := strconv.ParseInt(strings.TrimSpace(row[0]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行活动ID必须为数字<br>", msg, i+1)
			continue
		}
		account := strings.TrimSpace(row[1])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
			continue
		}
		giftId, err := strconv.ParseInt(strings.TrimSpace(row[2]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行奖品ID必须为数字<br>", msg, i+1)
			continue
		}

		// 会员不存在则提示
		if isExist := o.QueryTable(new(Member)).Filter("Account", account).Exist(); !isExist {
			msg = fmt.Sprintf("%s第%d行会员账号不存在<br>", msg, i+1)
			continue
		}
		// 判断奖品是否存在
		if isExist := o.QueryTable(new(Gift)).Filter("GameId", gid).Filter("Id", giftId).Exist(); !isExist {
			msg = fmt.Sprintf("%s第%d行奖品ID不存在<br>", msg, i+1)
			continue
		}

		model := AssignMember{Account: account}
		model.GameId = gid
		model.GiftId = giftId
		model.Enabled = 0 // 未使用
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		model.CreateDate = time.Now()
		model.ModifyDate = time.Now()
		model.Version = 0
		models = append(models, model)
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
		return
	}

	if len(models) == 0 {
		msg = "导入表格为空，请确认"
		return
	}
	mlen := len(models)
	var susNums int64
	// 将数组拆分导入，一次1000条
	for i := 0; i <= mlen/1000; i++ {
		end := 0
		if (i+1)*1000 >= mlen {
			end = mlen
		} else {
			end = (i + 1) * 1000
		}
		tmpArr := models[i*1000 : end]

		if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
			beego.Error("member import, insert error", err)
		} else {
			susNums += nums
		}
	}

	code = 1
	msg = fmt.Sprintf("成功导入%d条记录", susNums)
	return
}

func (this *AssignMemberIndexController) Export(gid int64) {
	o := orm.NewOrm()
	var assignmembers []AssignMember
	_, err := o.QueryTable(new(AssignMember)).Filter("GameId", gid).Limit(-1).All(&assignmembers)
	if err != nil {
		beego.Error("导出失败", err)
		return
	}

	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "活动ID")
	xlsx.SetCellValue("Sheet1", "B1", "会员账号")
	xlsx.SetCellValue("Sheet1", "C1", "奖品ID")
	xlsx.SetCellValue("Sheet1", "D1", "是否使用")
	for i, value := range assignmembers {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), value.GameId)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.GiftId)
		if value.Enabled == 1 {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), "已使用")
		} else {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), "未使用")
		}

	}
	fileName := fmt.Sprintf("./tmp/excel/assignmemberlist_%s.xlsx", time.Now().Format("20060102150405"))
	err1 := xlsx.SaveAs(fileName)
	if err1 != nil {
		beego.Error("Export assignmembers error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

type AssignMemberAddController struct {
	sysmanage.BaseController
}

func (this *AssignMemberAddController) Get() {
	this.Data["gameList"] = GetGames()
	gid, ok := this.GetSession("currentGameId").(int64)
	if !ok {
		gid = 0
	}
	this.Data["giftList"] = GetGifts(gid)
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gift/assignmember/add.tpl"
}

func (this *AssignMemberAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	assignMember := AssignMember{}
	if err := this.ParseForm(&assignMember); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&assignMember); hasError {
		msg = errMsg
		return
	}
	o := orm.NewOrm()
	// 判断会员是否存在
	if isExist := o.QueryTable(new(Member)).Filter("Account", assignMember.Account).Exist(); !isExist {
		msg = "会员账号不存在，请到会员管理添加"
		return
	}
	assignMember.Creator = this.LoginAdminId
	assignMember.Modifior = this.LoginAdminId
	_, err1 := assignMember.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert assignMember error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type AssignMemberEditController struct {
	sysmanage.BaseController
}

func (this *AssignMemberEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	assignMember := AssignMember{BaseModel: BaseModel{Id: id}}

	err := o.Read(&assignMember)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("AssignMemberIndexController.get"), 302)
	} else {
		gid, ok := this.GetSession("currentGameId").(int64)
		if !ok {
			gid = 0
		}
		this.Data["giftList"] = GetGifts(gid)
		this.Data["gameList"] = GetGames()
		this.Data["data"] = assignMember
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gift/assignmember/edit.tpl"
	}
}

func (this *AssignMemberEditController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	assignMember := AssignMember{}
	if err := this.ParseForm(&assignMember); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&assignMember); hasError {
		msg = errMsg
		return
	}
	o := orm.NewOrm()
	// 判断会员是否存在
	if isExist := o.QueryTable(new(Member)).Filter("Account", assignMember.Account).Exist(); !isExist {
		msg = "会员账号不存在，请到会员管理添加"
		return
	}
	cols := []string{"GameId", "Account", "GiftId", "Enabled"}
	assignMember.Modifior = this.LoginAdminId
	_, err1 := assignMember.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("Update assignMember error", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}
