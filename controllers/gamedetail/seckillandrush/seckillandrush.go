package seckillandrush

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"html/template"
	"phage-games-web/models/common"
	"phage-games-web/models/gamedetail/seckillandrush"
	"phage/controllers/sysmanage"
)

type SeckillAndRushIndexController struct {
	sysmanage.BaseController
}

func (this *SeckillAndRushIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *SeckillAndRushIndexController) Get() {

	this.Data["seckillandrush"] = seckillandrush.GetSeckillAndRush()
	this.TplName = "gamedetail/seckillandrush/index.tpl"
}

func (this *SeckillAndRushIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	seckkillrush := seckillandrush.SeckillAndRush{Id: id}
	o := orm.NewOrm()
	err := o.Read(&seckkillrush)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}

	_, err1 := o.Delete(&seckkillrush, "Id")
	if err1 != nil {
		beego.Error("Delete seckillandrush error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type SeckillAndRushAddController struct {
	sysmanage.BaseController
}

func (this *SeckillAndRushAddController) Get() {
	var seckills []common.Game
	var rushs []common.Game
	o := orm.NewOrm()
	o.QueryTable(new(common.Game)).Filter("Deleted", 0).Filter("GameType", "seckill").All(&seckills)
	o.QueryTable(new(common.Game)).Filter("Deleted", 0).Filter("GameType", "rush").All(&rushs)
	this.Data["seckills"] = seckills
	this.Data["rushs"] = rushs
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/seckillandrush/add.tpl"
}

func (this *SeckillAndRushAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	seckill, _ := this.GetInt64("SeckillId")
	rushid, _ := this.GetInt64("RushId")
	seckillandrush := seckillandrush.SeckillAndRush{}
	seckillandrush.SeckillId = seckill
	seckillandrush.RushId = rushid
	_, err := seckillandrush.Create()
	if err != nil {
		msg = "添加失败"
		beego.Error("添加秒杀和换购失败", err)
	} else {
		code = 1
		msg = "添加成功"
	}
}
