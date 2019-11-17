package game

import (
	"html/template"
	. "phage-games-web/models/common"
	"phage/controllers/sysmanage"
	. "phage/models"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
	"phage-games-web/utils"
)

func validate(game *Game) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(game.Name, "errmsg").Message("名称必填")
	valid.MaxSize(game.Name, 255, "errmsg").Message("名称最长255个字符")
	valid.MaxSize(game.Description, 255, "errmsg").Message("描述最长255个字符")
	valid.Required(game.StartTime, "errmsg").Message("开始时间必填")
	valid.Required(game.EndTime, "errmsg").Message("结束时间必填")
	valid.MaxSize(game.Announcement, 1024, "errmsg").Message("公告最长1024个字符")
	valid.MaxSize(game.BindDomain, 255, "errmsg").Message("公告最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type GameIndexController struct {
	sysmanage.BaseController
}

func (this *GameIndexController) Get() {
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	gametype := this.GetString("gameType")
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(Game).Paginate(page, limit, gametype)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["gameType"] = gametype
	this.Data["dataList"] = list
	this.TplName = "common/game/index.tpl"
}

func (this *GameIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	game := Game{BaseModel: BaseModel{Id: id}, Deleted: 0}
	o := orm.NewOrm()
	err := o.Read(&game)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	game.Deleted = 1
	_, err1 := game.Update("Deleted")
	if err1 != nil {
		beego.Error("Delete game error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

func (this *GameIndexController) Enabled() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	game := Game{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&game)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		msg = "数据不存在，请确认"
		return
	}
	if game.Enabled == 0 {
		game.Enabled = 1
	} else {
		game.Enabled = 0
	}
	game.Modifior = this.LoginAdminId
	_, err1 := game.Update("Enabled")
	if err1 != nil {
		beego.Error("Enabled game error", err1)
		msg = "操作失败"
	} else {
		code = 1
		msg = "操作成功"
	}

}

type GameAddController struct {
	sysmanage.BaseController
}

func (this *GameAddController) Get() {
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "common/game/add.tpl"
}

func (this *GameAddController) Post() {
	var code int
	var msg string
	var url = beego.URLFor("GameIndexController.Get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	game := Game{}
	if err := this.ParseForm(&game); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&game); hasError {
		msg = errMsg
		return
	}
	game.BindDomain = strings.TrimSpace(game.BindDomain)
	game.Deleted = 0
	game.Creator = this.LoginAdminId
	game.Modifior = this.LoginAdminId
	_, err1 := game.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert game error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type GameEditController struct {
	sysmanage.BaseController
}

func (this *GameEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	game := Game{BaseModel: BaseModel{Id: id}}

	err := o.Read(&game)
	maps := utils.GetGameVersion()
	gameversions := maps[game.GameType]

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("GameIndexController.get"), 302)
	} else {
		//version := fmt.Sprintf("%d",game.Version-1)
		this.Data["data"] = game
		this.Data["version"] = game.GameVersion - 1
		this.Data["gameversions"] = gameversions
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "common/game/edit.tpl"
	}
}

func (this *GameEditController) Post() {
	var code int
	var msg string
	var url = beego.URLFor("GameIndexController.Get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	game := Game{}
	if err := this.ParseForm(&game); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&game); hasError {
		msg = errMsg
		return
	}
	game.BindDomain = strings.TrimSpace(game.BindDomain)
	cols := []string{"Name", "Description", "StartTime", "EndTime", "Announcement", "BindDomain", "GameType", "GameRule", "GameStatement", "GameVersion"}
	game.Modifior = this.LoginAdminId
	_, err1 := game.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("Update game error", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}
