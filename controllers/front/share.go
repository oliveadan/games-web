package front

import (
	"encoding/base64"
	"fmt"
	. "games-web/models/common"
	"net/http"
	"net/url"
	"phage/utils"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context"
	"github.com/astaxie/beego/orm"
)

type ShareController struct {
	beego.Controller
}

func (this *ShareController) Prepare() {
	this.EnableXSRF = false
}

// 点击分享链接进入
func (this *ShareController) Get() {
	ua := this.Ctx.Input.UserAgent()
	if strings.Contains(ua, "MicroMessenger") {
		this.Data["isWap"] = utils.IsWap(ua)
		this.TplName = "front/tencent.tpl"
		return
	} else if strings.Contains(ua, "QQ/") && utils.IsWap(ua) {
		this.Data["isWap"] = true
		this.TplName = "front/tencent.tpl"
		return
	}
	redi := this.GetString("redirect")
	shareId := this.GetString("id")
	if shareId != "" {
		this.SetSession("frontshareout", shareId)
	}
	if redi == "" {
		this.Redirect(this.URLFor("DoorController.Get"), http.StatusFound)
		return
	}
	urlStr, err := url.QueryUnescape(redi)
	if err != nil {
		this.Redirect(this.URLFor("DoorController.Get"), http.StatusFound)
		return
	}
	this.Redirect(urlStr, http.StatusFound)
}

// 生成分享链接
func (this *ShareController) Post() {
	var code int
	var msg string
	var data = map[string]string{"tips": "参与活动，抽大奖！", "redirect": "", "qrcode": ""}
	defer Retjson(this.Ctx, &msg, &code, &data)
	gId, _ := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	account = utils.RandString(5) + base64.URLEncoding.EncodeToString([]byte(account))
	var redi string
	var game Game
	o := orm.NewOrm()
	err := o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "Id", "GameType", "Announcement")
	if err == nil && game.GameType != "" {
		redi = fmt.Sprintf("/%s?gid=%d", game.GameType, game.Id)
		data["tips"] = game.Announcement
	} else {
		redi = this.URLFor("DoorController.Get")
	}
	redi = this.Ctx.Input.Site() + this.URLFor("ShareController.Get", "redirect", url.QueryEscape(redi), "id", account)
	data["redirect"] = redi
	data["qrcode"], _ = utils.GenerateQrcode(&redi)
	code = 1
}

func ShareDetailGenerate(ctx *context.Context, gId int64, shareUse string) {
	shareOut := ctx.Input.Session("frontshareout")
	if shareOut == nil {
		return
	}

	var sharer = utils.SubString(shareOut.(string), 5, 0)
	if b, err := base64.URLEncoding.DecodeString(sharer); err != nil {
		return
	} else {
		sharer = string(b)
	}
	sd := ShareDetail{}
	sd.CreateDate = time.Now()
	sd.ModifyDate = time.Now()
	sd.Creator = 0
	sd.Modifior = 0
	sd.Version = 0
	sd.GameId = gId
	sd.ShareOut = sharer
	sd.ShareUse = shareUse
	sd.Ip = ctx.Input.IP()
	o := orm.NewOrm()
	if o.QueryTable(new(ShareDetail)).Filter("GameId", sd.GameId).Filter("ShareUse", sd.ShareUse).Exist() {
		return
	}
	if o.QueryTable(new(ShareDetail)).Filter("GameId", sd.GameId).Filter("Ip", sd.Ip).Exist() {
		return
	}
	o.Insert(&sd)
}
