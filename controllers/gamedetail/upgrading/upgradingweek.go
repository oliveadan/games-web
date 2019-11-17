package upgrading

import (
	"fmt"
	. "games-web/models/common"
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
	. "phage/utils"
	"strconv"
	"strings"
	"time"
)

type UpgradingWeekController struct {
	sysmanage.BaseController
}

func (this *UpgradingWeekController) Prepare() {
	this.EnableXSRF = false
}
func (this *UpgradingWeekController) Get() {
	//导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}
	beego.Informational("query upgradingweek")
	gId, _ := this.GetInt64("gameId", 0)
	account := this.GetString(strings.TrimSpace("account"))
	totalamount1 := this.GetString(strings.TrimSpace("totalamount"))
	period := this.GetString(strings.TrimSpace("Period"))
	delivered, _ := this.GetInt64("delivered", 0)
	riseamount := strings.TrimSpace(this.GetString("RiseAmount"))
	countstatus := strings.TrimSpace(this.GetString("CountStatus"))
	//获取周榜期数
	if gId != 0 {
		_, periods := utils.GetPeriodMap(gId)
		this.Data["periods"] = periods
	}
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(UpgradingWeek).Paginate(page, limit, gId, account, totalamount1, period, delivered, riseamount, countstatus)
	pagination.SetPaginator(this.Ctx, limit, total)
	this.Data["condArr"] = map[string]interface{}{"account": account,
		"totalamount":   totalamount1,
		"delivered":     delivered,
		"currentperiod": period,
		"riseamount":    riseamount,
		"countstatus":   countstatus}
	this.Data["dataList"] = list
	this.Data["gameList"] = GetGames("upgrading")
	this.TplName = "gamedetail/upgrading/upgradingweek/index.tpl"
}

