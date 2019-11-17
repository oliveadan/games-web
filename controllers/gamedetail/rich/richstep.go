package rich

import (
	"fmt"
	. "games-web/models/common"
	. "games-web/models/gamedetail/rich"
	"games-web/utils"
	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"os"
	"phage/controllers/sysmanage"
	. "phage/models"
	"time"
)

type RichStepIndexController struct {
	sysmanage.BaseController
}

func (this *RichStepIndexController) Get() {
	beego.Informational("query RichStep ")

	gId, _ := this.GetInt64("gameId", 0)
	i, _ := this.GetInt("isExport")
	if i == 1 {
		this.Export(gId)
	}
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(RichStep).Paginate(page, limit, gId)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["gameList"] = GetGames("rich")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/rich/richstep/index.tpl"
}

func (this *RichStepIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	step := RichStep{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&step)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err = o.Delete(&step, "Id")
	if err != nil {
		beego.Error("删除失败参与情况失败", err)
		msg = "删除失败"
		return
	} else {
		code = 1
		msg = "删除成功"
		return
	}
}

func (this *RichStepIndexController) Export(gid int64) {
	o := orm.NewOrm()
	var richsteps []RichStep
	_, err := o.QueryTable(new(RichStep)).Filter("GameId", gid).Limit(-1).All(&richsteps)
	if err != nil {
		beego.Error("大富翁会员参与情况导出失败", err)
	}
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "活动名称")
	xlsx.SetCellValue("Sheet1", "B1", "会员账号")
	xlsx.SetCellValue("Sheet1", "C1", "总步数")
	xlsx.SetCellValue("Sheet1", "D1", "最近参与")
	for i, value := range richsteps {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), utils.GetGameName(value.GameId))
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.StepCount)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.LastDate.Format("2006-01-02 15:04:05"))
	}
	fileName := fmt.Sprintf("./tmp/excel/richsteplist_%s.xlsx", time.Now().Format("20060102150405"))
	err1 := xlsx.SaveAs(fileName)
	if err1 != nil {
		beego.Error("大富翁会员参与情况导出失败", err1.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}
