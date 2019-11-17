package gift

import (
	. "games-web/models/common"
	. "games-web/models/gift"
	"html/template"
	"phage/controllers/sysmanage"
	. "phage/models"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
)

func validate(gift *Gift) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(gift.Name, "errmsg").Message("名称必填")
	valid.MaxSize(gift.Name, 255, "errmsg").Message("名称最长255个字符")
	valid.Min(gift.Seq, 1, "errmsg").Message("编号必须为1-100的数字")
	valid.Max(gift.Seq, 1000000, "errmsg").Message("编号必须为1-1000000的数字")
	valid.Min(gift.Probability, 0, "errmsg").Message("概率必须为0-100的数字")
	valid.Max(gift.Probability, 1000000, "errmsg").Message("概率必须为0-1000000的数字")
	valid.Min(gift.Quantity, 0, "errmsg").Message("数量必须为0-1000的数字")
	valid.Max(gift.Quantity, 1000000, "errmsg").Message("数量必须为0-1000000的数字")
	valid.MaxSize(gift.Content, 255, "errmsg").Message("礼品内容最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type GiftIndexController struct {
	sysmanage.BaseController
}

func (this *GiftIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *GiftIndexController) Get() {
	beego.Informational("query gift ")
	gId, _ := this.GetInt64("gameId", 0)
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit := 1000 // 单个活动奖品不会很多
	list, total := new(Gift).Paginate(page, limit, gId)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 计算总概率
	var totalProb int
	for _, v := range list {
		if v.Quantity > 0 {
			totalProb = totalProb + v.Probability
		}
	}
	// 返回值
	this.Data["gameList"] = GetGames()
	this.Data["dataList"] = list
	this.Data["totalProb"] = totalProb
	this.Data["lessProb"] = 100 - totalProb
	this.TplName = "gift/gift/index.tpl"
}

func (this *GiftIndexController) Post() {
	gId, _ := this.GetInt64("gameId", 0)

	this.Data["json"] = GetGifts(gId)
	this.ServeJSON()
}

func (this *GiftIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	gift := Gift{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&gift)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&gift, "Id")
	if err1 != nil {
		beego.Error("Delete gift error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type GiftAddController struct {
	sysmanage.BaseController
}

func (this *GiftAddController) Get() {
	this.Data["gameList"] = GetGames()
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gift/gift/add.tpl"
}

func (this *GiftAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gift := Gift{}
	if err := this.ParseForm(&gift); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&gift); hasError {
		msg = errMsg
		return
	}
	gift.Creator = this.LoginAdminId
	gift.Modifior = this.LoginAdminId
	_, err1 := gift.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert gift error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type GiftEditController struct {
	sysmanage.BaseController
}

func (this *GiftEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	gift := Gift{BaseModel: BaseModel{Id: id}}

	err := o.Read(&gift)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("GiftIndexController.get"), 302)
	} else {
		this.Data["gameList"] = GetGames()
		this.Data["data"] = gift
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gift/gift/edit.tpl"
	}
}

func (this *GiftEditController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gift := Gift{}
	if err := this.ParseForm(&gift); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&gift); hasError {
		msg = errMsg
		return
	}
	cols := []string{"GameId", "Seq", "Name", "Probability", "Quantity", "GiftType", "Content", "Photo", "BroadcastFlag"}
	gift.Modifior = this.LoginAdminId
	_, err1 := gift.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("Update gift error", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}
