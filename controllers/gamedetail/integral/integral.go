package integral

import (
	"fmt"
	. "games-web/models/common"
	"html/template"
	"net/url"
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
	"math"
	"os"
)

func validate(memberLottery *MemberLottery) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(memberLottery.Account, "errmsg").Message("会员账号必填")
	valid.MaxSize(memberLottery.Account, 255, "errmsg").Message("会员账号最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type IntegralIndexController struct {
	sysmanage.BaseController
}

func (this *IntegralIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *IntegralIndexController) Get() {
	beego.Informational("query memberLottery ")
	//导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	// 条件 要和Delbatch函数保持一致
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(MemberLottery).Paginate(page, limit, gId, account)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["account"] = account
	this.Data["gameList"] = GetGames("integral")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/integral/integral/index.tpl"
}

func (this *IntegralIndexController) Delbatch() {
	beego.Informational(this.LoginAdminId, "删除所有会员积分")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	// 条件 要和Get函数保持一致
	o := orm.NewOrm()
	model := MemberLottery{GameId: gId}

	if num, err := o.Delete(&model, "GameId"); err != nil {
		beego.Error("Delete batch memberLottery error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功删除%d条记录", num)
	}
}

func (this *IntegralIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	memberLottery := MemberLottery{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&memberLottery)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&memberLottery, "Id")
	if err1 != nil {
		beego.Error("Delete memberLottery error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

func (this *IntegralIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("Integral upload file get file error", err)
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
	models := make([]MemberLottery, 0)
	upmodes := make([]MemberLottery, 0)

	// xlsx
	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("Integral import, open excel error", err)
		msg = "读取excel失败，请重试"
		return
	}
	if xlsx.GetSheetIndex("会员积分导入") == 0 {
		msg = "不存在《会员积分导入》sheet页"
		return
	}
	// Get all the rows in the Sheet1.
	rows := xlsx.GetRows("会员积分导入")
	// 金额与积分比例
	pecent, err := strconv.ParseFloat(strings.TrimSpace(rows[0][5]), 10)
	if err != nil {
		msg = "充值金额与积分的比例必须为数字"
		return
	}
	if pecent == float64(0.0) {
		msg = "充值金额与积分的比例不能为 0"
		return
	}
	for i, row := range rows {
		if i == 0 {
			continue
		}
		if len(row) < 3 {
			msg = fmt.Sprintf("%s第%d行活动ID、账号、抽奖次数不能为空<br>", msg, i+1)
			continue
		}
		gid, err := strconv.ParseInt(strings.TrimSpace(row[0]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行活动ID必须为数字<br>", msg, i+1)
			continue
		}
		// 验证gid是否为积分商城的活动ID
		if isExist := o.QueryTable(new(Game)).Filter("Id", gid).Filter("GameType", "integral").Exist(); !isExist {
			msg = fmt.Sprintf("%s第%d行活动ID必须为积分商城的活动ID<br>", msg, i+1)
			continue
		}

		account := strings.TrimSpace(row[1])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
			continue
		}
		amount, err := strconv.ParseFloat(strings.TrimSpace(row[2]), 10)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行金额必须为数字<br>", msg, i+1)
			continue
		}
		// 会员不存在则提示
		if isExist := o.QueryTable(new(Member)).Filter("Account", account).Exist(); !isExist {
			msg = fmt.Sprintf("%s第%d行会员账号不存在<br>", msg, i+1)
			continue
		}
		// 计算积分
		integral := int(amount / pecent)
		// 判断会员次数是否已存在，再根据导入模式进行处理
		isExist := o.QueryTable(new(MemberLottery)).Filter("GameId", gid).Filter("Account", account).Exist()
		if isExist {
			upmodes = append(upmodes, MemberLottery{Account: account, GameId: gid, LotteryNums: integral})
		} else {
			model := MemberLottery{}
			model.Account = account
			model.GameId = gid
			model.Creator = this.LoginAdminId
			model.Modifior = this.LoginAdminId
			model.CreateDate = time.Now()
			model.ModifyDate = time.Now()
			model.Version = 0
			model.LotteryNums = integral
			models = append(models, model)
		}
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
		return
	}

	if len(models) == 0 && len(upmodes) == 0 {
		msg = "导入表格为空，请确认"
		return
	}
	o.Begin()
	if len(upmodes) > 0 {
		for _, v := range upmodes {
			_, err = o.QueryTable(new(MemberLottery)).Filter("GameId", v.GameId).Filter("Account", v.Account).Update(orm.Params{
				"LotteryNums": orm.ColValue(orm.ColAdd, v.LotteryNums),
				"Modifior":    this.LoginAdminId,
				"ModifyDate":  time.Now(),
			})
			if err != nil {
				o.Rollback()
				beego.Error("memberlottery import, update error", err)
				msg = "导入失败，请重试"
				return
			}
		}
		msg = fmt.Sprintf("成功更新%d条记录<br>", len(upmodes))
	}
	if len(models) > 0 {
		if nums, err := o.InsertMulti(len(models), models); err != nil {
			o.Rollback()
			beego.Error("memberlottery import, insert error", err)
			msg = "导入失败，请重试(2)"
			return
		} else {
			msg = fmt.Sprintf("%s成功新增%d条记录", msg, nums)
		}
	}
	o.Commit()
	code = 1
	return
}

