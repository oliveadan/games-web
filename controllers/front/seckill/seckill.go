package seckill

import (
	"games-web/controllers/front"
	. "games-web/models/common"
	gift2 "games-web/models/gift"
	. "games-web/models/rewardlog"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/models"
	. "phage/utils"

	seckillandrush2 "games-web/models/gamedetail/seckillandrush"
	"strconv"
	"time"
)

type SeckillApiController struct {
	beego.Controller
}

func (this *SeckillApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *SeckillApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	front.SetGameData(&this.Controller, &gId)
	rlList := front.SetRewardList(&this.Controller, &gId)
	this.Data["rlList"] = rlList[:len(rlList)/2]
	this.Data["rlList1"] = rlList[len(rlList)/2:]
	o := orm.NewOrm()
	var periodList []GamePeriod
	_, err := o.QueryTable(new(GamePeriod)).Filter("GameId", gId).OrderBy("StartTime").All(&periodList, "StartTime", "EndTime")
	if err != nil {
		beego.Error("获取秒杀时间段失败", err)
	}

	var giftlist []gift2.Gift
	_, err1 := o.QueryTable(new(gift2.Gift)).Filter("GameId", gId).OrderBy("Seq").All(&giftlist)
	if err1 != nil {
		beego.Error("获取秒杀礼物失败", err)
	}
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.Data["ismobile"] = 1
	} else {
		this.Data["ismobile"] = 0
	}
	//每日抢购
	//获取绑定的抢购活动id
	var seckillandrush seckillandrush2.SeckillAndRush
	err3 := o.QueryTable(new(seckillandrush2.SeckillAndRush)).Filter("SeckillId", gId).One(&seckillandrush)
	if err3 != nil {
		beego.Error("获取绑定信息失败")
	}
	var gifts []gift2.Gift
	num, err2 := o.QueryTable(new(gift2.Gift)).Filter("GameId", seckillandrush.RushId).Filter("seq__in", 1, 2, 3, 4).All(&gifts)
	if err2 != nil {
		beego.Error("获取抢购礼物失败")
	}
	if num == 0 {
		this.Data["realpersong"] = 0
		this.Data["tiger"] = 0
		this.Data["sport"] = 0
		this.Data["lottery"] = 0
	} else {
		for _, v := range gifts {
			switch v.Seq {
			case 1:
				this.Data["realpersong"] = v.Id
			case 2:
				this.Data["tiger"] = v.Id
			case 3:
				this.Data["sport"] = v.Id
			case 4:
				this.Data["lottery"] = v.Id
			}
		}
	}
	this.Data["giftList"] = giftlist
	this.Data["periodList"] = periodList
	this.Data["rushId"] = seckillandrush.RushId
	this.TplName = "front/seckill/index.tpl"
}

