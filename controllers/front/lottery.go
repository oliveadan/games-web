package front

import (
	. "games-web/models/common"
	. "games-web/models/gift"
	. "games-web/models/rewardlog"
	utils2 "games-web/utils"
	"github.com/astaxie/beego/logs"
	. "phage/models"
	"phage/utils"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type LotteryController struct {
	beego.Controller
}

func (this *LotteryController) Prepare() {
	this.EnableXSRF = false
}

// 参数gid、account; gid 和 account 必须
// 返回json格式, {"code":1, "msg": "中奖", "data": {"seq":"1","gift": "xxx", "photo": "photo.jpg"}}
// code 0: 系统错误, 1: 中奖, 2: 未中奖
func (this *LotteryController) Lottery() {
	var code int
	var msg string
	var data = map[string]string{"seq": "0", "gift": "", "photo": ""}
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
			// 未中奖的情况，减掉会员的抽奖次数，并且增加一条未中奖的记录
			o := orm.NewOrm()
			o.Begin()
			num, err := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Filter("LotteryNums__gt", 0).Update(orm.Params{
				"LotteryNums": orm.ColValue(orm.ColMinus, 1),
			})
			if num < 1 || err != nil {
				beego.Error("Lotterycontroller error", err)
				code = 0
				if num < 1 {
					o.Commit()
					msg = "抽奖机会已用完"
				} else {
					o.Rollback()
					msg = "操作失败，请刷新后重试"
				}
				return
			} else {
				// 抽奖记录中添加一条记录
				rl := RewardLog{
					BaseModel:     BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
					GameId:        gId,
					Account:       account,
					GiftId:        0,
					GiftName:      "未中奖",
					GiftContent:   "",
					Delivered:     1,
					DeliveredTime: time.Now()}
				_, err = o.Insert(&rl)
				if err != nil {
					beego.Error("Lotterycontroller error 2", err)
					o.Rollback()
					code = 0
					msg = "操作失败，请刷新后重试"
					return
				}
				o.Commit()
			}
			// 老虎机的情况，未中奖时还要取一个不中奖的随机数
			if gameType == "tiger" {
				data["seq"] = getTigerSeq(gId)
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
	gameType = game.GameType
	//验证活动是否在允许使用抽奖接口
	al := utils2.GetAllowLottery()
	if _, ok := al[gameType]; ok != true {
		beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
		msg = "违法使用接口，警告一次！"
		return
	}
	// 活动验证，会员验证
	var ok bool
	if ok, msg = CheckGame(gId, account); !ok {
		return
	}
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
			if code, msg = UpdateLotteryResult(gId, account, &gift, am.Id); code != 0 {
				if gift.Content != "" {
					data["gift"] = gift.Content
				} else {
					data["gift"] = gift.Name
				}
				data["photo"] = gift.Photo
				data["seq"] = strconv.FormatInt(int64(gift.Seq), 10)
				isNeedBroadcast = gift.BroadcastFlag
				return
			}
		}
	}

	// 非内定的情况
	var giftList []Gift
	qs = o.QueryTable(new(Gift))
	cond := orm.NewCondition()
	cond = cond.AndCond(cond.AndCond(cond.And("Probability__gt", 0).And("Quantity__gt", 0)).Or("GiftType", 0))
	cond = cond.And("GameId", gId)
	qs = qs.SetCond(cond)
	// 按礼物类型降序，目的是为了防止设置了多个未中奖的情况，让未中奖的排在最后，选出随机数后，判断区间的时候不会重复计算
	// 按概率降序，目的是判断区间的时候尽快判断出所在区间
	qs = qs.OrderBy("-GiftType", "-Probability", "Id")
	nums, err := qs.All(&giftList, "Id", "Seq", "Name", "Probability", "Quantity", "GiftType", "Content", "Photo", "BroadcastFlag")
	if err != nil {
		beego.Error("Lotterycontroller error", err)
		msg = "活动获取错误，请刷新后重试(4)"
		return
	}
	// 没有奖品了，默认为未中奖
	if nums <= 0 {
		code = 2
		msg = "谢谢参与，再接再厉"
		return
	}
	var total int
	for _, v := range giftList {
		total = total + v.Probability
	}
	// 当概率小于100时，做一个概率调整，增加未中奖的概率，使总和达到100
	if total < 100 {
		total = 100
	}
	rand := utils.RandNum(1, total)
	total = 0 // 重置为0，用于第二次统计
	for _, v := range giftList {
		total = total + v.Probability
		if rand > total {
			continue
		}
		if code, msg = UpdateLotteryResult(gId, account, &v, 0); code != 0 {
			if v.Content != "" {
				data["gift"] = v.Content
			} else {
				data["gift"] = v.Name
			}
			data["photo"] = v.Photo
			data["seq"] = strconv.FormatInt(int64(v.Seq), 10)
			isNeedBroadcast = v.BroadcastFlag
		}
		return
	}
	// 不在区间内，则表示未中奖
	code = 2
	msg = "谢谢参与，再接再厉"
	return
}

