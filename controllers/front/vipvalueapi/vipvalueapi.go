package vipvalueapi

import (
	. "games-web/controllers/front"
	"games-web/models/gamedetail/vipvalue"
	. "games-web/models/rewardlog"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"phage/controllers/sysmanage"
	. "phage/models"
	"strings"
	"time"
)

type VipValueApiController struct {
	beego.Controller
}

func (this *VipValueApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *VipValueApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	SetGameData(&this.Controller, &gId)
	this.TplName = "front/vipvalue/index.tpl"
}

func (this *VipValueApiController) Post() {
	var code int
	var msg string
	data := make(map[string]interface{})
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &data)
	account := strings.TrimSpace(this.GetString("account"))
	gid, _ := this.GetInt64("gid")
	ok, s := CheckGame(gid, "-1")
	if !ok {
		msg = s
		return
	}

	o := orm.NewOrm()
	var vv vipvalue.VipValue
	one := o.QueryTable(new(vipvalue.VipValue)).Filter("Account", account).One(&vv)
	if one != nil {
		beego.Error("query VipValue error", one)
		msg = "会员账号不存在"
		return
	}
	//判断会员是否已经领取奖励
	if vv.GetEnable == 0 {
		//生成一条中奖记录
		rl := RewardLog{
			BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
			Account:     account,
			GameId:      gid,
			GiftId:      vv.Id,
			GiftName:    "VIP账号价值",
			GiftContent: vv.Value,
			Delivered:   0}
		o.Begin()
		_, err := o.Insert(&rl)
		if err != nil {
			beego.Error("vipvalue error ", err)
			o.Rollback()
			code = 0
			msg = "操作失败，请刷新后重试"
			return
		}
		_, err1 := o.QueryTable(new(vipvalue.VipValue)).Filter("Id", vv.Id).Update(orm.Params{"GetEnable": 1})
		if err1 != nil {
			beego.Error("update VIPVALUE getenable error", err1)
			msg = "操作失败，请刷新后重试(2)"
			return
		}
		o.Commit()

	}
	code = 1
	data["VipValue"] = vv
}
