package monthsignin

import (
	"fmt"
	"games-web/models/common"
	. "games-web/models/gamedetail/monthsignin"
	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	_ "github.com/astaxie/beego/logs"
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

type MonthsigninBetIndexController struct {
	sysmanage.BaseController
}

func (this *MonthsigninBetIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *MonthsigninBetIndexController) Get() {
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(MonthsigninBet).Paginate(page, limit, gId, account)
	pagination.SetPaginator(this.Ctx, limit, total)
	this.Data["condArr"] = map[string]interface{}{
		"account": account}
	this.Data["gameList"] = common.GetGames("monthsign")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/monthsignin/index.tpl"
}

func (this *MonthsigninBetIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	bet := MonthsigninBet{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&bet)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err = o.Delete(&bet, "Id")
	if err != nil {
		logs.Error("Delete monthsignin error", err)
		msg = "删除失败"
		return
	}
	code = 1
	msg = "删除成功"
	return
}

func (this *MonthsigninBetIndexController) DelBatch() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	o := orm.NewOrm()
	num, err := o.QueryTable(new(MonthsigninBet)).Filter("Id__gt", 0).Delete()
	if err != nil {
		logs.Error("Delete batch MonthsigninBet")
		msg = fmt.Sprintf("删除失败,%v", err)
		return
	}
	code = 1
	msg = fmt.Sprintf("成功删除%d条数据", num)
}

type MonthsigninBetAddController struct {
	sysmanage.BaseController
}

func (this *MonthsigninBetAddController) Get() {
	this.Data["gameList"] = common.GetGames("monthsign")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/monthsignin/add.tpl"
}

func (this *MonthsigninBetAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	m := MonthsigninBet{}
	if err := this.ParseForm(&m); err != nil {
		msg = "参数异常"
		return
	}
	m.Creator = this.LoginAdminId
	m.Modifior = this.LoginAdminId
	m.SurplusBet = m.Bet
	i, _, err := m.ReadOrCreate("Account")
	if err != nil {
		logs.Error("insert MonthsigninBet error", err)
		msg = "添加失败"
		return
	}
	if !i {
		msg = "会员已经存在"
		return
	}
	code = 1
	msg = "添加成功"
}

type MonthsigninBetEditController struct {
	sysmanage.BaseController
}

func (this *MonthsigninBetEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	mb := MonthsigninBet{BaseModel: BaseModel{Id: id}}
	err := o.Read(&mb)
	if err == orm.ErrMissPK || err == orm.ErrNoRows {
		this.Redirect(beego.URLFor("MonthsigninBetIndexController.get"), 302)
	} else {
		this.Data["data"] = mb
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/monthsignin/edit.tpl"
	}
}

func (this *MonthsigninBetEditController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	mb := MonthsigninBet{}
	if err := this.ParseForm(&mb); err != nil {
		msg = "参数异常"
		return
	}
	cols := []string{"Account", "Bet", "SurplusBet"}
	_, err := mb.Update(cols...)
	if err != nil {
		logs.Error("update monsigninbet error", err)
		msg = "更新失败"
		return
	}
	code = 1
	msg = "更新成功"
}

func (this *MonthsigninBetIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	file, header, err := this.GetFile("file")
	if err != nil {
		beego.Error("upgradingWeek upload file get file error", err)
		msg = "上传失败，请重试(1)"
		return
	}
	fNmae := url.QueryEscape(header.Filename)
	suffix := utils.SubString(fNmae, len(fNmae), strings.LastIndex(fNmae, ".")-len(fNmae))
	if suffix != ".xlsx" {
		msg = "文件必须为 xlsx"
		return
	}
	o := orm.NewOrm()
	models := make([]MonthsigninBet, 0)
	xlsx, err := excelize.OpenReader(file)
	if err != nil {
		msg = "读取文件失败"
		return
	}
	if xlsx.GetSheetIndex("月签到会员投注") == 0 {
		msg = "不存在《月签到会员投注》"
		return
	}
	rows := xlsx.GetRows("月签到会员投注")
	var gameId int64
	for i, row := range rows {
		if i == 0 {
			//获取游戏ID 并验证活动是否存在
			logs.Info(len(row))
			if len(row) < 4 {
				msg = "活动ID不能为空"
				return
			}
			gId := strings.TrimSpace(row[3])
			exist := o.QueryTable(new(common.Game)).Filter("Id", gId).Exist()
			if !exist {
				msg = "活动不存在,请核对活动ID"
				return
			}
			i2, _ := strconv.ParseInt(gId, 10, 64)
			gameId = i2
			continue
		}
		account := strings.TrimSpace(row[0])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
		}
		bet, err := strconv.ParseInt(strings.TrimSpace(row[1]), 10, 64)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行会员投注必须为数字<br>", msg, i+1)
		}
		MonthsigninBet := MonthsigninBet{}
		MonthsigninBet.CreateDate = time.Now()
		MonthsigninBet.ModifyDate = time.Now()
		MonthsigninBet.Modifior = this.LoginAdminId
		MonthsigninBet.Creator = this.LoginAdminId
		MonthsigninBet.GameId = gameId
		MonthsigninBet.Account = account
		MonthsigninBet.Bet = bet
		MonthsigninBet.SurplusBet = bet
		models = append(models, MonthsigninBet)
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
		return
	}
	lM := len(models)
	if lM == 0 {
		msg = "没有需要导入的数据"
		return
	}
	o.Begin()
	var susNums int64
	//将数据拆分导入,一次1000条
	for i := 0; i <= lM/1000; i++ {
		end := 0
		if (i+1)*1000 >= lM {
			end = lM
		} else {
			end = (i + 1) * 1000
		}
		if i*1000 == end {
			continue
		}
		tmpArr := models[i*1000 : end]
		if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
			o.Rollback()
			beego.Error("monthsigninbet insert error", err)
			msg = fmt.Sprintf("上传失败,%v", err)
			return
		} else {
			susNums += nums
		}
	}
	o.Commit()
	code = 1
	msg = fmt.Sprintf("成功导入%d条记录", susNums)
}
