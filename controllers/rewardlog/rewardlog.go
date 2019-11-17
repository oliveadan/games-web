package rewardlog

import (
	"fmt"
	. "games-web/models/common"
	. "games-web/models/rewardlog"
	"games-web/utils"
	"html/template"
	"os"
	"phage/controllers/sysmanage"
	. "phage/models"
	"strings"
	"time"

	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
	"math"
	"net/url"
	utils2 "phage/utils"
	"strconv"
)

func validate(rewardLog *RewardLog) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(rewardLog.Account, "errmsg").Message("账号必填")
	valid.MaxSize(rewardLog.Account, 255, "errmsg").Message("账号最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type RewardLogIndexController struct {
	sysmanage.BaseController
}

func (this *RewardLogIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *RewardLogIndexController) Get() {
	// 导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}
	// 条件 要和export、Deliveredbatch 函数保持一致
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	timeStart := strings.TrimSpace(this.GetString("timeStart"))
	timeEnd := strings.TrimSpace(this.GetString("timeEnd"))
	delivered, _ := this.GetInt8("delivered", 0)
	deleted, _ := this.GetInt("Deleted", 0)

	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(RewardLog).Paginate(page, limit, gId, account, timeStart, timeEnd, delivered, deleted)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["condArr"] = map[string]interface{}{"account": account,
		"timeStart": timeStart,
		"timeEnd":   timeEnd,
		"delivered": delivered,
		"deleted":   deleted}
	this.Data["gameList"] = GetGames()
	this.Data["dataList"] = list
	this.TplName = "rewardlog/index.tpl"
}

func (this *RewardLogIndexController) Delbatch() {
	beego.Informational(this.LoginAdminId, "删除所有中奖记录")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	// 条件 要和Get函数保持一致
	gId, _ := this.GetInt64("gameId", 0)
	// 条件 要和Get函数保持一致
	o := orm.NewOrm()
	if num, err := o.QueryTable(new(RewardLog)).Filter("GameId", gId).Update(orm.Params{"Deleted": 1}); err != nil {
		beego.Error("Delete batch memberLottery error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功删除%d条记录", num)
	}
}

func (this *RewardLogIndexController) Export() {
	beego.Informational("export wish ")
	// 条件 要和get、Deliveredbatch函数保持一致
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	timeStart := strings.TrimSpace(this.GetString("timeStart"))
	timeEnd := strings.TrimSpace(this.GetString("timeEnd"))
	delivered, _ := this.GetInt8("delivered", 2)
	deleted, _ := this.GetInt("Deleted", 0)

	page := 1
	limit := 1000
	list, total := new(RewardLog).Paginate(page, limit, gId, account, timeStart, timeEnd, delivered, deleted)
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(RewardLog).Paginate(page, limit, gId, account, timeStart, timeEnd, delivered, deleted)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}

	gameName := utils.GetGameName(gId)
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "ID")
	xlsx.SetCellValue("Sheet1", "B1", "活动名称")
	xlsx.SetCellValue("Sheet1", "C1", "会员账号")
	xlsx.SetCellValue("Sheet1", "D1", "奖品名称")
	xlsx.SetCellValue("Sheet1", "E1", "奖品内容")
	xlsx.SetCellValue("Sheet1", "F1", "中奖时间")
	xlsx.SetCellValue("Sheet1", "G1", "是否派送")
	xlsx.SetCellValue("Sheet1", "H1", "派送时间")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), value.Id)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), gameName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.GiftName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("E%d", i+2), value.GiftContent)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("F%d", i+2), value.CreateDate.Format("2006-01-02 15:04:05"))
		if value.Delivered == 1 {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("G%d", i+2), "已派送")
		} else {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("G%d", i+2), "未派送")
		}
		if !value.DeliveredTime.IsZero() {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("H%d", i+2), value.DeliveredTime.Format("2006-01-02 15:04:05"))
		}
	}
	// Save xlsx file by the given path.
	fileName := fmt.Sprintf("./tmp/excel/rewardlist_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export reward error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

func (this *RewardLogIndexController) Deliveredbatch() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	// 条件 要和export、Get 函数保持一致
	beego.Informational("query rewardLog ")
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	timeStart := strings.TrimSpace(this.GetString("timeStart"))
	timeEnd := strings.TrimSpace(this.GetString("timeEnd"))
	delivered, _ := this.GetInt8("delivered", 2)

	o := orm.NewOrm()
	qs := o.QueryTable(new(RewardLog))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	if account != "" {
		cond = cond.And("Account__contains", account)
	}
	if timeStart != "" {
		cond = cond.And("CreateDate__gte", timeStart)
	}
	if timeEnd != "" {
		cond = cond.And("CreateDate__lte", timeEnd)
	}
	if delivered != 2 {
		cond = cond.And("Delivered", delivered)
	}
	qs = qs.SetCond(cond)
	if num, err := qs.Update(orm.Params{"Delivered": 1, "DeliveredTime": time.Now(), "Modifior": this.LoginAdminId}); err != nil {
		beego.Error("Delivered batch RewardLog error", err)
		msg = "批量标记失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功标记%d条记录", num)
	}
}