func (this *UpgradingWeekController) CountGift() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	period, _ := this.GetInt64("Period", 10, 64)
	o := orm.NewOrm()
	//如果不是最新的一期不能进行计算
	var ug UpgradingWeek
	err := o.QueryTable(new(UpgradingWeek)).OrderBy("-Period").One(&ug, "Period")
	if err != nil {
		beego.Error("获取最新一期失败", err)
		msg = "获取最新一期失败"
		return
	}
	/*var ug1 UpgradingWeek
	err11 := o.QueryTable(new(UpgradingWeek)).Filter("Period", period).One(&ug1, "CountEnable")
	if err11 != nil {
		beego.Error("获取最新一期失败", err)
		msg = "获取最新一期失败"
		return
	}*/
	if period != ug.Period {
		msg = "只能计算最新一期"
		return
	}
	/*if ug1.CountEnable == 1 {
		msg = "本期已经计算，不能重复计算！"
		return
	}*/
	//获取要计算的周信息
	var ugs []UpgradingWeek
	_, err1 := o.QueryTable(new(UpgradingWeek)).Filter("GameId", gId).Filter("Period", period).Filter("CountEnable", 0).Limit(-1).All(&ugs)
	if err1 != nil {
		beego.Error("获取周信息失败", err1)
		msg = "获取周信息失败"
		return
	}
	if len(ugs) < 1 {
		msg = "所有数据已经计算完毕"
		return
	}
	//获取配置信息
	var ucs []UpgradingConfig
	_, err2 := o.QueryTable(new(UpgradingConfig)).Filter("GameId", gId).OrderBy("-Level").All(&ucs)
	if err2 != nil {
		beego.Error("获取配置信息失败", err2)
		msg = "获取配置信息失败"
		return
	}
	//获取等级1的信息
	var one UpgradingConfig
	err3 := o.QueryTable(new(UpgradingConfig)).Filter("GameId", gId).OrderBy("Level").One(&one)
	if err3 != nil {
		beego.Error("获取等级1的信息失败", err3)
		msg = "获取最小等级失败"
		return
	}
	var upgradings []Upgrading
	var model Upgrading
	o.Begin()
	for _, v := range ugs {
		var ud Upgrading
		//获取会员的总信息
		err := o.QueryTable(new(Upgrading)).Filter("GameId", gId).Filter("Account", v.Account).One(&ud)
		//如果会员不存在进行插入
		if err != nil {
			//如果小于等级1，跳过本次循环
			if v.WeekAmount < one.TotalAmount {
				model.Account = v.Account
				model.TotalAmount = v.WeekAmount
				model.Level = 0
				model.GameId = gId
				model.TotalGift = 0
				model.Balance = one.TotalAmount - v.WeekAmount

				model.CreateDate = time.Now()
				model.ModifyDate = time.Now()
				model.Creator = this.LoginAdminId
				model.Modifior = this.LoginAdminId
				model.Version = 0
				upgradings = append(upgradings, model)
				continue
			}
			for _, j := range ucs {
				if v.WeekAmount >= j.TotalAmount {
					//晋升一个等级的情况
					if j.Level == 1 {
						model.Account = v.Account
						model.TotalAmount = v.WeekAmount
						model.Level = j.Level
						model.GameId = gId
						model.TotalGift = j.LevelGift
						var ugc UpgradingConfig
						err := o.QueryTable(new(UpgradingConfig)).Filter("Level", j.Level+1).One(&ugc, "TotalAmount")
						if err != nil {
							beego.Error(v.Account, "获取下一等级的投注额度失败", err)
							msg = "获取下一等级的投注额度失败"
							return
						}
						model.Balance = ugc.TotalAmount - v.WeekAmount

						model.CreateDate = time.Now()
						model.ModifyDate = time.Now()
						model.Creator = this.LoginAdminId
						model.Modifior = this.LoginAdminId
						model.Version = 0
						upgradings = append(upgradings, model)
						//更新电子金额家周信息
						_, err1 := o.QueryTable(new(UpgradingWeek)).Filter("Id", v.Id).Update(orm.Params{"RiseAmount": j.LevelGift})
						if err1 != nil {
							beego.Error("更新周信息失败", err1)
							msg = v.Account + "更新周信息失败"
							o.Rollback()
							return
						}
						break
						//连续跳级的情况
					} else if j.Level >= 2 {
						//获取连续跳级的奖励
						var sum int64
						for _, v := range ucs {
							if v.Level > j.Level {
								continue
							}
							sum += v.LevelGift
						}
						model.Account = v.Account
						model.TotalAmount = v.WeekAmount
						model.Level = j.Level
						model.GameId = gId
						model.TotalGift = sum
						var ugc UpgradingConfig
						err := o.QueryTable(new(UpgradingConfig)).Filter("Level", j.Level+1).One(&ugc, "TotalAmount")
						if err != nil {
							beego.Error(v.Account, "获取下一等级的投注额度失败", err)
							msg = "获取下一等级的投注额度失败"
							return
						}
						model.Balance = ugc.TotalAmount - v.WeekAmount

						model.CreateDate = time.Now()
						model.ModifyDate = time.Now()
						model.Creator = this.LoginAdminId
						model.Modifior = this.LoginAdminId
						model.Version = 0
						upgradings = append(upgradings, model)
						//更新电子金额家周信息
						_, err1 := o.QueryTable(new(UpgradingWeek)).Filter("Id", v.Id).Update(orm.Params{"RiseAmount": sum})
						if err1 != nil {
							beego.Error("更新周信息失败(1)", err1)
							msg = v.Account + "更新周信息失败(1)"
							o.Rollback()
							return
						}
						break
					}
				}
			}
			//总榜中会员已经存在
		} else {
			//如果投注额未达到vip1的要求跳过
			if ud.TotalAmount+v.WeekAmount < one.TotalAmount {
				upgrading := Upgrading{BaseModel: BaseModel{Id: ud.Id}}
				upgrading.Balance = one.TotalAmount - ud.TotalAmount - v.WeekAmount
				upgrading.TotalAmount = ud.TotalAmount + v.WeekAmount
				_, err := upgrading.Update("TotalAmount", "Balance")
				if err != nil {
					beego.Error("未晋级的情况更新失败", err)
					o.Rollback()
					msg = "系统异常0"
					return
				}
				continue
			}
			for _, j := range ucs {
				if ud.TotalAmount+v.WeekAmount >= j.TotalAmount {
					var ugc UpgradingConfig
					err := o.QueryTable(new(UpgradingConfig)).Filter("Level", j.Level+1).One(&ugc, "TotalAmount")
					if err != nil {
						beego.Error(v.Account, "获取下一等级的投注额度失败", err)
						msg = "获取下一等级的投注额度失败"
						return
					}
					var balance = ugc.TotalAmount - ud.TotalAmount - v.WeekAmount
					//未晋级的情况
					if ud.Level == j.Level {
						_, err := o.QueryTable(new(Upgrading)).Filter("Id", ud.Id).Update(orm.Params{
							"Balance":     balance,
							"TotalAmount": orm.ColValue(orm.ColAdd, v.WeekAmount)})
						if err != nil {
							beego.Error("未晋级的情况更新失败", err)
							o.Rollback()
							msg = "系统异常(0)"
							return
						}
						break
						//晋级一个等级
					} else if j.Level-ud.Level == 1 {
						_, err := o.QueryTable(new(Upgrading)).Filter("Id", ud.Id).Update(orm.Params{
							"Balance":     balance,
							"Level":       j.Level,
							"TotalAmount": orm.ColValue(orm.ColAdd, v.WeekAmount),
							"TotalGift":   orm.ColValue(orm.ColAdd, j.LevelGift)})
						if err != nil {
							beego.Error("会员存在，晋级一个等级更新失败", err)
							o.Rollback()
							msg = "系统异常(1)"
							return
						}
						//更新会员周信息
						_, err1 := o.QueryTable(new(UpgradingWeek)).Filter("Id", v.Id).Update(orm.Params{"RiseAmount": j.LevelGift})
						if err != nil {
							beego.Error("会员存在，晋级一个等级更新失败", err1)
							o.Rollback()
							msg = "系统异常(2)"
							return
						}
						break
					} else if j.Level-ud.Level >= 2 {
						//跳级的所有奖励
						var sum int64
						for _, v := range ucs {
							if v.Level > j.Level || v.Level <= ud.Level {
								continue
							}
							sum += v.LevelGift
						}
						_, err := o.QueryTable(new(Upgrading)).Filter("Id", ud.Id).Update(orm.Params{
							"Balance":     balance,
							"Level":       j.Level,
							"TotalAmount": orm.ColValue(orm.ColAdd, v.WeekAmount),
							"TotalGift":   orm.ColValue(orm.ColAdd, sum)})
						if err != nil {
							beego.Error("会员存在连续跳级更新失败", err)
							o.Rollback()
							msg = "系统异常(1)"
							return
						}
						//更新会员周信息
						_, err1 := o.QueryTable(new(UpgradingWeek)).Filter("Id", v.Id).Update(orm.Params{"RiseAmount": sum})
						if err != nil {
							beego.Error("会员存在连续跳级更新失败", err1)
							o.Rollback()
							msg = "系统异常(2)"
							return
						}
						break
					}
				}
			}
		}
	}

	//在计算后生成会员统计列表

	var susNums int64
	//将数组拆分导入，一次1000条
	mlen := len(upgradings)
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
			tmpArr := upgradings[i*1000 : end]
			if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
				o.Rollback()
				beego.Error("插入会员总投注失败", err)
				return
			} else {
				susNums += nums
			}
		}
	}
	o.Commit()
	code = 1
	_, err0 := o.QueryTable(new(UpgradingWeek)).Filter("Period", period).Update(orm.Params{"CountEnable": 1})
	if err0 != nil {
		msg = "更新标识失败"
		return
	}
	msg = "计算成功"
}

