package luckyfree

import (
	. "games-web/controllers/front"
	. "games-web/models/common"
	gift2 "games-web/models/gift"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/utils"
)

type LuckyFreeApiController struct {
	beego.Controller
}

func (this *LuckyFreeApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *LuckyFreeApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	var account string
	if accountSes := this.GetSession("frontloginaccount"); accountSes != nil {
		account = accountSes.(string)
	}
	//通用数据
	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)
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
	//获取奖品图片
	var gifts []gift2.Gift
	_, err1 := o.QueryTable(new(gift2.Gift)).Filter("Gameid", gId).OrderBy("Seq").All(&gifts)
	if err1 != nil {
		beego.Error("查询奖品列表失败", err1)
	}
	if len(gifts) == 0 {
		this.Data["gifts1"] = gifts
		this.Data["gifts2"] = gifts
	} else {
		this.Data["gifts1"] = gifts[0:5]
		this.Data["gifts2"] = gifts[5:10]
	}
	this.Data["loginAccount"] = account
	this.Data["lotteryNums"] = lotteryNums
	this.Data["rlList1"] = this.Data["rlList"]

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/luckyfree/index-wap.tpl"
	} else {
		this.TplName = "front/luckyfree/index-pc.tpl"
	}
}
