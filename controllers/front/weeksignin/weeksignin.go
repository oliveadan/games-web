package weeksignin

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gift"
	. "phage-games-web/models/rewardlog"
	"phage-games-web/utils"
	"phage/models"
	"strings"
	"time"
)

type WeekSigninApiController struct {
	beego.Controller
}

func (this *WeekSigninApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *WeekSigninApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	SetGameData(&this.Controller, &gId)
	this.TplName = "front/weeksignin/index.tpl"
}

func (this *WeekSigninApiController) Post() {
	var code int
	var msg string
	var data = make(map[string]string)
	defer Retjson(this.Ctx, &msg, &code, &data)
	gId, err := this.GetInt64("gid", 0)
	if err != nil {
		msg = "活动获取失败，请刷新后重试"
		return
	}
	o := orm.NewOrm()
	account := strings.TrimSpace(this.GetString("account"))
	var game Game
	if err = o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "GameType"); err != nil {
		msg = "活动获取失败，请刷新后重试！"
		return
	}
	if game.GameType != "weeksignin" {
		beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
		msg = "违法使用接口，警告一次！"
		return
	}
	//活动验证，会员不验证
	var ok bool
	if ok, msg = CheckGame(gId, "-1"); !ok {
		return
	}
	var member Member
	if err := o.QueryTable(new(Member)).Filter("Account", account).One(&member); err != nil {
		if err == orm.ErrNoRows {
			msg = "会员账号不存在，请注册后再进行签到！~"
			return
		} else {
			msg = "会员获取失败，请重试"
			return
		}
	}
	//查看今天是星期几，然后匹配相应的礼品
	week := int(time.Now().Weekday())
	//周日是等于0
	if week == 0 {
		week = 7
	}
	end := time.Now().Format("2006-01-02 15:04:05")
	start := member.ModifyDate.Format("2006-01-02 15:04:05")
	//如果会员超过一周没有签到，跳过验证
	diff := utils.GetHourDiffer(start, end)
	if diff < 120 {
		if member.Force == week {
			msg = "您今天已经签到过了，明天再来吧~"
			return
		}
	}
	var gift Gift
	err1 := o.QueryTable(new(Gift)).Filter("GameId", gId).Filter("Seq", week).One(&gift)
	if err1 != nil {
		beego.Error("获取奖品失败", err1)
		msg = "系统异常，请咨询客服人员"
		return
	}
	if gift.Quantity == 0 {
		msg = "今天的奖品已经没有了，明天早点来哦~"
		return
	}
	var rl RewardLog
	rl = RewardLog{
		BaseModel:   models.BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
		GameId:      gId,
		Account:     account,
		GiftId:      gift.Id,
		GiftName:    gift.Name,
		GiftContent: gift.Content,
		Delivered:   0}
	o.Begin()
	_, err3 := o.Insert(&rl)
	if err3 != nil {
		beego.Error("创建中奖记录失败", err3)
		o.Rollback()
		code = 0
		msg = "系统异常(2)，请咨询客服人员"
		return
	}
	o.Commit()
	//更新会员签到时间
	_, err = o.QueryTable(new(Member)).Filter("Account", account).Update(orm.Params{"Force": week, "ModifyDate": time.Now()})
	if err != nil {
		beego.Error("更新会员签到时间失败", err)
		msg = "签到异常，请重试（3）"
		return
	}
	//奖品抽中减掉一个数量
	_, _ = o.QueryTable(new(Gift)).Filter("Id", gift.Id).Update(orm.Params{
		"Quantity": orm.ColValue(orm.ColMinus, 1),
	})
	data["gift"] = gift.Content
	msg = "签到成功"
	code = 1
}
