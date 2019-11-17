package guaguaapi

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage/utils"
)

type GuaGuaApiController struct {
	beego.Controller
}

func (this *GuaGuaApiController) Prepare() {
	this.EnableXSRF = false
}

//首页
func (this *GuaGuaApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	var account string
	if accountSes := this.GetSession("frontloginaccount"); accountSes != nil {
		account = accountSes.(string)
	}
	//通用数据
	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)
	this.Data["rlList1"] = this.Data["rlList"]
	o := orm.NewOrm()
	//会员账号不为空时，取会员数据
	var lotteryNums int
	if account != "" {
		var ml MemberLottery
		err := o.QueryTable(new(MemberLottery)).Filter("Gameid", gId).Filter("Account", account).One(&ml, "LotteryNums")
		if err == nil {
			lotteryNums = ml.LotteryNums
		}
	}
	this.Data["loginAccount"] = account
	this.Data["lotteryNums"] = lotteryNums
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/guagua/index-wap.tpl"
	} else {
		this.TplName = "front/guagua/index-pc.tpl"
	}
}
