package richapi

import (
	"fmt"
	"github.com/astaxie/beego/validation"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/rich"
	. "phage-games-web/models/gift"
	. "phage-games-web/models/rewardlog"
	"phage-games-web/utils"
	"phage/controllers/sysmanage"
	. "phage/models"
	. "phage/utils"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type RichApiController struct {
	beego.Controller
	stageStep int
}

func (this *RichApiController) Prepare() {
	this.EnableXSRF = false
	this.stageStep = 30
}

func (this *RichApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	currentStage, _ := this.GetInt("stage", 0)
	var accountStage int = 1
	var account string
	var addlottery bool
	if accountSes := this.GetSession("frontloginaccount"); accountSes != nil {
		account = accountSes.(string)
	}
	// 通用数据
	SetGameData(&this.Controller, &gId)
	o := orm.NewOrm()
	// 会员账号不为空时，取会员数据
	var lotteryNums int
	var stepCount int
	var accountStep int
	if account != "" {
		var rs RichStep
		if err := o.QueryTable(new(RichStep)).Filter("GameId", gId).Filter("Account", account).One(&rs, "StepCount", "LotteryAddtime"); err == nil {
			stepCount = rs.StepCount
			if stepCount > 0 && stepCount%this.stageStep == 0 {
				accountStage = rs.StepCount / this.stageStep
				accountStep = this.stageStep
			} else {
				accountStage = rs.StepCount/this.stageStep + 1
				accountStep = stepCount % this.stageStep
			}
			if currentStage == 0 {
				currentStage = accountStage
			}
		}
		//如果会员在第一关，每天登录可以添加一次抽奖机会
		if currentStage == 0 || currentStage == 1 {
			day := rs.LotteryAddtime.Format("2006-01-02")
			now := time.Now().Format("2006-01-02")
			if day != now {
				//查看会员是否已投资次数
				exist := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Exist()
				if !exist {
					//没有抽奖次数的情况，插入一次抽奖次数
					var rs = MemberLottery{
						BaseModel:   BaseModel{Creator: 0, Modifior: 0, CreateDate: time.Now(), ModifyDate: time.Now(), Version: 0},
						GameId:      gId,
						Account:     account,
						LotteryNums: 1}
					_, _, err := o.ReadOrCreate(&rs, "GameId", "Account")
					if err == nil {
						addlottery = true
					} else {
						beego.Info("插入会员抽奖次数失败", err)
					}
				} else {
					//有抽奖次数的直接添加一次投资次数
					_, err := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Update(orm.Params{"LotteryNums": orm.ColValue(orm.ColAdd, 1)})
					if err != nil {
						beego.Error("会员添加抽奖次数失败", err)
					} else {
						addlottery = true
					}
				}
				//次数添加成功更新添加次数的时候
				if addlottery {
					_, err1 := o.QueryTable(new(RichStep)).Filter("GameId", gId).Filter("Account", account).Update(orm.Params{"LotteryAddtime": time.Now()})
					if err1 != nil {
						beego.Error("更新次数时间错误", err1)
					}
				}
			}
		}
	}
	var ml MemberLottery
	err := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).One(&ml, "LotteryNums")
	if err == nil {
		lotteryNums = ml.LotteryNums
	}
	if currentStage == 0 {
		currentStage = 1
	}
	// 大富翁数据
	var bgArr [2]string
	var totalStage int64
	var gaList []GameAttribute
	qs := o.QueryTable(new(GameAttribute))
	qs = qs.Filter("GameId", gId)
	qs = qs.Filter("Code__in", utils.Richtotalstage, fmt.Sprintf("a%d", currentStage), fmt.Sprintf("b%d", currentStage))
	if _, err := qs.All(&gaList, "Code", "Value"); err != nil {
		totalStage = 1
	} else {
		for _, v := range gaList {
			if v.Code == utils.Richtotalstage {
				totalStage, _ = strconv.ParseInt(v.Value, 10, 0)
			} else if v.Code == fmt.Sprintf("a%d", currentStage) {
				bgArr[0] = v.Value
			} else {
				bgArr[1] = v.Value
			}
		}
	}
	// 奖品
	var giftPhotoMap = make(map[int64]string)
	var giftList []Gift
	if _, err := o.QueryTable(new(Gift)).Filter("GameId", gId).Filter("Quantity__gt", 0).All(&giftList, "Seq", "Content", "Name", "Photo"); err == nil {
		for _, v := range giftList {
			// 返回的礼品序列 - stageStep 乘 (当前阶段-1)
			giftSeq := int64(v.Seq - this.stageStep*(currentStage-1))
			giftPhotoMap[giftSeq] = v.Photo
		}
	}
	// 中奖记录展示
	SetRewardList(&this.Controller, &gId)
	// 已登录的会员、及会员数据
	this.Data["loginAccount"] = account
	this.Data["lotteryNums"] = lotteryNums
	this.Data["stepCount"] = stepCount
	this.Data["accountStage"] = accountStage
	this.Data["accountStep"] = accountStep
	// 活动数据
	this.Data["totalStage"] = int(totalStage)
	this.Data["currentStage"] = currentStage
	this.Data["giftPhotoMap"] = giftPhotoMap
	this.Data["addLottery"] = addlottery
	this.Data["stepArr"] = make([]int, this.stageStep)
	this.Data["bgArr"] = bgArr
	//通过时跳到新页面
	if account != "" {
		if stepCount >= int(totalStage)*this.stageStep {
			this.TplName = "front/rich/last.tpl"
		} else {
			if IsWap(this.Ctx.Input.UserAgent()) {
				this.TplName = "front/rich/index-wap.tpl"
			} else {
				this.TplName = "front/rich/index-pc.tpl"
			}
		}
	} else {
		if IsWap(this.Ctx.Input.UserAgent()) {
			this.TplName = "front/rich/index-wap.tpl"
		} else {
			this.TplName = "front/rich/index-pc.tpl"
		}
	}
}

