package upgrading

import (
	"fmt"
	"games-web/models/common"
	. "games-web/models/gamedetail/upgrading"
	"games-web/utils"
	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"html/template"
	"math"
	"net/url"
	"os"
	"phage/controllers/sysmanage"
	. "phage/models"
	utils2 "phage/utils"
	"strconv"
	"strings"
	"time"
)

type UpgradingController struct {
	sysmanage.BaseController
}

func (this *UpgradingController) Prepare() {
	this.EnableXSRF = false
}

func (this *UpgradingController) Get() {
	//导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}
	beego.Informational("query upgrading")
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	totalamount1 := strings.TrimSpace(this.GetString("totalamount"))
	currentgift := strings.TrimSpace(this.GetString("CurrentGift"))
	//总榜的信息是所有周榜之和，获取总榜信息后，查询表如果不存在或者不相同就插入

	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(Upgrading).Paginate(page, limit, gId, account, totalamount1, currentgift)
	pagination.SetPaginator(this.Ctx, limit, total)
	this.Data["condArr"] = map[string]interface{}{
		"account":     account,
		"totalamount": totalamount1,
		"currentgift": currentgift}
	this.Data["gameList"] = common.GetGames("upgrading")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/upgrading/upgrading/index.tpl"
}

func (this *UpgradingController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("upgradingWeek upload file get file error", err)
		msg = "上传失败，请重试(1)"
		return
	}
	fname := url.QueryEscape(h.Filename)
	suffix := utils2.SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".xlsx" {
		msg = "文件必须为 xlsx"
		return
	}
	o := orm.NewOrm()
	models := make([]Upgrading, 0)
	//xlsx
	xlsx, err := excelize.OpenReader(f)
	if xlsx.GetSheetIndex("金管家总信息") == 0 {
		msg = "不存在<<金管家总信息>>"
		return
	}
	rows := xlsx.GetRows("金管家总信息")
	for i, row := range rows {
		if i == 0 {
			continue
		}
		if len(row) < 7 {
			msg = fmt.Sprintf("%s第%d行活动会员账号、有效投注不能为空<br>", msg, i+1)
			continue
		}
		gameid, err := strconv.ParseInt(strings.TrimSpace(row[0]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
			continue
		}
		account := strings.TrimSpace(row[1])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
		}
		total, err := strconv.ParseInt(strings.TrimSpace(row[2]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
			continue
		}
		level, err := strconv.ParseInt(strings.TrimSpace(row[3]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
			continue
		}
		leiji, err := strconv.ParseInt(strings.TrimSpace(row[4]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
			continue
		}
		/*	week, err := strconv.ParseInt(strings.TrimSpace(row[5]), 10, 64)
			if err != nil {
				msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
				continue
			}
			month, err := strconv.ParseInt(strings.TrimSpace(row[6]), 10, 64)
			if err != nil {
				msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
				continue
			}*/
		cha, err := strconv.ParseInt(strings.TrimSpace(row[7]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
			continue
		}

		//获取第几周时间

		model := Upgrading{}
		model.GameId = gameid
		model.Account = account
		model.TotalAmount = total
		model.Level = level
		model.TotalGift = leiji
		model.Balance = cha
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
			beego.Error("upgradingweek import, insert error", err)
			msg = "上传失败，请重试(2)"
			return
		} else {
			susNums += nums
		}
	}
	o.Commit()
	code = 1
	msg = fmt.Sprintf("成功导入%d条记录", susNums)
}

//计算周俸禄
func (this *UpgradingController) CountWeek() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	o := orm.NewOrm()
	//获取配置信息
	var udcs []UpgradingConfig
	_, err := o.QueryTable(new(UpgradingConfig)).Filter("GameId", gId).Filter("WeekAmount__gt", 0).OrderBy("Level").All(&udcs)
	if err != nil {
		beego.Error("获取配置信息失败", err)
		msg = "获取配置信息失败"
		return
	}
	//获取所有总榜信息
	var ups []Upgrading
	_, err1 := o.QueryTable(new(Upgrading)).Filter("GameId", gId).Filter("Level__gt", 1).Limit(-1).All(&ups)
	if err1 != nil {
		beego.Error("获取总榜信息失败", err1)
		msg = "获取总榜信息失败"
		return
	}
	var sum int64
	for _, v := range ups {
		for _, j := range udcs {
			o.Begin()
			if v.Level == j.Level {
				if j.WeekAmount == 0 {
					break
				} else {
					_, err := o.QueryTable(new(Upgrading)).Filter("Id", v.Id).Update(orm.Params{"WeekSalary": j.WeekAmount, "ModifyDate": time.Now()})
					if err != nil {
						beego.Error(v.Account, "更新周俸禄失败", err)
						o.Rollback()
						msg = "更新周俸禄失败"
						return
					}
					sum += 1
					break
				}
			}
		}
	}
	code = 1
	o.Commit()
	msg = fmt.Sprintf("已成功更新%d个会员的周俸禄", sum)
}

//计算月俸禄
func (this *UpgradingController) CountMonth() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	o := orm.NewOrm()
	//获取配置信息
	var udcs []UpgradingConfig
	_, err := o.QueryTable(new(UpgradingConfig)).Filter("GameId", gId).OrderBy("Level").All(&udcs)
	if err != nil {
		beego.Error("获取配置信息失败", err)
		msg = "获取配置信息失败"
		return
	}
	//获取所有总榜信息
	var ups []Upgrading
	_, err1 := o.QueryTable(new(Upgrading)).Filter("GameId", gId).Filter("Level__gt", 0).Limit(-1).All(&ups)
	if err1 != nil {
		beego.Error("获取总榜信息失败", err1)
		msg = "获取总榜信息失败"
		return
	}
	//统计成功更新多少会员
	var sum int64
	for _, v := range ups {
		for _, j := range udcs {
			o.Begin()
			if v.Level == j.Level {
				if j.MonthAmount == 0 {
					break
				} else {
					_, err := o.QueryTable(new(Upgrading)).Filter("Id", v.Id).Update(orm.Params{"MonthSalary": j.MonthAmount, "ModifyDate": time.Now()})
					if err != nil {
						beego.Error(v.Account, "更新月俸禄失败", err)
						o.Rollback()
						msg = "更新月俸禄失败"
						return
					}
					sum += 1
					break
				}
			}
		}
	}
	code = 1
	o.Commit()
	msg = fmt.Sprintf("已成功更新%d个会员的月俸禄", sum)
}

