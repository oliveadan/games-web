package monthsigninapi

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"net/http"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/monthsignin"
	"phage-games-web/models/gift"
	"phage-games-web/models/rewardlog"
	"phage/controllers/sysmanage"
	"strconv"
	"strings"
	"time"
)

type MonthSigninApiController struct {
	beego.Controller
}

func (this *MonthSigninApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *MonthSigninApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	SetGameData(&this.Controller, &gId)
	this.TplName = "front/monthsignin/index.html"
}

//登录
func (this *MonthSigninApiController) Login() {
	gid, _ := this.GetInt64("gameid", 0, 10)
	account := this.GetString("account")
	month, _ := this.GetInt("month", 0)
	var msg string
	var code int
	data := make(map[string]interface{}, 0)
	defer Retjson(this.Ctx, &msg, &code, &data)
	parmter := checkParmter(gid, "-1")
	if parmter != "" {
		msg = parmter
		return
	}
	if account == "" {
		msg = "会员账号不能为空"
		return
	}

	o := orm.NewOrm()
	//IP限制
	/*ip := this.Ctx.Input.IP()
	info, err := IpLimit(gid, ip, account)
	if err != nil || info != "" {
		msg = info
		return
	}*/

	exist := o.QueryTable(new(Member)).Filter("Account", account).Exist()
	if !exist {
		msg = "会员账号不存在"
		return
	}
	//获取本月签到天数
	start, end := MonthZero(month)
	var sd []MonthsigninLog
	_, err := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId", 0).Filter("SigninDate__gte", start).Filter("SigninDate__lt", end).OrderBy("SigninDate").All(&sd)
	if err != nil {
		beego.Error("query MonthsigninLog err", err)
		msg = "登录失败(1),请刷新后重试"
		return
	}
	//去除不在活动时间内的签到天数

	type Signed struct {
		SignDay int
		Status  int64
	}
	var AlreadySign []Signed
	t13, t2 := GameTime(gid)
	for _, v := range sd {
		//去除不在活动时间内的已签到信息
		b := v.SigninDate.Before(t13) || v.SigninDate.After(t2)
		if b {
			continue
		}
		var ds Signed
		ds.SignDay = v.SigninDate.Day()
		ds.Status = v.Status
		AlreadySign = append(AlreadySign, ds)
	}
	//获取已领取奖励的天数
	t1, _ := GameTime(gid)
	var gifts []MonthsigninLog
	_, err = o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId__gt", 0).Filter("SigninDate__gt", t1).All(&gifts)
	if err != nil {
		logs.Info("query MonthsigninLogGift err", err)
		msg = "登录失败(2),请刷新后重试"
		return
	}
	var r []int64
	for _, v := range gifts {
		r = append(r, v.GiftId)
	}
	//获取会员投注
	var mb MonthsigninBet
	err = o.QueryTable(new(MonthsigninBet)).Filter("GameId", gid).Filter("Account", account).One(&mb, "bet")
	if err != nil {
		logs.Error("query MonthsigninBet error", err)
	}
	//获取会员在活动时间内签到天数总和
	t12, t2 := GameTime(gid)
	sumDay, _ := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId", 0).Filter("SigninDate__gte", t12).Filter("SigninDate__lte", t2).Count()
	//判断会员今天是否已经签到
	b := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId", 0).Filter("SigninDate__gte", time.Now().Format("2006-01-02")).Exist()
	todaySign := 0
	if b {
		todaySign = 1
	}
	this.SetSession("monthSignInAccount", account)
	data["Bet"] = mb.Bet
	data["signed"] = AlreadySign
	data["received"] = r
	data["sumdays"] = sumDay
	data["todaysign"] = todaySign
	code = 1
	msg = "登录成功"
}