func (this *RichApiController) Login() {
	var code int
	var msg string
	var data string
	defer Retjson(this.Ctx, &msg, &code, &data)
	// 参数
	gId, err := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	// 验证
	if err != nil {
		msg = "活动获取失败，请刷新后重试(1)"
		return
	}
	if account == "" {
		msg = "会员账号不能为空"
		return
	}
	o := orm.NewOrm()
	if isExists := o.QueryTable(new(Member)).Filter("Account", account).Exist(); !isExists {
		msg = "该账号暂无资格，请您确认活动要求"
		return
	}
	game := Game{BaseModel: BaseModel{Id: gId}}
	if err := o.Read(&game); err != nil {
		msg = "活动获取失败，请刷新后重试(2)"
		return
	}
	if game.StartTime.Unix() > time.Now().Unix() {
		msg = "活动还未开始，敬请关注！"
		return
	}
	if game.EndTime.Unix() < time.Now().Unix() {
		msg = "活动已结束！"
		return
	}

	// -------------------获取会员数据-------------------
	// 剩余次数
	var ml MemberLottery
	err = o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).One(&ml, "LotteryNums")
	if err == orm.ErrNoRows {
		/*msg = "您还未达标，无法参与"
		return*/
	} else if err != nil && err != orm.ErrNoRows {
		msg = "活动获取失败，请刷新后重试(3)"
		return
	}
	// 当前步数
	ts, _ := time.Parse("2006-01-02 15:04:05", "1999-01-01 00:00:00")
	var rs = RichStep{
		BaseModel:      BaseModel{Creator: 0, Modifior: 0, CreateDate: time.Now(), ModifyDate: time.Now(), Version: 0},
		GameId:         gId,
		Account:        account,
		StepCount:      0,
		LastDate:       time.Now(),
		LotteryAddtime: ts}
	_, _, err = o.ReadOrCreate(&rs, "GameId", "Account")
	if err != nil {
		msg = "活动获取失败，请刷新后重试(4)"
		return
	}
	// 计算会员是否长时间未参与活动，如果超过设定时间，则退步
	var gaList []GameAttribute
	if _, err = o.QueryTable(new(GameAttribute)).Filter("GameId", gId).All(&gaList, "Code", "value"); err != nil {
		msg = "活动获取失败，请刷新后重试(5)"
		return
	}
	var unplayday int64
	var backstep int64
	var totalStep int64
	for _, v := range gaList {
		switch v.Code {
		case utils.Richunplayday:
			unplayday, _ = strconv.ParseInt(v.Value, 10, 64)
		case utils.Richbackstep:
			backstep, _ = strconv.ParseInt(v.Value, 10, 64)
		case utils.Richtotalstage:
			totalStage, _ := strconv.ParseInt(v.Value, 10, 64)
			totalStep = totalStage * int64(this.stageStep)
		}
	}
	if unplayday > 0 && backstep > 0 && rs.StepCount > 0 && rs.StepCount < int(totalStep) {
		subT := time.Now().Sub(rs.LastDate)
		if times := (int(subT.Hours()) / 24) / int(unplayday); times >= 1 {
			rs.StepCount = rs.StepCount - int(backstep)*times
			msg = fmt.Sprintf("(由于长时间未参与活动，自动退%d步)", int(backstep)*times)
		}
		if rs.StepCount < 0 {
			rs.StepCount = 0
		}
	}
	rs.LastDate = time.Now()
	if _, err = o.Update(&rs, "StepCount", "LastDate"); err != nil {
		msg = "登录失败，请刷新后重试"
		return
	}
	data = this.URLFor("RichApiController.Get", "gid", gId)
	code = 1
	this.SetSession("frontloginaccount", account)
	msg = fmt.Sprintf("登录成功%s", msg)
}