func UpdateLotteryResult(gId int64, account string, gift *Gift, amId int64) (code int, msg string) {
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
		beego.Info("Lottery assign member!")
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

// gId必填，account必填，当account="-1"时，不进行会员账号校验
func CheckGame(gId int64, account string) (ok bool, msg string) {

	// 参数基本校验
	if gId == 0 {
		msg = "活动获取错误，请刷新后重试(1)"
		return
	}
	if account == "" {
		msg = "会员账号不能为空"
		return
	}

	o := orm.NewOrm()
	// 会员验证
	if account != "-1" {
		exist := o.QueryTable(new(Member)).Filter("Account", account).Exist()
		if !exist {
			msg = "会员账号不存在，请联系客服确认"
			return
		}
		exist = o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Filter("LotteryNums__gt", 0).Exist()
		if !exist {
			msg = "您没有活动参与资格或者已经参与过了哦！"
			return
		}
	}
	// 活动情况校验
	var game = Game{BaseModel: BaseModel{Id: gId}}
	err := o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "Deleted", "Enabled", "StartTime", "EndTime")
	if err != nil {
		beego.Error("Lotterycontroller error", err)
		msg = "活动获取错误，请刷新后重试(2)"
		return
	}
	if game.Deleted != 0 || game.Enabled != 1 {
		msg = "活动已停止"
		return
	}
	if game.StartTime.After(time.Now()) {
		msg = "活动还未开始"
		return
	}
	if game.EndTime.Before(time.Now()) {
		msg = "活动已结束"
		return
	}
	var periodList []GamePeriod
	nums, err := o.QueryTable(new(GamePeriod)).Filter("GameId", gId).All(&periodList, "StartTime", "EndTime")
	if err != nil {
		beego.Error("Lotterycontroller error", err)
		msg = "活动获取错误，请刷新后重试(3)"
		return
	}
	if nums > 0 {
		var isInPeriod bool
		for _, v := range periodList {
			start, err := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+v.StartTime)
			if err != nil {
				continue
			}
			end, err := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02")+" "+v.EndTime)
			if err != nil {
				continue
			}
			now, _ := time.Parse("2006-01-02 15:04:05", time.Now().Format("2006-01-02 15:04:05"))
			if now.After(start) && now.Before(end) {
				isInPeriod = true
				break
			}
		}
		if !isInPeriod {
			msg = "本时段活动已结束，请关注下一时段"
			return
		}
	}
	ok = true
	return
}

// 老虎机未中奖的情况，随机出一个不中奖的3位数
func getTigerSeq(gId int64) string {
	var list []Gift
	o := orm.NewOrm()
	if _, err := o.QueryTable(new(Gift)).Filter("GameId", gId).All(&list, "Seq"); err != nil {
		return "492"
	}
	rand := getTigerRand(&list)
	return strconv.FormatInt(int64(rand), 10)
}

// 递归
func getTigerRand(list *[]Gift) int {
	rand := utils.RandNum(0, 999)
	for _, v := range *list {
		if rand == v.Seq {
			getTigerRand(list)
		}
	}
	return rand
}

// 参数：gid(活动ID), account(会员账号), page(第几页，默认1), pagesize(每页几条，默认5)
// 返回: code, msg, data{total:0, list: []map}
// code=0系统错误，code=1查询成功
// total 总记录数
// list 奖品列表 包含会员账号account，奖品内容gift，是否派奖delivered，奖品图片，中奖时间createDate
func (this *LotteryController) LotteryQuery() {
	var code int
	var msg string
	var data = make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	var page int
	if page, err = this.GetInt("page", 1); err != nil {
		page = 1
	}
	var limit int
	if limit, err = this.GetInt("pagesize", 5); err != nil {
		limit = 5
	}

	// 验证
	if err != nil {
		msg = "活动获取失败，请刷新后重试(1)"
		return
	}
	if account == "" {
		msg = "会员账号不能不为空"
		return
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(RewardLog))
	qs = qs.Filter("GameId", gId).Filter("Account", account)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	var rlList []RewardLog
	var list = make([]map[string]string, 0)
	if _, err = qs.All(&rlList, "Account", "GiftContent", "GiftName", "Delivered", "CreateDate"); err != nil {
		msg = "查询失败，请刷新后重试(2)"
		return
	}
	var gift string
	for _, v := range rlList {
		if v.GiftContent == "" {
			gift = v.GiftName
		} else {
			gift = v.GiftContent + " - " + v.GiftName
		}

		list = append(list, map[string]string{
			"account":    v.Account,
			"gift":       gift,
			"delivered":  strconv.FormatInt(int64(v.Delivered), 10),
			"createDate": v.CreateDate.Format("2006-01-02 15:04")})
	}
	var total int64
	if total, err = qs.Count(); err != nil {
		msg = "查询失败，请刷新后重试(3)"
		return
	}
	data["total"] = total
	data["list"] = list
	code = 1
	msg = "查询成功"
}

//参数:活动ID，会员登录ip，会员账号
//限制登录
func IpLimit(gid int64, ip string, account string) (string, error) {
	o := orm.NewOrm()
	var msg string
	ill := IpLimitLog{GameId: gid, Ip: ip, Account: account}
	_, i, err := ill.ReadOrCreate("Ip")
	if err != nil {
		logs.Error("ReadOrCreate iplimitlog error", err)
		msg = "系统异常,请刷新后重试(10)"
		return msg, err
	}
	if i > 0 {
		var ill1 IpLimitLog
		err := o.QueryTable(new(IpLimitLog)).Filter("GameId", gid).Filter("Ip", ip).One(&ill1)
		if err != nil {
			logs.Error("query IpLimitLog error", err)
			msg = "系统异常,请刷新后重试(10)"
			return msg, err
		}
		if ill.Account != account {
			msg = "一个IP只能登录一个会员账号"
			return msg, nil
		}
	}
	return "", nil
}