func (this *SeckillApiController) Post() {
	var code int
	var msg string
	var data = map[string]string{"seq": "0", "gift": "", "photo": ""}
	defer front.Retjson(this.Ctx, &msg, &code, &data)
	account := this.GetString("account")
	gid, _ := this.GetInt64("gid")
	rushid, _ := this.GetInt64("rushid")
	status, _ := this.GetInt64("status")
	distinction, _ := this.GetInt64("distinction")
	everydayid, _ := this.GetInt64("everydayid")
	index, _ := this.GetInt("index")
	o := orm.NewOrm()
	//抢购
	if distinction == 2 {
		var game Game
		err4 := o.QueryTable(new(Game)).Filter("Id", rushid).One(&game)
		//验证接口
		if game.GameType != "rush" {
			beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
			msg = "违法使用接口，警告一次！"
			return
		}
		if err4 != nil {
			beego.Error("获取活动信息失败", err4)
		}
		if game.StartTime.Unix() > time.Now().Unix() {
			code = 0
			msg = "活动尚未开始"
			return
		}
		if game.EndTime.Unix() < time.Now().Unix() {
			code = 0
			msg = "活动已经结束"
			return
		}
		//查询会员的抢购的次数
		var memberlottery MemberLottery
		err1 := o.QueryTable(new(MemberLottery)).Filter("GameId", rushid).Filter("Account", account).One(&memberlottery)
		if err1 != nil {
			msg = "您的抽奖次数已经用完了~~~~"
			return
		}
		if memberlottery.LotteryNums < 1 {
			code = 0
			msg = "您的抽奖次数已经用完了~~~"
			return
		}
		//查询礼品
		var gift gift2.Gift
		err := o.QueryTable(new(gift2.Gift)).Filter("id", everydayid).One(&gift)
		if err != nil {
			beego.Error("获取每日抢购礼物失败", err)
		}
		if gift.Quantity < 1 {
			code = 0
			msg = "奖品已经没有了，请关注下一期~~"
			return
			return
		} else {
			o.Begin()
			//生成中奖记录
			rl := RewardLog{
				BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
				GameId:      rushid,
				Account:     account,
				GiftId:      gift.Id,
				GiftName:    gift.Name,
				GiftContent: gift.Content,
				Delivered:   0}
			_, err1 := o.Insert(&rl)
			//减掉奖品数据
			_, err1 = o.QueryTable(new(gift2.Gift)).Filter("id", everydayid).Update(orm.Params{
				"Quantity": orm.ColValue(orm.ColMinus, 1),
			})
			if err1 != nil {
				beego.Error("每日抢购中奖记录生成失败", err1)
				o.Rollback()
			}
			// 减掉会员的抽奖次数
			num, err := o.QueryTable(new(MemberLottery)).Filter("GameId", rushid).Filter("Account", account).Filter("LotteryNums__gt", 0).Update(orm.Params{
				"LotteryNums": orm.ColValue(orm.ColMinus, 1),
			})
			if num < 1 || err != nil {
				beego.Error("Lotterycontroller error", err)
				o.Rollback()
				code = 0
				if num < 1 {
					msg = "抽奖机会已用完"
				} else {
					msg = "操作失败，请刷新后重试"
				}
				return
			}
			o.Commit()
			if gift.Content != "" {
				data["gift"] = gift.Content
			} else {
				data["gift"] = gift.Name
			}
			data["photo"] = gift.Photo
			data["seq"] = strconv.FormatInt(int64(gift.Seq), 10)
			code = 1
			msg = "恭喜您成功秒杀到"
			return
		}
	}
	//秒杀
	//如果活动进行中生成投资记录
	if status == 3 {
		var game Game
		if err := o.QueryTable(new(Game)).Filter("Id", gid).One(&game, "GameType"); err != nil {
			msg = "活动获取失败，请刷新后重试！"
			return
		}
		if game.GameType != "seckill" {
			beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
			msg = "违法使用接口，警告一次！"
			return
		}
		//验证时间段
		var periodList []GamePeriod
		nums, err5 := o.QueryTable(new(GamePeriod)).Filter("GameId", gid).OrderBy("StartTime").All(&periodList, "StartTime", "EndTime")
		if err5 != nil || nums == 0 {
			beego.Error("获取配置时间段失败", err5)
			code = 0
			msg = "活动获取错误，请刷新后重试（3）"
			return
		} else if nums > 0 {
			for i, v := range periodList {
				if i == index {
					start, _ := time.ParseInLocation("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+v.StartTime, time.Local)
					end, _ := time.ParseInLocation("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+v.EndTime, time.Local)
					if start.After(time.Now()) {
						code = 0
						msg = "请选择进行中的时间段进行秒杀"
						return
					}
					if end.Before(time.Now()) {
						code = 0
						msg = "请选择进行中的时间段进行秒杀"
						return
					}
				}
			}
		}
		//查询礼品
		var gift gift2.Gift
		err := o.QueryTable(new(gift2.Gift)).Filter("id", everydayid).One(&gift)
		if err != nil {
			beego.Error("获取秒杀礼物失败", err)
		}
		if gift.Quantity <= 0 {
			code = 0
			msg = "奖品已经没有了哦~"
			return
		}
		o.Begin()
		//生成中奖记录
		rl := RewardLog{
			BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
			GameId:      gid,
			Account:     account,
			GiftId:      gift.Id,
			GiftName:    gift.Name,
			GiftContent: gift.Content,
			Delivered:   0}
		_, err1 := o.Insert(&rl)
		//减掉奖品数量
		_, err1 = o.QueryTable(new(gift2.Gift)).Filter("id", everydayid).Update(orm.Params{
			"Quantity": orm.ColValue(orm.ColMinus, 1),
		})
		if err1 != nil {
			beego.Error("秒杀中奖记录生成失败", err1)
			o.Rollback()
		}
		// 减掉会员的抽奖次数
		num, err := o.QueryTable(new(MemberLottery)).Filter("GameId", gid).Filter("Account", account).Filter("LotteryNums__gt", 0).Update(orm.Params{
			"LotteryNums": orm.ColValue(orm.ColMinus, 1),
		})
		if num < 1 || err != nil {
			beego.Error("Lotterycontroller error", err)
			o.Rollback()
			code = 0
			if num < 1 {
				msg = "抽奖机会已用完"
			} else {
				msg = "操作失败，请刷新后重试"
			}
			return
		}
		o.Commit()
		if gift.Content != "" {
			data["gift"] = gift.Content
		} else {
			data["gift"] = gift.Name
		}
		data["photo"] = gift.Photo
		data["seq"] = strconv.FormatInt(int64(gift.Seq), 10)
		code = 1
		msg = "恭喜您成功秒杀到"
		return
	}
	msg = "活动还未开始"
	return
}