func (this *RichApiController) Dice() {
	var isNeedBroadcast int8
	var code int
	var msg string
	// 参数
	gId, err := this.GetInt64("gid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	// 验证接口
	o := orm.NewOrm()
	var game Game
	if err = o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "GameType"); err != nil {
		msg = "活动获取失败，请刷新后重试！"
		return
	}
	if game.GameType != "rich" {
		beego.Info("会员账号", account, "IP地址:", this.Ctx.Input.IP(), "违法使用接口")
		msg = "违法使用接口，警告一次！"
		return
	}

	var data = map[string]interface{}{"diceNum": 0, "stage": 1, "stepNum": 0, "gift": "", "photo": ""}
	defer Retjson(this.Ctx, &msg, &code, &data)
	defer func() {
		if isNeedBroadcast == 1 {
			Broadcast(account, data["gift"].(string), "rich")
		}
	}()

	if accountSes := this.GetSession("frontloginaccount"); accountSes == nil || account != accountSes.(string) {
		msg = "登录过期，请重新登录"
		return
	}

	// 验证
	if err != nil {
		msg = "活动获取失败，请刷新后重试(1)"
		return
	}
	// 通用活动验证，会员验证
	var ok bool
	if ok, msg = CheckGame(gId, account); !ok {
		return
	}
	// 验证会员当前步数，如果已经达到最大，则提示已完成。
	rs := RichStep{
		BaseModel: BaseModel{Creator: 0, Modifior: 0, CreateDate: time.Now(), ModifyDate: time.Now(), Version: 0},
		GameId:    gId,
		Account:   account,
		StepCount: 0,
		LastDate:  time.Now()}
	_, _, err = o.ReadOrCreate(&rs, "GameId", "Account")
	if err != nil {
		msg = "获取会员信息失败，请刷新后重试"
		return
	}
	// 获取活动设置的 关卡数 和 点数概率
	var gaList []GameAttribute
	if _, err = o.QueryTable(new(GameAttribute)).Filter("GameId", gId).Filter("Code__in", utils.Richtotalstage, utils.Richrate).All(&gaList, "Code", "Value"); err != nil {
		beego.Error("Richapi dice , query gameattribute errer", err)
		msg = "获取活动失败，请刷新后重试"
		return
	}
	var totalStage64 int64
	var rateStr string
	for _, v := range gaList {
		switch v.Code {
		case utils.Richtotalstage:
			totalStage64, _ = strconv.ParseInt(v.Value, 10, 0)
		case utils.Richrate:
			rateStr = v.Value
		}
	}

	totalStage := int(totalStage64)
	totalStep := totalStage * this.stageStep
	if rs.StepCount >= totalStep {
		msg = "您已到达终点！"
		return
	}
	// 判断是否有内定
	var amList []AssignMember
	_, err = o.QueryTable(new(AssignMember)).Filter("GameId", gId).Filter("Account", account).Filter("Enabled", 0).All(&amList, "Id", "GiftId")
	if err != nil {
		beego.Error("Richapi dice , query AssignMember errer", err)
		msg = "获取活动失败，请刷新后重试"
		return
	}
	var dice int = 6
	var am AssignMember
	var assignGiftId int64
	for _, v := range amList {
		gift := Gift{BaseModel: BaseModel{Id: v.GiftId}}
		if err = o.Read(&gift); err == nil {
			if gift.Seq-rs.StepCount >= 1 && gift.Seq-rs.StepCount <= dice {
				dice = gift.Seq - rs.StepCount
				am = v
				assignGiftId = gift.Id
			}
		}
	}
	// 没有内定则按概率
	if assignGiftId == 0 {
		rates := strings.Split(rateStr, ",")
		rateMap := make(map[int]int)
		totalRate := 0
		for i, v := range rates {
			rate64, _ := strconv.ParseInt(v, 10, 0)
			rateMap[i] = int(rate64)
			totalRate = totalRate + int(rate64)
		}
		if totalRate > 0 {
			diceRate := RandNum(1, totalRate)
			var tmpTotal int
			for i, _ := range rates {
				tmpTotal = tmpTotal + rateMap[i]
				if tmpTotal >= diceRate {
					dice = i + 1
					break
				}
			}
		}
		// 保证点数在 1-6 之间
		if dice < 1 || dice > 6 {
			dice = RandNum(1, 6)
		}
	}
	data["diceNum"] = dice
	rs.StepCount = rs.StepCount + dice
	if rs.StepCount >= totalStep {
		rs.StepCount = totalStep
	}
	if rs.StepCount%this.stageStep == 0 {
		data["stage"] = rs.StepCount / this.stageStep
		data["stepNum"] = this.stageStep
	} else {
		data["stage"] = rs.StepCount/this.stageStep + 1
		data["stepNum"] = rs.StepCount % this.stageStep
	}

	// 根据步数查询是否中奖
	var gift Gift
	if err = o.QueryTable(new(Gift)).Filter("GameId", gId).Filter("Seq", rs.StepCount).Limit(1).One(&gift); err == orm.ErrNoRows {
		code = 2
		msg = "谢谢参与，再接再厉"
	} else if err != nil {
		msg = "获取活动失败，请刷新后重试"
		return
	} else {
		if gift.GiftType == 0 {
			code = 2
			msg = "谢谢参与，再接再厉"
		} else {
			code = 1
			msg = "恭喜您中奖！"
		}
	}
	// 开启事务，更新数据
	err = o.Begin()
	// 内定的情况，更新内定会员
	if assignGiftId != 0 {
		am.Enabled = 1
		am.ModifyDate = time.Now()
		if _, err = o.Update(&am, "Enabled", "ModifyDate"); err != nil {
			o.Rollback()
			code = 0
			msg = "操作失败，请刷新后重试"
			return
		}
	}
	var num int64
	// 减掉会员的抽奖次数
	num, err = o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Filter("LotteryNums__gt", 0).Update(orm.Params{
		"LotteryNums": orm.ColValue(orm.ColMinus, 1),
	})
	if num < 1 || err != nil {
		beego.Error("RichApiController error", err)
		o.Rollback()
		code = 0
		if num < 1 {
			msg = "抽奖机会已用完"
		} else {
			msg = "操作失败，请刷新后重试"
		}
		return
	}
	// 更新会员步数
	rs.LastDate = time.Now()
	if _, err = o.Update(&rs, "StepCount", "LastDate"); err != nil {
		beego.Error("RichApiController error", err)
		o.Rollback()
		code = 0
		msg = "操作失败，请刷新后重试"
		return
	}
	// 已中奖，则更新奖品数量
	if code == 1 {
		// 抽中则减掉1个奖品
		num, err = o.QueryTable(new(Gift)).Filter("Id", gift.Id).Filter("Quantity__gt", 0).Update(orm.Params{
			"Quantity": orm.ColValue(orm.ColMinus, 1),
		})
		if err != nil {
			beego.Error("RichApiController error", err)
			o.Rollback()
			code = 0
			msg = "操作失败，请刷新后重试"
			return
		}
		if num != 1 {
			code = 2
			msg = "很遗憾，奖品已经没有了"
		} else {
			// 抽奖记录中添加一条记录
			//礼品所在的步数
			step := fmt.Sprintf("第%d步—", rs.StepCount)
			rl := RewardLog{
				BaseModel:   BaseModel{CreateDate: time.Now(), ModifyDate: time.Now(), Creator: 0, Modifior: 0, Version: 0},
				GameId:      gId,
				Account:     account,
				GiftId:      gift.Id,
				GiftName:    step + gift.Name,
				GiftContent: gift.Content,
				Delivered:   0}
			_, err = o.Insert(&rl)
			if err != nil {
				beego.Error("RichApiController error", err)
				o.Rollback()
				code = 0
				msg = "操作失败，请刷新后重试"
				return
			}
			if gift.Content != "" {
				data["gift"] = gift.Content
			} else {
				data["gift"] = gift.Name
			}
			data["photo"] = gift.Photo
		}
	}
	isNeedBroadcast = gift.BroadcastFlag
	o.Commit()
	return

}

