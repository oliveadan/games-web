package redapi

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage/utils"
	"strings"
)

type RedApiController struct {
	beego.Controller
}

func (this *RedApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *RedApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	game := GetGame(gId)
	rlList := SetRewardList(&this.Controller, &gId)
	this.Data["rlList"] = rlList[:len(rlList)/2]
	this.Data["rlList1"] = rlList[len(rlList)/2:]

	version := fmt.Sprintf("%d", game.GameVersion)
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.Data["phone"] = "phone"
		this.TplName = "front/red/index-wap-v" + version + ".tpl"
	} else {
		this.TplName = "front/red/index-pc-v" + version + ".tpl"
	}
}

func (this *RedApiController) Post() {
	var code int
	var msg string
	var data = make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	mobile := strings.TrimSpace(this.GetString("mobilenum"))
	if mobile == "" {
		msg = "手机号不能为空！~~"
		return
	}
	if hasError, errmsg := validate(mobile); hasError {
		msg = errmsg
		return
	}
	// 验证
	if err != nil || gId == 0 {
		msg = "活动获取失败，请刷新后重试(1)"
		return
	}
	if account == "" {
		msg = "会员账号不能为空！~~"
		return
	}
	o := orm.NewOrm()
	if isExists := o.QueryTable(new(Member)).Filter("Account", account).Exist(); !isExists {
		msg = "该账号暂无资格，请您确认活动要求"
		return
	}
	//更新会员手机号
	_, error := o.QueryTable(new(Member)).Filter("Account", account).Update(orm.Params{"Mobile": mobile})
	if error != nil {
		beego.Info("更新会员手机号失败", error)
	}
	if isExist := o.QueryTable(new(Game)).Filter("Id", gId).Exist(); !isExist {
		msg = "活动获取失败，请刷新后重试(2)"
		return
	}

	// -------------------获取会员数据-------------------
	// 剩余次数
	var ml MemberLottery
	err = o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).One(&ml, "LotteryNums")
	//if err == orm.ErrNoRows {
	//	msg = "您还未达标，无法参与"
	//	return
	//} else if err != nil && err != orm.ErrNoRows {
	//	msg = "活动获取失败，请刷新后重试(3)"
	//	return
	//}
	this.SetSession("frontloginaccount", account)
	data["lotteryNums"] = ml.LotteryNums
	code = 1
	msg = "登录成功"
}

func validate(mobile string) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Mobile(mobile, "errmsg").Message("手机号码格式不正确请重新输入")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}
