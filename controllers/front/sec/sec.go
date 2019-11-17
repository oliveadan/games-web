package sec

import (
	"games-web/controllers/front"
	. "games-web/models/common"
	. "games-web/models/gift"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/utils"

	"fmt"
	"time"
)

type SecApiController struct {
	beego.Controller
}

func (c *SecApiController) Prepare() {
	c.EnableXSRF = false
}

func (c *SecApiController) Get() {
	gId, _ := c.GetInt64("gid", 0)
	front.SetGameData(&c.Controller, &gId)
	rlList := front.SetRewardList(&c.Controller, &gId)
	c.Data["rlList"] = rlList[:len(rlList)/2]
	c.Data["rlList1"] = rlList[len(rlList)/2:]
	o := orm.NewOrm()
	var periodList []GamePeriod
	_, err := o.QueryTable(new(GamePeriod)).Filter("GameId", gId).OrderBy("StartTime").All(&periodList, "StartTime", "EndTime")
	if err != nil {
		beego.Error("获取秒杀时间段失败", err)
	}

	var giftlist []Gift
	_, err1 := o.QueryTable(new(Gift)).Filter("GameId", gId).OrderBy("Seq").All(&giftlist)
	if err1 != nil {
		beego.Error("获取秒杀礼物失败", err)
	}
	if IsWap(c.Ctx.Input.UserAgent()) {
		c.Data["ismobile"] = 1
	} else {
		c.Data["ismobile"] = 0
	}
	c.Data["curTime"] = time.Now().Format("15:04:05")
	c.Data["giftList"] = giftlist
	c.Data["periodList"] = periodList
	c.TplName = fmt.Sprintf("front/sec/index-pc-v%v.tpl", c.Data["gameVersion"])
}

func (c *SecApiController) Post() {
	var code int
	var msg string
	var data = map[string]string{"seq": "0", "gift": "", "photo": ""}
	defer front.Retjson(c.Ctx, &msg, &code, &data)
	account := c.GetString("account")
	gid, _ := c.GetInt64("gid")
	//验证接口
	o := orm.NewOrm()
	var game Game
	if err := o.QueryTable(new(Game)).Filter("Id", gid).One(&game, "GameType"); err != nil {
		msg = "活动获取失败，请刷新后重试！"
		return
	}
	if game.GameType != "sec" {
		beego.Info("会员账号", account, "IP地址:", c.Ctx.Input.IP(), "违法使用接口")
		msg = "违法使用接口，警告一次！"
		return
	}
	//验证
	var ok bool
	if ok, msg = front.CheckGame(gid, account); !ok {
		code = 0
		return
	}
	var periodList []GamePeriod
	nums, err := o.QueryTable(new(GamePeriod)).Filter("GameId", gid).OrderBy("StartTime").All(&periodList, "StartTime", "EndTime")
	if err != nil {
		msg = "活动获取错误，请刷新后重试"
		return
	}
	var seq int
	if nums > 0 {
		var isInPeriod bool
		for i, v := range periodList {
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
				seq = i + 1
				break
			}
		}
		if !isInPeriod {
			msg = "不在秒杀时段内，请关注下一时段"
			return
		}
	} else {
		msg = "秒杀时间时段不存在"
		return
	}
	//查询礼品
	var gift Gift
	if err = o.QueryTable(new(Gift)).Filter("GameId", gid).Filter("Seq", seq).Limit(1).One(&gift); err != nil {
		beego.Error("获取秒杀礼物失败", err)
		msg = "秒杀异常，请刷新后重试"
		return
	}
	if gift.Quantity <= 0 {
		code = 0
		msg = "本时段奖品被秒杀光了，请关注下一时段"
		return
	}
	if code, msg = front.UpdateLotteryResult(gid, account, &gift, 0); code != 1 {
		code = 0
		return
	}

	if gift.Content != "" {
		data["gift"] = gift.Content
	} else {
		data["gift"] = gift.Name
	}
	code = 1
	return
}