type IntegralAddController struct {
	sysmanage.BaseController
}

func (this *IntegralAddController) Get() {
	this.Data["gameList"] = GetGames("integral")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/integral/integral/add.tpl"
}

func (this *IntegralAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	model := MemberLottery{}
	if err := this.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&model); hasError {
		msg = errMsg
		return
	}
	o := orm.NewOrm()
	// 判断会员是否存在
	if isExist := o.QueryTable(new(Member)).Filter("Account", model.Account).Exist(); !isExist {
		msg = "会员账号不存在，请到会员管理添加"
		return
	}

	// 判断是否已存在
	if isExist := o.QueryTable(new(MemberLottery)).Filter("GameId", model.GameId).Filter("Account", model.Account).Exist(); isExist {
		msg = "会员数据已存在，请查询后编辑"
		return
	}
	model.Creator = this.LoginAdminId
	model.Modifior = this.LoginAdminId
	_, err1 := model.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert memberLottery error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type IntegralEditController struct {
	sysmanage.BaseController
}

func (this *IntegralEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	memberLottery := MemberLottery{BaseModel: BaseModel{Id: id}}

	err := o.Read(&memberLottery)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("IntegralIndexController.get"), 302)
	} else {
		this.Data["gameList"] = GetGames("integral")
		this.Data["data"] = memberLottery
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/integral/integral/edit.tpl"
	}
}

func (this *IntegralEditController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	memberLottery := MemberLottery{}
	if err := this.ParseForm(&memberLottery); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&memberLottery); hasError {
		msg = errMsg
		return
	}
	o := orm.NewOrm()
	// 判断会员是否存在
	if isExist := o.QueryTable(new(Member)).Filter("Account", memberLottery.Account).Exist(); !isExist {
		msg = "会员账号不存在，请到会员管理添加"
		return
	}
	qs := o.QueryTable(new(MemberLottery)).Filter("GameId", memberLottery.GameId).Filter("Account", memberLottery.Account)
	num, err := qs.Update(orm.Params{
		"LotteryNums": orm.ColValue(orm.ColAdd, memberLottery.LotteryNums),
		"Modifior":    this.LoginAdminId,
		"ModifyDate":  time.Now(),
	})
	if err != nil || num != 1 {
		msg = "更新失败"
		beego.Error("Update memberLottery error", err)
	} else {
		code = 1
		msg = "更新成功"
	}
}

func (this *IntegralIndexController) Export() {
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))

	page := 1
	limit := 1000
	list, total := new(MemberLottery).Paginate(page, limit, gId, account)
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(MemberLottery).Paginate(page, limit, gId, account)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}

	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "会员账号")
	xlsx.SetCellValue("Sheet1", "B1", "会员积分")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), value.LotteryNums)
	}
	// Save xlsx file by the given path.
	fileName := fmt.Sprintf("./tmp/excel/integral_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export integral error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}
