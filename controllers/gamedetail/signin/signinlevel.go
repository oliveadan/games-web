package signin

import (
	. "games-web/models/common"
	. "games-web/models/gamedetail/signin"
	"games-web/utils"
	"html/template"
	"phage/controllers/sysmanage"
	. "phage/models"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
)

func validate(signinLevel *SigninLevel) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(signinLevel.Name, "errmsg").Message("等级名称必填")
	valid.MaxSize(signinLevel.Name, 255, "errmsg").Message("等级名称最长255个字符")
	valid.Min(signinLevel.MaxForce, signinLevel.MinForce, "errmsg").Message("最大积分必须大于最小积分")
	valid.Min(signinLevel.MaxAmount, signinLevel.MinAmount, "errmsg").Message("最大金额必须大于最小金额")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type SigninLevelIndexController struct {
	sysmanage.BaseController
}

func (this *SigninLevelIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *SigninLevelIndexController) Get() {
	beego.Informational("query signinLevel ")
	gId, _ := this.GetInt64("gameId", 0)

	var searchGid int64
	games := GetGames("signin")
	for _, v := range games {
		if v.Id == gId {
			searchGid = v.Id
		}
	}
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(SigninLevel).Paginate(page, limit, searchGid)
	pagination.SetPaginator(this.Ctx, limit, total)

	gaAttrs := GetGameAttributes(searchGid)

	var attrMap = make(map[string]string)
	for _, v := range gaAttrs {
		attrMap[v.Code] = v.Value
	}

	var gameattributes GameAttribute
	o := orm.NewOrm()
	o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code", "signinimg").One(&gameattributes)

	this.Data["careupimg"] = gameattributes.Value
	this.Data["searchGid"] = searchGid
	this.Data["gameList"] = games
	this.Data["dataList"] = list
	this.Data["attrMap"] = attrMap
	this.TplName = "gamedetail/signin/signinlevel/index.tpl"
}

func (this *SigninLevelIndexController) ModifyAttr() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, err := this.GetInt64("gid", 0)
	if err != nil || gId == 0 {
		msg = "活动获取失败，请重新查询"
		return
	}
	sunit := strings.TrimSpace(this.GetString("unit"))
	carve := strings.TrimSpace(this.GetString("carve"))
	sper, err := this.GetInt64("per", 0)
	if err != nil || sper == 0 {
		msg = "数量必须为大于0的数字"
		return
	}
	models := [3]GameAttribute{
		GameAttribute{GameId: gId,
			Code:  utils.Signinper,
			Value: strconv.FormatInt(sper, 10),
			BaseModel: BaseModel{CreateDate: time.Now(),
				Creator:    this.LoginAdminId,
				ModifyDate: time.Now(),
				Modifior:   this.LoginAdminId,
				Version:    0}},
		GameAttribute{GameId: gId,
			Code:  utils.Signinunit,
			Value: sunit,
			BaseModel: BaseModel{CreateDate: time.Now(),
				Creator:    this.LoginAdminId,
				ModifyDate: time.Now(),
				Modifior:   this.LoginAdminId,
				Version:    0}},
		GameAttribute{GameId: gId,
			Code:  utils.Signincarve,
			Value: carve,
			BaseModel: BaseModel{CreateDate: time.Now(),
				Creator:    this.LoginAdminId,
				ModifyDate: time.Now(),
				Modifior:   this.LoginAdminId,
				Version:    0}}}
	o := orm.NewOrm()
	o.Begin()
	if _, err := o.Delete(&GameAttribute{GameId: gId}, "GameId"); err != nil {
		o.Rollback()
		msg = "修改失败，请刷新后重试"
		return
	}
	if _, err := o.InsertMulti(3, models); err != nil {
		o.Rollback()
		msg = "修改失败，请刷新后重试"
		return
	}
	o.Commit()
	code = 1
	msg = "修改成功"
	return
}

func (this *SigninLevelIndexController) UplodImg() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, err := this.GetInt64("gid", 0)
	imgsrc := this.GetString("imgsrc")
	if err != nil || gId == 0 {
		msg = "活动获取失败，请重新查询"
		return
	}
	//查询活动配置中是否存在签到瓜分图片
	o := orm.NewOrm()
	bool := o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code", "signinimg").Exist()
	if bool {
		_, err := o.QueryTable(new(GameAttribute)).Filter("Code", "signinimg").Update(orm.Params{"Value": imgsrc})
		if err != nil {
			msg = "更新失败"
			return
		}
		code = 1
		msg = "更新成功"
		return
	} else {
		var signinimg GameAttribute
		signinimg.GameId = gId
		signinimg.Code = "signinimg"
		signinimg.Value = imgsrc
		o.Begin()
		if _, err := signinimg.Create(); err != nil {
			beego.Informational("瓜分图片上传失败", err)
			o.Rollback()
			msg = "上传失败，请刷新后重试"
			return
		}
		o.Commit()
		code = 1
		msg = "上传成功"
		return
	}
}

func (this *SigninLevelIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	signinLevel := SigninLevel{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&signinLevel)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&signinLevel, "Id")
	if err1 != nil {
		beego.Error("Delete signinLevel error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type SigninLevelAddController struct {
	sysmanage.BaseController
}

func (this *SigninLevelAddController) Get() {
	this.Data["gameList"] = GetGames("signin")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/signin/signinlevel/add.tpl"
}

func (this *SigninLevelAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	model := SigninLevel{}
	if err := this.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&model); hasError {
		msg = errMsg
		return
	}
	model.Creator = this.LoginAdminId
	model.Modifior = this.LoginAdminId
	_, err1 := model.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert signinLevel error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type SigninLevelEditController struct {
	sysmanage.BaseController
}

func (this *SigninLevelEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	signinLevel := SigninLevel{BaseModel: BaseModel{Id: id}}

	err := o.Read(&signinLevel)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("SigninLevelIndexController.get"), 302)
	} else {
		this.Data["gameList"] = GetGames("signin")
		this.Data["data"] = signinLevel
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/signin/signinlevel/edit.tpl"
	}
}

func (this *SigninLevelEditController) Post() {
	var code int
	var msg string
	var url string = beego.URLFor("SigninLevelIndexController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	model := SigninLevel{}
	if err := this.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&model); hasError {
		msg = errMsg
		return
	}
	cols := []string{"Level", "Name", "MinForce", "MaxForce", "MinAmount", "MaxAmount"}
	model.Modifior = this.LoginAdminId
	_, err := model.Update(cols...)
	if err != nil {
		msg = "更新失败"
		beego.Error("Update signinLevel error", err)
	} else {
		code = 1
		msg = "更新成功"
	}
}