//签到
func (this *MonthSigninApiController) SignIn() {
	gid, _ := this.GetInt64("gameid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	month, _ := this.GetInt("month", 0)
	var msg string
	var code int
	data := make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	parmter := checkParmter(gid, account)
	if parmter != "" {
		msg = parmter
		return
	}
	sessionAccount := this.GetSession("monthSignInAccount")
	if sessionAccount == nil || sessionAccount.(string) != account {
		msg = "请先登录"
		return
	}
	ok, s := CheckGame(gid, "-1")
	if !ok {
		msg = s
		return
	}
	o := orm.NewOrm()
	today, _ := time.ParseInLocation("2006-01-02", time.Now().Format("2006-01-02"), time.Local)
	//验证投注是否达到要求
	var mb MonthsigninBet
	err := o.QueryTable(new(MonthsigninBet)).Filter("GameId", gid).Filter("Account", account).One(&mb)
	if err != nil {
		logs.Error("query MonthsigninBet error", err)
		msg = "您未达到签到条件不能进行签到"
		return
	}

	//验证是否已经签到
	exist := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId", 0).Filter("SigninDate__gte", today).Exist()
	if exist {
		msg = "今天您已经签到过了"
		return
	}
	//获取礼品
	date := GetGiftSeq(month, time.Now().Day())
	var g gift.Gift
	err = o.QueryTable(new(gift.Gift)).Filter("GameId", gid).Filter("Seq", date).One(&g)
	if err != nil {
		logs.Error("query gift error", err)
		msg = "签到异常(1),请刷新后重试"
		return
	}
	//验证是否达到打码要求
	if mb.Bet-int64(g.Probability) < 0 {
		msg = "您未达到签到条件不能进行签到"
		return
	}
	//生成签到记录
	var ms MonthsigninLog
	ms.GameId = gid
	ms.Account = account
	ms.SigninDate = time.Now()
	_, err1 := o.Insert(&ms)
	if err1 != nil {
		o.Rollback()
		logs.Error("create monthsigninlog error", err)
		msg = "签到异常(3),请刷新后重试"
		return
	}
	//添加中奖记录
	var rew rewardlog.RewardLog
	rew.Account = account
	rew.GameId = gid
	rew.GiftName = g.Name
	rew.GiftContent = g.Content
	o.Begin()
	_, err = rew.Create()
	if err != nil {
		o.Rollback()
		logs.Error("insert rewardLog error", err)
		msg = "签到异常(2),请刷新后重试"
		return
	}
	//更新签到打码量
	_, err = o.QueryTable(new(MonthsigninBet)).Filter("GameId", gid).Filter("Account", account).Update(orm.Params{"SurplusBet": orm.ColValue(orm.ColMinus, g.Probability)})
	if err != nil {
		o.Rollback()
		logs.Error("udpate MonthsigninBet error", err)
		msg = "签到异常(4),请刷新后重试"
	}
	o.Commit()
	data["giftname"] = g.Name
	data["giftcontent"] = g.Content
	data["giftphoto"] = g.Photo
	code = 1
	msg = "恭喜您签到成功"
}

//查看签到当天中奖奖品
func (this *MonthSigninApiController) QueryGift() {
	gid, _ := this.GetInt64("gameid", 0)
	day, _ := this.GetInt("day", 0)
	account := this.GetString("account")
	month, _ := this.GetInt("month", 0)
	var msg string
	var code int
	data := make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	if month == 0 {
		msg = "月份显示异常,请刷新后重试"
		return
	}
	parmter := checkParmter(gid, "-1")
	if parmter != "" {
		msg = parmter
		return
	}
	o := orm.NewOrm()
	var g gift.Gift
	date := GetGiftSeq(month, day)
	err := o.QueryTable(new(gift.Gift)).Filter("GameId", gid).Filter("Seq", date).One(&g)
	if err != nil {
		logs.Error("query gitf error", err)
		msg = "这个日期没有礼物"
		return
	}
	//是否可以补签,1可以补签0是不可以
	enable := 1
	session := this.GetSession("monthSignInAccount")
	if session == nil || account != session.(string) {
		enable = 0
	} else {
		//判断是否已经签到
		start, end := MonthAndDay(month, day)
		//判断是否在活动时间内
		t1, t2 := GameTime(gid)
		nowdate, _ := time.ParseInLocation("2006-01-02", start, time.Local)
		if nowdate.Before(t1) || nowdate.After(t2) {
			enable = 0
		} else {
			exist := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", session.(string)).Filter("SigninDate__gte", start).Filter("SigninDate__lt", end).Filter("GiftId", 0).Exist()
			//判断查询日期是否在今天以后
			i := month - int(time.Now().Month())
			if exist {
				enable = 0
			} else if i >= 0 {
				nowDay := time.Now().Day()
				b := nowDay <= day
				if b || i > 1 {
					enable = 0
				}
			}
		}
	}

	//如果查看的礼品的日期大于今天的日期不显示，1可以，0不可以。
	show := 1
	i2 := month - int(time.Now().Month())
	if i2 >= 0 {
		if time.Now().Day() < day || i2 > 1 {
			show = 0
		}
	}
	data["showenable"] = show
	data["signenable"] = enable
	data["giftname"] = g.Name
	data["giftcontent"] = g.Content
	data["giftphoto"] = g.Photo
	data["bet"] = g.Probability
	code = 1
	msg = "查询成功"
}

//查询满几天后可以获得的礼物
func (this *MonthSigninApiController) QueryDaysGift() {
	gid, _ := this.GetInt64("gameid", 0)
	var msg string
	var code int
	data := make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	parmter := checkParmter(gid, "-1")
	if parmter != "" {
		msg = parmter
		return
	}
	o := orm.NewOrm()
	var gifts []gift.Gift
	_, err := o.QueryTable(new(gift.Gift)).Filter("GameId", gid).Filter("seq__gt", 10000).All(&gifts)
	if err != nil {
		logs.Info("query Gift error", err)
		msg = "获取列表失败"
		return
	}
	type Gifts struct {
		Id      int64
		Days    int
		Name    string
		Content string
		Photo   string
	}
	var gs []Gifts
	for _, v := range gifts {
		var g Gifts
		g.Id = v.Id
		g.Days = v.Seq - 10000
		g.Name = v.Name
		g.Content = v.Content
		g.Photo = v.Photo
		gs = append(gs, g)
	}
	code = 1
	data["gifts"] = gifts
	msg = "查询成功"
}

func (this *MonthSigninApiController) GetDaysGift() {
	gid, _ := this.GetInt64("gameid", 0)
	account := strings.TrimSpace(this.GetString("account"))
	giftId, _ := this.GetInt64("giftId", 0)
	var msg string
	var code int
	data := make(map[string]interface{})
	defer Retjson(this.Ctx, &msg, &code, &data)
	parmter := checkParmter(gid, account)
	if parmter != "" {
		msg = parmter
		return
	}
	o := orm.NewOrm()
	//查看是否已领取.活动设置的时间内只能领取一次
	t1, t2 := GameTime(gid)
	bool := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId", giftId).Filter("SigninDate__gte", t1).Exist()
	if bool {
		msg = "您已经领取过这个礼品了"
		return
	}

	//获取奖品
	var dayGift gift.Gift
	err := o.QueryTable(new(gift.Gift)).Filter("GameId", gid).Filter("Id", giftId).One(&dayGift)
	if err != nil {
		beego.Error("query GIFT error", err)
		msg = "获取礼品失败(1),请刷新后重试"
		return
	}
	//验证是否可以领取
	i, err := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId", 0).Filter("SigninDate__gte", t1).Filter("SigninDate__lte", t2).Count()
	if err != nil {
		beego.Error("query MonthsigninLog err(2)", err)
		msg = "获取礼品失败(2),请刷新后重试"
		return
	}
	b := int64(dayGift.Seq-10000) - i
	if b > 0 {
		msg = fmt.Sprintf("您还需要签到%d天后可领取", b)
		return
	}
	//生成中奖记录
	var rew rewardlog.RewardLog
	rew.Account = account
	rew.GameId = gid
	rew.GiftName = dayGift.Name
	rew.GiftContent = dayGift.Content
	o.Begin()
	_, err = rew.Create()
	if err != nil {
		o.Rollback()
		beego.Error("insert rewardLog error", err)
		msg = "获取礼品失败(2),请刷新后重试"
		return
	}
	var log MonthsigninLog
	log.GameId = gid
	log.SigninDate = time.Now()
	log.Account = account
	log.GiftId = giftId
	_, err = o.Insert(&log)
	if err != nil {
		o.Rollback()
		logs.Info("insert MonthsigninLog gift error", err)
		msg = "获取礼品失败(3),请刷新后重试"
		return
	}
	o.Commit()
	code = 1
	data["giftname"] = dayGift.Name
	data["giftcontent"] = dayGift.Content
	data["giftphoto"] = dayGift.Photo
	msg = "领取成功"
}

func (this *MonthSigninApiController) Retroactive() {
	var code int
	var msg string
	data := make(map[string]interface{}, 0)
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &data)
	gid, _ := this.GetInt64("gameid", 0)
	account := this.GetString("account")
	day, _ := this.GetInt("day", 0)
	month, _ := this.GetInt("month", 0)
	parmter := checkParmter(gid, account)
	if parmter != "" {
		msg = parmter
		return
	}
	ok, s := CheckGame(gid, "-1")
	if !ok {
		msg = s
		return
	}

	o := orm.NewOrm()
	//验证投注是否达到要求
	var mb MonthsigninBet
	err := o.QueryTable(new(MonthsigninBet)).Filter("GameId", gid).Filter("Account", account).One(&mb)
	if err != nil {
		logs.Error("query MonthsigninBet error", err)
		msg = "您未达到补签条件不能进行补签"
		return
	}

	//验证补签天数 是否已经签到
	start, end := MonthAndDay(month, day)
	exist := o.QueryTable(new(MonthsigninLog)).Filter("GameId", gid).Filter("Account", account).Filter("GiftId", 0).Filter("SigninDate__gte", start).Filter("SigninDate__lt", end).Exist()
	if exist {
		msg = "您已经补签过了"
		return
	}
	//获取礼品
	date := GetGiftSeq(month, day)
	var g gift.Gift
	err = o.QueryTable(new(gift.Gift)).Filter("GameId", gid).Filter("Seq", date).One(&g)
	if err != nil {
		logs.Error("query gift error", err)
		msg = "补签异常(1),请刷新后重试"
		return
	}
	var g1 gift.Gift
	err = o.QueryTable(new(gift.Gift)).Filter("GameId", gid).Filter("Seq", date).One(&g1)
	if err != nil {
		logs.Error("query gift error", err)
		msg = "补签异常(2),请刷新后重试"
		return
	}
	//验证是否达到打码要求
	var needBet int64
	if !exist {
		needBet = mb.SurplusBet - int64(g.Probability)
	} else {
		needBet = mb.SurplusBet
	}
	if needBet-int64(g.Probability) < 0 {
		msg = "您未达到补签条件不能进行补签"
		return
	}
	//添加中奖记录
	o.Begin()
	var rew rewardlog.RewardLog
	rew.Account = account
	rew.GameId = gid
	rew.GiftName = "【补签】" + g.Name
	rew.GiftContent = g.Content
	_, err = rew.Create()
	if err != nil {
		o.Rollback()
		logs.Error("insert rewardLog error", err)
		msg = "补签异常(3),请刷新后重试"
		return
	}
	var ms MonthsigninLog
	ms.GameId = gid
	ms.Account = account
	signDate, _ := time.ParseInLocation("2006-01-02", start, time.Local)
	ms.SigninDate = signDate
	ms.Status = 1
	_, err1 := o.Insert(&ms)
	if err1 != nil {
		o.Rollback()
		logs.Error("create monthsigninlog error", err)
		msg = "补签异常(4),请刷新后重试"
		return
	}
	//更新补签后的打码量
	_, err = o.QueryTable(new(MonthsigninBet)).Filter("GameId", gid).Filter("Account", account).Update(orm.Params{"SurplusBet": orm.ColValue(orm.ColMinus, g.Probability)})
	if err != nil {
		o.Rollback()
		logs.Error("udpate MonthsigninBet error", err)
		msg = "补签异常(5),请刷新后重试"
	}
	o.Commit()
	data["giftname"] = g.Name
	data["giftcontent"] = g.Content
	data["giftphoto"] = g.Photo
	code = 1
	msg = "恭喜您补签成功"
}

