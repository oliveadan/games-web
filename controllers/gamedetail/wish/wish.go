package wish

import (
	"fmt"
	"os"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/wish"
	. "phage-games-web/models/gift"
	. "phage-games-web/models/rewardlog"
	"phage-games-web/utils"
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
)

func validate(wish *Wish) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(wish.Account, "errmsg").Message("会员账号必填")
	valid.MaxSize(wish.Account, 255, "errmsg").Message("会员账号最长255个字符")
	valid.Required(wish.Content, "errmsg").Message("愿望内容必填")
	valid.MaxSize(wish.Content, 1024, "errmsg").Message("愿望最长1024个字符")
	valid.Phone(wish.Mobile, "errmsg").Message("手机号格式不正确")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type WishIndexController struct {
	sysmanage.BaseController
}

func (this *WishIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *WishIndexController) Get() {
	beego.Info("id", this.LoginAdminId)
	// 导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}
	beego.Informational("query wish ")
	// 条件 要和export函数保持一致
	account := strings.TrimSpace(this.GetString("account"))
	orderFild := strings.TrimSpace(this.GetString("orderFild"))
	gId, _ := this.GetInt64("gameId", 0)
	enabled, _ := this.GetInt8("enabled", 9)

	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(Wish).Paginate(page, limit, gId, account, orderFild, enabled)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["condArr"] = map[string]interface{}{
		"account":   account,
		"orderFild": orderFild,
		"enabled":   enabled}
	this.Data["gameList"] = GetGames("wish")
	this.Data["dataList"] = list
	this.TplName = "gamedetail/wish/index.tpl"
}

func (this *WishIndexController) Export() {
	beego.Informational("export wish ")
	// 条件 要和get函数保持一致
	account := strings.TrimSpace(this.GetString("account"))
	orderFild := strings.TrimSpace(this.GetString("orderFild"))
	gId, _ := this.GetInt64("gameId", 0)
	enabled, _ := this.GetInt8("enabled", 9)

	page := 1
	limit := 1000
	list, total := new(Wish).Paginate(page, limit, gId, account, orderFild, enabled)
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(Wish).Paginate(page, limit, gId, account, orderFild, enabled)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}

	approvelMap := utils.GetApprovelMap()
	gameName := utils.GetGameName(gId)
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "ID")
	xlsx.SetCellValue("Sheet1", "B1", "活动名称")
	xlsx.SetCellValue("Sheet1", "C1", "会员账号")
	xlsx.SetCellValue("Sheet1", "D1", "手机号")
	xlsx.SetCellValue("Sheet1", "E1", "愿望内容")
	xlsx.SetCellValue("Sheet1", "F1", "点赞次数")
	xlsx.SetCellValue("Sheet1", "G1", "审核状态")
	xlsx.SetCellValue("Sheet1", "H1", "许愿时间")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), value.Id)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), gameName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.Mobile)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("E%d", i+2), value.Content)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("F%d", i+2), value.Thumbs)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("G%d", i+2), approvelMap[value.Enabled])
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("H%d", i+2), value.CreateDate.Format("2006-01-02 15:04:05"))
	}
	// Save xlsx file by the given path.
	fileName := fmt.Sprintf("./tmp/excel/wishlist_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export wish error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

func (this *WishIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	wish := Wish{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&wish)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&wish, "Id")
	if err1 != nil {
		beego.Error("Delete wish error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

func (this *WishIndexController) Enabled() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	enabled, _ := this.GetInt8("enabled")
	wish := Wish{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&wish)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		msg = "数据不存在，请确认"
		return
	}
	if wish.Enabled == 3 {
		msg = "当前记录已派奖，不能再操作"
		return
	}

	wish.Enabled = enabled
	wish.Modifior = this.LoginAdminId
	_, err1 := wish.Update("Enabled")
	if err1 != nil {
		beego.Error("Enabled wish error", err1)
		msg = "操作失败"
	} else {
		code = 1
		msg = "操作成功"
	}

}

func (this *WishIndexController) Reward() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	wishId, err := this.GetInt64("wishId")
	if err != nil {
		msg = "愿望ID错误，请刷新后重试"
		return
	}
	giftId, err := this.GetInt64("giftId")
	if err != nil {
		msg = "奖品ID错误，请刷新后重试"
		return
	}
	o := orm.NewOrm()
	wish := Wish{BaseModel: BaseModel{Id: wishId}}
	err = o.Read(&wish)
	if err != nil {
		msg = "愿望获取错误，请刷新后重试"
		return
	}
	if wish.Enabled == 3 {
		msg = "当前记录已派奖，请勿重复操作"
		return
	} else if wish.Enabled != 1 {
		msg = "请先审核通过再派奖"
		return
	}

	gift := Gift{BaseModel: BaseModel{Id: giftId}}
	err = o.Read(&gift)
	if err != nil {
		msg = "奖品获取错误，请刷新后重试"
		return
	}
	wish.Enabled = 3 //  已派奖
	_, err = wish.Update("Enabled")
	if err != nil {
		msg = "派奖失败，请刷新后重试"
		return
	}
	rl := RewardLog{GameId: wish.GameId, Account: wish.Account, GiftId: giftId, GiftName: gift.Name, GiftContent: gift.Content, Delivered: 0}
	rl.Creator = this.LoginAdminId
	rl.Modifior = this.LoginAdminId
	_, err1 := rl.Create()
	if err1 != nil {
		msg = "操作失败"
		beego.Error("Wish reward error", err1)
	} else {
		code = 1
		msg = "操作成功"
	}
}

func (this *WishIndexController) CheckboxDelone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	o := orm.NewOrm()
	string := this.GetString("arr")
	string2 := strings.Split(string, ",")
	num, err := o.QueryTable(new(Wish)).Filter("id__in", string2).Update(orm.Params{
		"Enabled": 1})
	if err != nil {
		beego.Error("批量审核通过失败", err)
		msg = "更新失败"
	}
	code = 1
	msg = fmt.Sprintf("成功审核通过%d条记录", num)
	/*var num int
	for i,v := range string2{
		if v ==""{
			break
		}
		idd, _ := strconv.ParseInt(v, 10, 64)
		apply1 := Apply{BaseModel: BaseModel{Id: idd}}
		num = i
		_, err1 := o.Delete(&apply1, "Id")
		if err1 != nil {
			beego.Error("Delete apply error", err1)
			msg = "删除失败"
		}
	}
	code = 1
	msg = fmt.Sprintf("成功删除%d条记录", num+1)*/
}
