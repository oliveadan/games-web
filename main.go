package main

import (
	"html/template"
	"net/http"
	_ "phage-games-web/initial"
	_ "phage-games-web/routers"

	"github.com/astaxie/beego"
)

func main() {
	beego.BConfig.WebConfig.EnableXSRF = true
	beego.BConfig.WebConfig.XSRFKey = "gr2ETbKXhAGaYdee5bEmGeJJWgYh7DQnp2XdTP1d"
	beego.BConfig.WebConfig.XSRFExpire = 3600
	beego.ErrorHandler("404", page_not_found)
	beego.ErrorHandler("401", page_note_permission)
	beego.SetStaticPath("/upload", "upload")
	beego.Run()
}

func page_not_found(rw http.ResponseWriter, r *http.Request) {
	t, _ := template.New("404.tpl").ParseFiles("views/404.tpl")
	data := make(map[string]interface{})
	//data["content"] = "page not found"
	t.Execute(rw, data)
}

func page_note_permission(rw http.ResponseWriter, r *http.Request) {
	t, _ := template.New("401.tpl").ParseFiles("views/401.tpl")
	data := make(map[string]interface{})
	t.Execute(rw, data)
}
