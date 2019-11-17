package vote

import (
	"fmt"
	"os"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/vote"
	"phage-games-web/utils"
	"phage/controllers/sysmanage"
	. "phage/models"
	"strings"
	"time"

	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"math"
)

type VoteDetailIndexController struct {
	sysmanage.BaseController
}

func (this *VoteDetailIndexController) Get() {
	// 是否导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	// 条件 要和Export函数保持一致
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	timeStart := strings.TrimSpace(this.GetString("timeStart"))
	timeEnd := strings.TrimSpace(this.GetString("timeEnd"))
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(VoteDetail).Paginate(page, limit, gId, account, timeStart, timeEnd)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["condArr"] = map[string]interface{}{"account": account,
		"timeStart": timeStart,
		"timeEnd":   timeEnd}
	this.Data["gameList"] = GetGames("vote", "fifa", "vote2", "fifa2018")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/vote/votedetail/index.tpl"
}

func (this *VoteDetailIndexController) Export() {
	// 条件 要和get函数保持一致
	gId, _ := this.GetInt64("gameId", 0)
	account := strings.TrimSpace(this.GetString("account"))
	timeStart := strings.TrimSpace(this.GetString("timeStart"))
	timeEnd := strings.TrimSpace(this.GetString("timeEnd"))

	page := 1
	limit := 1000
	list, total := new(VoteDetail).Paginate(page, limit, gId, account, timeStart, timeEnd)
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(VoteDetail).Paginate(page, limit, gId, account, timeStart, timeEnd)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}

	gameName := utils.GetGameName(gId)
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "ID")
	xlsx.SetCellValue("Sheet1", "B1", "活动名称")
	xlsx.SetCellValue("Sheet1", "C1", "投票人")
	xlsx.SetCellValue("Sheet1", "D1", "选票名称")
	xlsx.SetCellValue("Sheet1", "E1", "投票IP")
	xlsx.SetCellValue("Sheet1", "F1", "投票时间")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), value.Id)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), gameName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.VoteItemName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("E%d", i+2), value.Ip)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("F%d", i+2), value.CreateDate.Format("2006-01-02 15:04:05"))
	}
	// Save xlsx file by the given path.
	fileName := fmt.Sprintf("./tmp/excel/votedetail_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export votedetail error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

func (this *VoteDetailIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	model := VoteDetail{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	if _, err := o.Delete(&model); err != nil {
		beego.Error("Delete VoteDetail error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}