func (this *RewardLogIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	rewardLog := RewardLog{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&rewardLog)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	rewardLog.Deleted = 1
	_, err1 := o.Update(&rewardLog, "Deleted")
	if err1 != nil {
		beego.Error("Delete rewardLog error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

func (this *RewardLogIndexController) Delivered() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	delivered, _ := this.GetInt8("delivered")
	rl := RewardLog{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&rl)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		msg = "数据不存在，请确认"
		return
	}
	rl.Delivered = delivered
	rl.DeliveredTime = time.Now()
	rl.Modifior = this.LoginAdminId
	_, err1 := rl.Update("Delivered", "DeliveredTime")
	if err1 != nil {
		beego.Error("Enabled RewardLog error", err1)
		msg = "操作失败"
	} else {
		code = 1
		msg = "操作成功"
	}

}

func (this *RewardLogIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("导入中奖记录失败", err)
		msg = "导入失败，请重试（1）"
		return
	}
	fname := url.QueryEscape(h.Filename)
	suffix := utils2.SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".xlsx" {
		msg = "文件必须为xlsx"
		return
	}

	o := orm.NewOrm()
	rewardlogs := make([]RewardLog, 0)

	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("中奖记录导入失败", err)
		msg = "读取excel失败，请重试"
		return
	}
	if xlsx.GetSheetIndex("中奖记录") == 0 {
		msg = "不存在《中奖记录》sheet页"
		return
	}
	rows := xlsx.GetRows("中奖记录")
	for i, row := range rows {
		if i == 0 {
			continue
		}
		if len(row) < 3 {
			msg = fmt.Sprintf("%s第%d行账号为空<br>", msg, i+1)
			continue
		}
		id, _ := strconv.ParseInt(strings.TrimSpace(row[0]), 10, 64)
		bool := o.QueryTable(new(Game)).Filter("Id", id).Exist()
		if !bool {
			msg = fmt.Sprintf("%s第%d行活动Id不存在<br>", msg, i+1)
			return
		}
		rewardlog := RewardLog{GameId: id}
		rewardlog.Account = strings.TrimSpace(row[1])
		if rewardlog.Account == "" {
			msg = fmt.Sprintf("%s第%d行账号为空<br>", msg, i+1)
		}
		rewardlog.GiftName = strings.TrimSpace(row[2])
		if rewardlog.GiftName == "" {
			msg = fmt.Sprintf("%s第%d行奖品名称为空<br>", msg, i+1)
		}
		rewardlog.GiftContent = strings.TrimSpace(row[3])
		if rewardlog.GiftContent == "" {
			msg = fmt.Sprintf("%s第%d行奖品内容为空<br>", msg, i+1)
		}
		category1 := strings.TrimSpace(row[4])
		if category1 == "" {
			msg = fmt.Sprintf("%s第%d行奖品类别为空<br>", msg, i+1)
		}
		category, _ := strconv.ParseInt(strings.TrimSpace(row[4]), 10, 64)
		rewardlog.Category = category
		rewardlog.Creator = this.LoginAdminId
		rewardlog.Modifior = this.LoginAdminId
		rewardlog.CreateDate = time.Now()
		rewardlog.ModifyDate = time.Now()
		rewardlog.Version = 0
		rewardlog.Delivered = 0
		rewardlogs = append(rewardlogs, rewardlog)
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
		return
	}
	rlen := len(rewardlogs)
	if rlen == 0 {
		msg = "没有需要导入的数据"
		return
	}
	var susNums int64
	// 将数组拆分导入，一次1000条
	for i := 0; i <= rlen/1000; i++ {
		end := 0
		if (i+1)*1000 >= rlen {
			end = rlen
		} else {
			end = (i + 1) * 1000
		}
		tmpArr := rewardlogs[i*1000 : end]

		if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
			beego.Error("中奖记录导入失败", err)
		} else {
			susNums += nums
		}
	}
	code = 1
	msg = fmt.Sprintf("%s成功导入%d条记录", msg, susNums)
	return
}

type RewardLogAddController struct {
	sysmanage.BaseController
}

func (this *RewardLogAddController) Get() {
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "rewardlog/add.tpl"
}

func (this *RewardLogAddController) Post() {
	var code int
	var msg string
	var url = beego.URLFor("RewardLogIndexController.Get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	rewardLog := RewardLog{}
	if err := this.ParseForm(&rewardLog); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&rewardLog); hasError {
		msg = errMsg
		return
	}
	rewardLog.Creator = this.LoginAdminId
	rewardLog.Modifior = this.LoginAdminId
	_, err1 := rewardLog.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert rewardLog error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type RewardLogEditController struct {
	sysmanage.BaseController
}

func (this *RewardLogEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	rewardLog := RewardLog{BaseModel: BaseModel{Id: id}}

	err := o.Read(&rewardLog)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("RewardLogIndexController.get"), 302)
	} else {
		this.Data["data"] = rewardLog
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "rewardlog/edit.tpl"
	}
}

func (this *RewardLogEditController) Post() {
	var code int
	var msg string
	var url = beego.URLFor("RewardLogIndexController.Get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	rewardLog := RewardLog{}
	if err := this.ParseForm(&rewardLog); err != nil {
		msg = "参数异常"
		return
	}
	cols := []string{"Account", "GiftId", "GiftName", "GiftContent", "Delivered", "DeliveredTime"}
	rewardLog.Modifior = this.LoginAdminId
	_, err1 := rewardLog.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("Update rewardLog error", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}
