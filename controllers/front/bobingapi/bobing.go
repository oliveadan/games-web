package bobingapi

import (
	"crypto/rand"
	"math/big"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gift"
	. "phage-games-web/models/rewardlog"
	. "phage/models"
	. "phage/utils"
	"sort"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type BobingFrontController struct {
	beego.Controller
}

func (this *BobingFrontController) Prepare() {
	this.EnableXSRF = false
}

func (this *BobingFrontController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/bobing/index-pc.tpl"
	} else {
		this.TplName = "front/bobing/index-pc.tpl"
	}
}

func (this *BobingFrontController) Post() {
	var code int
	var msg string
	var data = map[string]string{"seq": "0", "gift": "未中奖", "photo": ""}
	defer Retjson(this.Ctx, &msg, &code, &data)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	if err != nil {
		msg = "活动获取失败，请刷新后重试"
		return
	}
	account := strings.TrimSpace(this.GetString("account"))

	var isNeedBroadcast int8
	var gameType string
	defer func() {
		if code == 2 {
			// 未中奖的情况，减掉会员的抽奖次数
			o := orm.NewOrm()
			num, err := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Filter("LotteryNums__gt", 0).Update(orm.Params{
				"LotteryNums": orm.ColValue(orm.ColMinus, 1),
			})
			if num < 1 || err != nil {
				beego.Error("bobing controller error", err)
				code = 0
				if num < 1 {
					msg = "抽奖机会已用完"
				} else {
					msg = "操作失败，请刷新后重试"
				}
				return
			}
		}
		if isNeedBroadcast == 1 {
			Broadcast(account, data["gift"], gameType)
		}
	}()
	o := orm.NewOrm()
	var game Game
	if err = o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "GameType"); err != nil {
		msg = "活动获取失败，请刷新后重试！"
		return
	}
	if game.GameType != "bobing" {
		beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
		msg = "违法使用接口，警告一次！"
		return
	}
	// 活动验证，会员验证
	var ok bool
	if ok, msg = CheckGame(gId, account); !ok {
		return
	}
	gameType = game.GameType
	// -----------开始抽奖--------------
	// 先判断是否内定, 内定成功则返回奖品，否则继续进行随机抽奖
	var am AssignMember
	qs := o.QueryTable(new(AssignMember)).Filter("GameId", gId).Filter("Account", account).Filter("Enabled", 0)
	qs = qs.Limit(1)
	err = qs.One(&am, "Id", "GiftId")
	if err == nil {
		gift := Gift{BaseModel: BaseModel{Id: am.GiftId}}
		err = o.Read(&gift)
		if err == nil {
			if code, msg = updateGift(gId, account, &gift, am.Id); code != 0 {
				data["gift"] = gift.Name + " " + gift.Content
				data["photo"] = gift.Photo
				data["seq"] = strconv.FormatInt(int64(gift.Seq), 10)
				if len(data["seq"]) < 6 {
					data["seq"] = SubString(data["seq"]+"235635", 0, 6)
				}
				isNeedBroadcast = gift.BroadcastFlag
				return
			}
		}
	}
	// -----------开始摇骰子--------------
	// 随机点数
	var dot = make([]string, 0)
	for i := 0; i < 6; i++ {
		if rnd, err := rand.Int(rand.Reader, big.NewInt(6)); err == nil {
			dot = append(dot, rnd.Add(rnd, big.NewInt(1)).String())
		}
	}
	sort.Strings(dot)
	rndStr := strings.Join(dot, "")
	data["seq"] = rndStr

	// 非内定的情况
	var giftList []Gift
	qs = o.QueryTable(new(Gift))
	cond := orm.NewCondition()
	cond = cond.AndCond(cond.AndCond(cond.And("Probability__gt", 0).And("Quantity__gt", 0)).Or("GiftType", 0))
	cond = cond.And("GameId", gId)

	qs = qs.SetCond(cond)
	// 按礼物类型降序，目的是为了防止设置了多个未中奖的情况，让未中奖的排在最后，选出随机数后，判断区间的时候不会重复计算
	// 按概率降序，目的是判断区间的时候尽快判断出所在区间
	qs = qs.OrderBy("-Seq", "-GiftType", "-Probability", "Id")
	nums, err := qs.All(&giftList, "Id", "Seq", "Name", "Probability", "Quantity", "GiftType", "Content", "Photo", "BroadcastFlag")
	if err != nil {
		beego.Error("bobing controller error", err)
		msg = "活动获取错误，请刷新后重试(4)"
		return
	}
	// 没有奖品了，默认为未中奖
	if nums <= 0 {
		code = 2
		msg = "谢谢参与，再接再厉"
		return
	}

	for _, v := range giftList {
		seq := strings.Split(strconv.Itoa(v.Seq), "")
		sort.Strings(seq)
		seqStr := strings.Join(seq, "")
		if strings.Contains(rndStr, seqStr) {
			if v.Probability == 1 {
				var gift Gift
				err := o.QueryTable(new(Gift)).Filter("GameId", gId).Filter("Seq", 1000).One(&gift)
				if err != nil {
					data["seq"] = "123165"
				} else {
					data["seq"] = gift.Content
				}
				code = 2
				return
			}
			if v.Quantity < 1 {
				code = 2
				msg = "您来晚了，奖品已派完"
			} else {
				if code, msg = updateGift(gId, account, &v, 0); code != 0 {
					data["gift"] = v.Name + " " + v.Content
					data["photo"] = v.Photo
					isNeedBroadcast = v.BroadcastFlag
				}
			}
			return
		}
	}
	o.Begin()
	//不中奖的情况生成不中奖记录
	rl := RewardLog{
		BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
		GameId:      gId,
		Account:     account,
		GiftName:    "未中奖",
		GiftContent: "未中奖",
		Delivered:   0}
	_, err = o.Insert(&rl)
	if err != nil {
		beego.Error("Lotterycontroller error", err)
		o.Rollback()
		code = 0
		msg = "操作失败，请刷新后重试"
		return
	}
	o.Commit()
	// 不在区间内，则表示未中奖
	code = 2
	msg = "谢谢参与，再接再厉"
	return
}

