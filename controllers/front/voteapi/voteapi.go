package voteapi

import (
	"fmt"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/vote"
	. "phage-games-web/models/rewardlog"
	. "phage/utils"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type VoteApiController struct {
	beego.Controller
}

func (this *VoteApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *VoteApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	SetRewardList(&this.Controller, &gId)
	o := orm.NewOrm()
	var voteitems []VoteItem
	_, err := o.QueryTable(new(VoteItem)).Filter("Gameid", gId).All(&voteitems)
	if err != nil {
		beego.Error("查询选票失败", err)
	}
	this.Data["List"] = voteitems
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/vote/index-wap.tpl"
	} else {
		this.TplName = "front/vote/index-pc.tpl"
	}
}

func (this *VoteApiController) VoteGo() {
	var code int
	var msg string
	defer Retjson(this.Ctx, &msg, &code)
	gId, err := this.GetInt64("gid", 0)
	if err != nil || gId == 0 {
		msg = "活动获取失败，请联系客服确认"
		return
	}
	account := strings.TrimSpace(this.GetString("account"))
	if account == "" {
		msg = "会员账号或手机号必须填写"
		return
	}
	// 分享
	defer func() {
		if code == 1 {
			go ShareDetailGenerate(this.Ctx, gId, account)
		}
	}()
	viId, err := this.GetInt64("viId")
	if err != nil {
		msg = "选票获取异常，请刷新后重试"
		return
	}
	// 验证活动是否在进行中,会员账号不进行校验
	var ok bool
	if ok, msg = CheckGame(gId, account); !ok {
		return
	}
	viName := this.GetString("viName")
	vd := VoteDetail{}
	vd.CreateDate = time.Now()
	vd.ModifyDate = time.Now()
	vd.Creator = 0
	vd.Modifior = 0
	vd.Version = 0
	vd.GameId = gId
	vd.Account = account
	vd.Ip = this.Ctx.Input.IP()
	vd.VoteItemId = viId
	vd.VoteItemName = viName

	o := orm.NewOrm()
	o.Begin()
	var ml MemberLottery
	err = o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).One(&ml, "Id", "LotteryNums")

	if err == nil {
		// 配置了会员投票次数
		if ml.LotteryNums <= 0 {
			o.Rollback()
			msg = "投票次数已用完了！"
			return
		}
		// 减掉会员的抽奖次数
		num, err := o.QueryTable(new(MemberLottery)).Filter("GameId", gId).Filter("Account", account).Filter("LotteryNums__gt", 0).Update(orm.Params{
			"LotteryNums": orm.ColValue(orm.ColMinus, 1),
		})
		if num < 1 || err != nil {
			beego.Error("VoteApiController Votego error", err)
			o.Rollback()
			if num < 1 {
				msg = "投票次数已用完了！"
			} else {
				msg = "操作失败，请刷新后重试"
			}
			return
		}
	} else {
		if err == orm.ErrNoRows {
			if o.QueryTable(new(VoteDetail)).Filter("GameId", gId).Filter("Account", account).Exist() {
				o.Commit()
				code = 1
				msg = "马上注册会员，获得更多投票机会！"
				return
			}
		} else {
			o.Rollback()
			msg = "操作失败，请刷新后重试"
			return
		}
	}

	if _, err := o.Insert(&vd); err != nil {
		o.Rollback()
		msg = "投票失败，请刷新后重试"
		return
	}
	num, err := o.QueryTable(new(VoteItem)).Filter("Id", viId).Update(orm.Params{
		"NumVote": orm.ColValue(orm.ColAdd, 1),
	})
	if err != nil || num != 1 {
		o.Rollback()
		msg = "投票异常，请刷新后重试"
		return
	}
	o.Commit()
	if ml.LotteryNums > 1 {
		msg = fmt.Sprintf("投票成功，您还有%d次机会。", ml.LotteryNums-1)
	} else {
		msg = "感谢您的投票！"
	}
	code = 1
}

func (this *VoteApiController) Search() {
	var code int
	var msg string
	var data = make([]map[string]interface{}, 0)
	defer Retjson(this.Ctx, &msg, &code, &data)
	gId, err := this.GetInt64("gid", 0)
	if err != nil || gId == 0 {
		msg = "活动获取失败，请确认活动网址"
		return
	}
	account := strings.TrimSpace(this.GetString("account"))
	if account == "" {
		msg = "请输入投票时填写的会员账号或手机号"
		return
	}
	o := orm.NewOrm()
	var vdList []VoteDetail
	var rl RewardLog
	if nums, err := o.QueryTable(new(VoteDetail)).Filter("GameId", gId).Filter("Account", account).OrderBy("-Id").All(&vdList); err != nil {
		msg = "查询异常，请重试"
		return
	} else if nums < 1 {
		msg = "您未参与投票"
		return
	}
	isCurrentOpen := o.QueryTable(new(VoteItem)).Filter("GameId", gId).Filter("Flag", 1).Exist()
	for _, v := range vdList {
		mTmp := make(map[string]interface{})
		mTmp["viName"] = v.VoteItemName
		if err := o.QueryTable(new(RewardLog)).Filter("GameId", gId).Filter("Account", account).Filter("GiftId", v.Id).Limit(1).One(&rl); err == nil {
			mTmp["isWin"] = 1 // 中奖
			mTmp["giftContent"] = rl.GiftContent
			mTmp["delevered"] = rl.Delivered
		} else {
			if isExist := o.QueryTable(new(VoteItem)).Filter("Id", v.VoteItemId).Exist(); isExist {
				if isCurrentOpen {
					mTmp["isWin"] = 2 // 未中奖
				} else {
					mTmp["isWin"] = 0 // 等待开奖
				}
			} else {
				mTmp["isWin"] = 2 // 未中奖
			}
		}
		data = append(data, mTmp)
	}
	code = 1
	msg = "查询成功"
}