func (this *UpgradingController) CreateTotal() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	o := orm.NewOrm()
	//删除所有，再插入
	upgradingdel := Upgrading{GameId: gId}
	_, err0 := o.Delete(&upgradingdel, "GameId")
	if err0 != nil {
		beego.Error("删除之前的所有记录失败", err0)
		msg = "删除之前的所有记录失败"
		return
	}
	models := make([]Upgrading, 0)
	//idsDel := make([]int64, 0)
	var totals []orm.ParamsList
	//var upgrading Upgrading
	_, err := o.Raw("SELECT account ,SUM(week_amount) from ph_upgrading_week where game_id = ? group by account", gId).ValuesList(&totals)
	if err != nil {
		beego.Error("查询总信息错误", err)
	}
	for _, v := range totals {
		totalamount, _ := strconv.ParseInt(v[1].(string), 10, 64)
		//var upgradingweeegift UpgradingWeek
		//err := o.Raw("select a.* from ph_upgrading_week a where period = (select max(period) from ph_upgrading_week ) and account = ? ", v[0].(string)).QueryRow(&upgradingweeegift)
		model := Upgrading{}
		/*if err != nil {
			model.CurrentGift = 0
		} else {
			model.CurrentGift = upgradingweeegift.RiseAmount

		}*/
		total1 := GetDetail(totalamount, gId)
		//计算和下一级的差额
		next := GetNextAmount(total1.Level)
		balance := next - totalamount
		model.Account = v[0].(string)
		model.TotalAmount = totalamount
		model.Level = total1.Level
		model.TotalGift = GetTotalGift(total1.LevelGift, gId)
		model.WeekSalary = total1.WeekAmount
		if balance < 0 {
			balance = 0
		}
		model.Balance = balance
		model.GameId = gId
		model.MonthSalary = total1.MonthAmount
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		model.CreateDate = time.Now()
		model.ModifyDate = time.Now()
		model.Version = 0
		models = append(models, model)
		//}
	}
	o.Begin()
	var susNums int64
	//将数组拆分导入，一次1000条
	mlen := len(models)
	if mlen > 0 {
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
				beego.Error("upgrading  insert error", err)
				return
			} else {
				susNums += nums
			}
		}
	}
	o.Commit()
	code = 1
	msg = "生成成功"
}