func (this *UpgradingWeekController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	upgradingweek := UpgradingWeek{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	_, err := o.Delete(&upgradingweek, "Id")
	if err != nil {
		beego.Error("Delete upgradingweek error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

func (this *UpgradingWeekController) Delivered() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	delivered, _ := this.GetInt64("delivered")
	rl := UpgradingWeek{BaseModel: BaseModel{Id: id}}
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

func (this *UpgradingWeekController) Delbatch() {
	beego.Informational("Delete batch")
	period := this.GetString("Period")
	period1, _ := strconv.ParseInt(period, 10, 64)
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	o := orm.NewOrm()
	upgradingweek := UpgradingWeek{Period: period1}
	num, err := o.Delete(&upgradingweek, "Period")
	if err != nil {
		beego.Error("Delete upgradingweek error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功删除%d条", num)
	}
}

func (this *UpgradingWeekController) Deliveredbatch() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	beego.Informational("Deliveredbatch")
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	totalamount := strings.TrimSpace(this.GetString("totalamount"))
	period := strings.TrimSpace(this.GetString("Period"))
	delivered, _ := this.GetInt8("delivered", 2)

	o := orm.NewOrm()
	qs := o.QueryTable(new(UpgradingWeek))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	if account != "" {
		cond = cond.And("Account__contains", account)
	}
	if totalamount != "" {
		cond = cond.And("WeekAmount__exact", totalamount)
	}
	if period != "" {
		cond = cond.And("Period__exact", period)
	}
	if delivered != 2 {
		cond = cond.And("Delivered", delivered)
	}
	qs = qs.SetCond(cond)
	if num, err := qs.Update(orm.Params{"Delivered": 1, "DeliveredTime": time.Now(), "Modifior": this.LoginAdminId}); err != nil {
		beego.Error("Delivered batch upgrading error", err)
		msg = "批量标记失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功标记%d条记录", num)
	}

}

func (this *UpgradingWeekController) Import() {
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
	suffix := SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".xlsx" {
		msg = "文件必须为 xlsx"
		return
	}
	o := orm.NewOrm()
	models := make([]UpgradingWeek, 0)
	/*idsDel := make([]int64, 0)*/

	//xlsx
	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("ranking import, open excel error", err)
		msg = "读取excel失败，请重试"
		return
	}

	if xlsx.GetSheetIndex("电子升级榜周信息") == 0 {
		msg = "不存在<<电子升级榜周信息>>"
		return
	}
	rows := xlsx.GetRows("电子升级榜周信息")
	//定义期数，用以查询是否存在
	var period int64
	var gameid int64
	for i, row := range rows {
		if i == 0 {
			period1, err := strconv.ParseInt(strings.TrimSpace(row[1]), 10, 0)
			period = period1
			if err != nil {
				msg = fmt.Sprintf("%s第%d行排行榜期数必须为数字<br>", msg, i+1)
				return
			}
			gameid1, err := strconv.ParseInt(strings.TrimSpace(row[3]), 10, 0)
			gameid = gameid1
			if err != nil {
				msg = fmt.Sprintf("%s第%d行游戏id数必须为数字<br>", msg, i+1)
				return
			}
			continue
		}
		if i == 1 {
			continue
		}
		if len(row) < 1 {
			msg = fmt.Sprintf("%s第%d行活动会员账号、有效投注不能为空<br>", msg, i+1)
			continue
		}
		account := strings.TrimSpace(row[0])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
		}
		amount, err := strconv.ParseInt(strings.TrimSpace(row[1]), 10, 0)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
			continue
		}
		//查询活动是否存在
		bool := o.QueryTable(new(Game)).Filter("Deleted", 0).Filter("Id", gameid).Exist()
		if !bool {
			msg = fmt.Sprint("活动不存在，请先创建活动。")
			return
		}
		model := UpgradingWeek{}
		model.Period = period
		model.Account = account
		model.WeekAmount = amount
		model.GameId = gameid
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
	var lists []orm.ParamsList
	num, err := o.Raw("SELECT account FROM ph_upgrading_week  WHERE period = ?  GROUP BY account,period HAVING count(*) > 1", period).ValuesList(&lists)
	if err == nil && num > 0 {
		var s string
		for _, v := range lists {
			s += v[0].(string) + " "
		}
		msg = fmt.Sprintf("请处理重复账号%s,<br>成功导入%d条记录", s, susNums)
	} else {
		code = 1
		msg = fmt.Sprintf("成功导入%d条记录", susNums)
	}
	return
}