func (this *MonthSigninApiController) Logout() {
	this.DelSession("monthSignInAccount")
	homepage := this.GetString("url")
	if homepage != "" {
		this.Redirect(homepage, http.StatusFound)
	} else {
		this.ServeJSON()
	}
}

func checkParmter(id int64, account string) string {
	/*var msg string
	if id == 0 {
		msg = "系统异常,请刷新后重试(1)"
		return msg
	}
	if account != "-1" {
		if id == 0 || account == "" {
			msg = "系统异常,请刷新后重试(1)"
			return msg
		}
	}*/
	return ""
}

//获取礼品的序列号
func GetGiftSeq(month int, day int) string {
	var smonth string
	var sday string
	smonth = strconv.Itoa(month)
	sday = strconv.Itoa(day)
	if day < 10 {
		sday = fmt.Sprintf("0%d", day)
	}
	return smonth + sday
}

//返回到日的字符串
func MonthAndDay(month int, day int) (start, end string) {
	year := time.Now().Year()
	syear := strconv.Itoa(year)
	smonth := strconv.Itoa(month)
	sday := strconv.Itoa(day)
	sday1 := strconv.Itoa(day + 1)
	if month < 10 {
		smonth = "0" + smonth
	}
	if day < 10 {
		sday = "0" + sday
	}
	if day+1 < 10 {
		sday1 = "0" + sday1
	}
	return syear + "-" + smonth + "-" + sday, syear + "-" + smonth + "-" + sday1
}

//返回到月份的字符串
func MonthZero(month int) (start, end string) {
	year := time.Now().Year()
	syear := strconv.Itoa(year)
	smonth := strconv.Itoa(month)
	if month == 12 {
		year2 := strconv.Itoa(year + 1)
		return syear + "-" + smonth, year2 + "-" + "1"
	}
	smonth1 := strconv.Itoa(month + 1)
	if month < 10 {
		smonth = "0" + smonth
	}
	if month+1 < 10 {
		smonth1 = "0" + smonth1
	}
	return syear + "-" + smonth, syear + "-" + smonth1
}

//获取活动开始时间
func GameTime(id int64) (t1, t2 time.Time) {
	o := orm.NewOrm()
	var game Game
	o.QueryTable(new(Game)).Filter("Id", id).One(&game, "StartTime", "EndTime")
	return game.StartTime, game.EndTime
}
