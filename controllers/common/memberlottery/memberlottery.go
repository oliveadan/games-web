package memberlottery

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

	utils2 "games-web/utils"
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

type MemberLotteryIndexController struct {
	sysmanage.BaseController
}

func (this *MemberLotteryIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *MemberLotteryIndexController) Get() {
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
	this.Data["gameList"] = GetGames()
	this.Data["dataList"] = list
	this.TplName = "common/memberlottery/index.tpl"
}

func (this *MemberLotteryIndexController) Delbatch() {
	beego.Warning(this.LoginAdminId, "删除所有会员抽奖次数")
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

func (this *MemberLotteryIndexController) Delone() {
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

func (this *MemberLotteryIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("MemberLottery upload file get file error", err)
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
	idsDel := make([]int64, 0)

	// xlsx
	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("MemberLottery import, open excel error", err)
		msg = "读取excel失败，请重试"
		return
	}

	if xlsx.GetSheetIndex("会员抽奖次数导入") == 0 {
		msg = "不存在《会员抽奖次数导入》sheet页"
		return
	}
	rows := xlsx.GetRows("会员抽奖次数导入")
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
		account := strings.TrimSpace(row[1])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
			continue
		}
		lottoryNums, err := strconv.ParseInt(strings.TrimSpace(row[2]), 10, 0)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行抽奖次数必须为数字<br>", msg, i+1)
			continue
		}
		// 会员不存在则提示
		if isExist := o.QueryTable(new(Member)).Filter("Account", account).Exist(); !isExist {
			msg = fmt.Sprintf("%s第%d行会员账号不存在<br>", msg, i+1)
			continue
		}
		var tmpModel MemberLottery
		// 判断会员次数是否已存在，再根据导入模式进行处理
		err1 := o.QueryTable(new(MemberLottery)).Filter("GameId", gid).Filter("Account", account).One(&tmpModel)
		if err1 != nil && err1 != orm.ErrNoRows {
			msg = fmt.Sprintf("%s第%d行数据错误，请重试<br>", msg, i+1)
			continue
		}
		if err1 == nil { // 有记录则删除
			idsDel = append(idsDel, tmpModel.Id)
		}
		model := MemberLottery{}
		model.Account = account
		model.GameId = gid
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		model.CreateDate = time.Now()
		model.ModifyDate = time.Now()
		model.Version = 0
		if len(row) > 3 && strings.TrimSpace(row[3]) == "2" { // 累加模式
			model.LotteryNums = tmpModel.LotteryNums + int(lottoryNums)
		} else { // 其他为覆盖模式
			model.LotteryNums = int(lottoryNums)
		}
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
	o.Begin()
	if len(idsDel) > 0 {
		idslen := len(idsDel)
		for i := 0; i <= idslen/1000; i++ {
			end := 0
			if (i+1)*1000 >= idslen {
				end = idslen
			} else {
				end = (i + 1) * 1000
			}
			tmpArr := idsDel[i*1000 : end]

			if _, err = o.QueryTable(new(MemberLottery)).Filter("Id__in", tmpArr).Delete(); err != nil {
				o.Rollback()
				msg = "导入失败，请重试"
				return
			}
		}
	}

	var susNums int64
	// 将数组拆分导入，一次1000条
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
			beego.Error("memberlottery import, insert error", err)
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

func (this *MemberLotteryIndexController) Export() {
	gId, _ := this.GetInt64("gameId", 0)
	page := 1
	limit := 1000
	list, total := new(MemberLottery).Paginate(page, limit, gId, "")
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(MemberLottery).Paginate(page, limit, gId, "")
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}

	gameName := utils2.GetGameName(gId)
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "ID")
	xlsx.SetCellValue("Sheet1", "B1", "活动名称")
	xlsx.SetCellValue("Sheet1", "C1", "会员账号")
	xlsx.SetCellValue("Sheet1", "D1", "抽奖次数")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), value.Id)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), gameName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.LotteryNums)
	}
	// Save xlsx file by the given path.
	fileName := fmt.Sprintf("./tmp/excel/rewardlist_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export memberlotterys error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

type MemberLotteryAddController struct {
	sysmanage.BaseController
}

func (this *MemberLotteryAddController) Get() {
	this.Data["gameList"] = GetGames()
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "common/memberlottery/add.tpl"
}

func (this *MemberLotteryAddController) Post() {
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
		msg = "会员数据已存在"
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

type MemberLotteryEditController struct {
	sysmanage.BaseController
}

func (this *MemberLotteryEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	memberLottery := MemberLottery{BaseModel: BaseModel{Id: id}}

	err := o.Read(&memberLottery)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("MemberLotteryIndexController.get"), 302)
	} else {
		this.Data["gameList"] = GetGames()
		this.Data["data"] = memberLottery
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "common/memberlottery/edit.tpl"
	}
}

func (this *MemberLotteryEditController) Post() {
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
	cols := []string{"GameId", "Account", "LotteryNums"}
	memberLottery.Modifior = this.LoginAdminId
	_, err1 := memberLottery.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("Update memberLottery error", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}