func (this *RichApiController) GetLevelGift() {
	var code int
	var msg string
	gid, _ := this.GetInt64("gid")
	account := strings.TrimSpace(this.GetString("account"))
	stage, _ := this.GetInt64("stage")
	mobile := strings.TrimSpace(this.GetString("mobile"))
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	if mobile == "" {
		msg = "手机号不能为空"
		return
	}
	//更新会员的手机号
	o := orm.NewOrm()
	var mb Member
	err := o.QueryTable(new(Member)).Filter("Account", account).One(&mb, "Mobile")
	if err != nil {
		code = 1
		msg = "会员账号不存在"
		return
	}
	//验证手机号格式
	if hasError, errMsg := validate(mobile); hasError {
		msg = errMsg
		return
	}
	//判断会员管理中如果包含这个手机号就不添加
	contains := strings.Contains(mb.Mobile, mobile)
	if mobile != "" && !contains {
		_, err := o.QueryTable(new(Member)).Filter("Account", account).Update(orm.Params{"Mobile": mb.Mobile + ";" + mobile})
		if err != nil {
			beego.Info("更新会员账号手机号失败", err)
		}
	}
	if account == "" || stage == 0 || mobile == "" || gid == 0 {
		msg = "数据异常，请刷新后重试"
	}
	if stage < 2 {
		code = 1
		msg = "请过本关卡后,再点击领取奖励~"
	} else {
		code = 1
		l := fmt.Sprintf("关卡%d奖励", stage-1)
		var rs = RewardLog{
			BaseModel:   BaseModel{Creator: 0, Modifior: 0, CreateDate: time.Now(), ModifyDate: time.Now(), Version: 0},
			GameId:      gid,
			Account:     account,
			GiftName:    "过关奖励",
			GiftContent: l}
		o.Begin()
		bool, _, err := o.ReadOrCreate(&rs, "GameId", "Account", "GiftContent")
		if err != nil {
			beego.Error("关卡奖励插入失败", err)
			msg = "系统异常请刷新后重试"
			o.Rollback()
			return
		}
		o.Commit()
		if !bool {
			msg = "您已经申请过此关卡的过关奖励了"
			return
		}
		msg = "您的申请已提交成功,请耐心等待专员为您派奖"
	}
}

func validate(mobile string) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Mobile(mobile, "errmsg").Message("手机号格式不正确请重新输入")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}