func (this *UpgradingController) Delbatch() {
	beego.Informational("Delete batch")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	o := orm.NewOrm()
	model := Upgrading{GameId: gId}
	if num, err := o.Delete(&model, "GameId"); err != nil {
		beego.Error("Delete batch upgrading error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功删除%d条记录", num)
	}
}

func (this *UpgradingController) Export() {
	beego.Informational("export upgrading")
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	totalamount1 := strings.TrimSpace(this.GetString("totalamount"))
	currentgift := strings.TrimSpace(this.GetString("CurrentGift"))

	page := 1
	limit := 1000
	list, total := new(Upgrading).Paginate(page, limit, gId, account, totalamount1, currentgift)
	totalInt := int(total)
	if totalInt > limit {
		//全部转换为float64进行计算
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		//用此函数如果有余数，就向上加一
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(Upgrading).Paginate(page, limit, gId, account, totalamount1, currentgift)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}
	gameName := utils.GetGameName(gId)
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "活动名称")
	xlsx.SetCellValue("Sheet1", "B1", "会员账号")
	xlsx.SetCellValue("Sheet1", "C1", "总投注额")
	xlsx.SetCellValue("Sheet1", "D1", "当前等级")
	xlsx.SetCellValue("Sheet1", "E1", "累计晋级彩金")
	xlsx.SetCellValue("Sheet1", "F1", "周俸禄")
	xlsx.SetCellValue("Sheet1", "G1", "月俸禄")
	xlsx.SetCellValue("Sheet1", "H1", "距离晋级需投注金额")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), gameName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.TotalAmount)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.Level)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("E%d", i+2), value.TotalGift)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("F%d", i+2), value.WeekSalary)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("G%d", i+2), value.MonthSalary)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("H%d", i+2), value.Balance)
	}
	fileName := fmt.Sprintf("./tmp/excel/upgradinglist_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export reward error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

type UpgradingEditController struct {
	sysmanage.BaseController
}

func (this *UpgradingEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	upgrading := Upgrading{BaseModel: BaseModel{Id: id}}

	err := o.Read(&upgrading)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("UpgradingController.get"), 302)
	} else {
		this.Data["data"] = upgrading
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/upgrading/upgrading/edit.tpl"
	}

}

func (this *UpgradingEditController) Post() {
	var code int
	var msg string
	var url = beego.URLFor("UpgradingController.Get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)

	upgrading := Upgrading{}

	if err := this.ParseForm(&upgrading); err != nil {
		msg = "参数异常"
		return
	}
	cols := []string{"TotalAmount", "Level", "TotalGift", "WeekSalary", "MonthSalary", "Balance"}
	upgrading.Modifior = this.LoginAdminId
	_, err1 := upgrading.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("更新upgrading失败", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}

//获取累计晋级彩金
func GetTotalGift(amount int64, gid int64) int64 {
	var num int64
	upgradingconfigs := GetUpgradingConfigs(gid)
	for _, v := range upgradingconfigs {
		if v.LevelGift < amount {
			num += v.LevelGift
		}
	}
	return num + amount
}

//获取下一等级需要的投注额
func GetNextAmount(level int64) (nextamount int64) {
	var upgradingconfig UpgradingConfig
	o := orm.NewOrm()
	o.QueryTable(new(UpgradingConfig)).Filter("Level", level+1).One(&upgradingconfig)
	return upgradingconfig.TotalAmount
}