func updateGift(gId int64, account string, gift *Gift, amId int64) (code int, msg string) {
	if gift.GiftType == 0 {
		code = 2
		msg = "谢谢参与，再接再厉!"
		return
	}
	// 开启事务
	o := orm.NewOrm()
	err := o.Begin()
	var num int64
	// 抽中则减掉1个奖品
	num, err = o.QueryTable(new(Gift)).Filter("Id", gift.Id).Filter("Quantity__gt", 0).Update(orm.Params{
		"Quantity": orm.ColValue(orm.ColMinus, 1),
	})
	if num != 1 || err != nil {
		beego.Error("Lotterycontroller error", err)
		o.Rollback()
		code = 0
		msg = "操作失败，请刷新后重试"
		return
	}
	// 减掉会员的抽奖次数
	num, err = o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Filter("LotteryNums__gt", 0).Update(orm.Params{
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
	// 抽奖记录中添加一条记录
	rl := RewardLog{
		BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
		GameId:      gId,
		Account:     account,
		GiftId:      gift.Id,
		GiftName:    gift.Name,
		GiftContent: gift.Content,
		Delivered:   0}
	_, err = o.Insert(&rl)
	if err != nil {
		beego.Error("Lotterycontroller error", err)
		o.Rollback()
		code = 0
		msg = "操作失败，请刷新后重试"
		return
	}
	// 内定的情况，更新内定的记录
	if amId != 0 {
		am := AssignMember{BaseModel: BaseModel{Id: amId}, Enabled: 1}
		_, err = o.Update(&am, "Enabled")
		if err != nil {
			beego.Error("Lotterycontroller error", err)
			o.Rollback()
			code = 0
			msg = "操作失败，请刷新后重试"
			return
		}
	}
	o.Commit()
	code = 1
	msg = "恭喜您!"
	return

}
