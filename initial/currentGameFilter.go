package initial

import (
	"strconv"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/context"
)

func InitFilterGame() {
	var adminRouter string = beego.AppConfig.String("adminrouter")
	beego.InsertFilter(adminRouter+"/*", beego.BeforeRouter, FilterGameId)
}

var FilterGameId = func(ctx *context.Context) {
	var gid int64
	strv := ctx.Input.Query("gameId")
	if len(strv) == 0 {
		gid, _ = ctx.Input.Session("currentGameId").(int64)
		ctx.Input.SetParam("gameId", strconv.FormatInt(gid, 10))
	} else {
		gid, _ = strconv.ParseInt(strv, 10, 64)
		ctx.Input.CruSession.Set("currentGameId", gid)
	}

	ctx.Input.SetData("currentGameId", gid)
}