func (this *UpgradingWeekController) Export() {
	beego.Informational("export upgrading")
	gId, _ := this.GetInt64("gameId", 0)
	account := this.GetString(strings.TrimSpace("account"))
	totalamount1 := this.GetString(strings.TrimSpace("totalamount"))
	period := this.GetString(strings.TrimSpace("Period"))
	delivered, _ := this.GetInt64("delivered", 2)
	riseamount := strings.TrimSpace(this.GetString("RiseAmount"))
	countstatus := strings.TrimSpace(this.GetString("CountStatus"))

	page := 1
	limit := 1000
	list, total := new(UpgradingWeek).Paginate(page, limit, gId, account, totalamount1, period, delivered, riseamount, countstatus)
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(UpgradingWeek).Paginate(page, limit, gId, account, totalamount1, period, delivered, riseamount, countstatus)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}
	gameName := utils.GetGameName(gId)
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "游戏名称")
	xlsx.SetCellValue("Sheet1", "B1", "会员账号")
	xlsx.SetCellValue("Sheet1", "C1", "投注金额")
	xlsx.SetCellValue("Sheet1", "D1", "晋级彩金")
	xlsx.SetCellValue("Sheet1", "E1", "期数")
	xlsx.SetCellValue("Sheet1", "F1", "是否派送")
	xlsx.SetCellValue("Sheet1", "G1", "派送时间")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), gameName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.WeekAmount)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.RiseAmount)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("E%d", i+2), value.Period)
		if value.Delivered == 1 {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("F%d", i+2), "已派送")
		} else {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("F%d", i+2), "未派送")
		}
		if !value.DeliveredTime.IsZero() {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("G%d", i+2), value.DeliveredTime.Format("2006-01-02 15:04:05"))
		}
	}
	fileName := fmt.Sprintf("./tmp/excel/upgradingweeklist_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export reward error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

type AddUpgradingWeekController struct {
	sysmanage.BaseController
}

func (this *AddUpgradingWeekController) Get() {
	beego.Informational("add upgardingweek")
	this.Data["gameList"] = GetGames("upgrading")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/upgrading/upgradingweek/add.tpl"
}

func (this *AddUpgradingWeekController) Post() {
	var code int
	var msg string
	url := beego.URLFor("UpgradingWeekController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	period, _ := this.GetInt("Period")
	upgradingweek := UpgradingWeek{}
	if err := this.ParseForm(&upgradingweek); err != nil {
		msg = "参数异常"
		return
	}
	periods, _ := utils.GetPeriodMap(upgradingweek.GameId)
	upgradingweek.PeriodString = periods[period]
	config := GetDetail(upgradingweek.WeekAmount, upgradingweek.GameId)
	upgradingweek.RiseAmount = config.LevelGift
	upgradingweek.Creator = this.LoginAdminId
	upgradingweek.Modifior = this.LoginAdminId
	_, err1 := upgradingweek.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert upgradingweek error", err1)
	} else {
		code = 1
		msg = "添加成功"
		return
	}
}

type EditUpgradingWeekController struct {
	sysmanage.BaseController
}

func (this *EditUpgradingWeekController) Get() {
	this.Data["gameList"] = GetGames("upgrading")
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	upgradingweek := UpgradingWeek{BaseModel: BaseModel{Id: id}}
	err := o.Read(&upgradingweek)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("UpgradingWeekController.get"), 302)
	} else {
		this.Data["gameList"] = GetGames("upgrading")
		this.Data["data"] = upgradingweek
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/upgrading/upgradingweek/edit.tpl"
	}
}

