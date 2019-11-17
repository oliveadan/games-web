package initial

import (
	"phage-games-web/utils"

	"github.com/astaxie/beego"
)

var static_front = beego.AppConfig.String("staticfront")

func initTemplateFunc() {
	beego.AddFuncMap("getSiteConfigCodeMap", utils.GetSiteConfigCodeMap)
	beego.AddFuncMap("getGameName", utils.GetGameName)
	beego.AddFuncMap("getApprovelMap", utils.GetApprovelMap)
	beego.AddFuncMap("getGameTypeMap", utils.GetGameTypeMap)
	beego.AddFuncMap("getGameVersion", utils.GetGameVersion)
	beego.AddFuncMap("getQuestionContentTypeMap", utils.GetQuestionContentTypeMap)
	beego.AddFuncMap("getGameVersionDetail", utils.GetGameVersionDetail)
	beego.AddFuncMap("static_front", getStaticFront)
}

func getStaticFront() string {
	return static_front
}