func (this *EditUpgradingWeekController) Post() {
	var code int
	var msg string
	url := beego.URLFor("UpgradingWeekController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	upgradingweek := UpgradingWeek{}
	if err := this.ParseForm(&upgradingweek); err != nil {
		msg = "参数异常"
		return
	}
	periods, _ := utils.GetPeriodMap(upgradingweek.GameId)
	config := GetDetail(upgradingweek.WeekAmount, upgradingweek.GameId)
	upgradingweek.RiseAmount = config.LevelGift
	period := int(upgradingweek.Period)
	upgradingweek.PeriodString = periods[period]
	cols := []string{"Account", "WeekAmount", "Period", "RiseAmount", "PeriodString"}
	upgradingweek.Modifior = this.LoginAdminId
	_, err := upgradingweek.Update(cols...)
	if err != nil {
		msg = "更新失败"
		beego.Error("Update upgradingweek error", err)
	} else {
		code = 1
		msg = "更新成功"
	}
}

//根据投注金额获取对应的周榜单信息
func GetDetail(amount int64, gid int64) UpgradingConfig {
	//获取电子升级榜配置信息
	upgradingconfigs := GetUpgradingConfigs(gid)
	for _, v := range upgradingconfigs {
		if amount > v.TotalAmount {
			return v
		}
	}
	return UpgradingConfig{}
}
