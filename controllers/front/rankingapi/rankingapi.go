package rankingapi

import (
	. "games-web/controllers/front"
	. "games-web/models/gamedetail/ranking"
	"games-web/utils"
	"github.com/astaxie/beego"
	"strings"
)

type RankingApiController struct {
	beego.Controller
}

func (this *RankingApiController) Prepare() {
	this.EnableXSRF = false
}

func (this *RankingApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)
	SetGameData(&this.Controller, &gId)
	//总榜显示信息
	list := GetTotals(gId)
	//月榜的期数
	mothperiods := utils.GetSubMonth(gId)
	//周榜和幸运榜期数显示
	_, periods := utils.GetPeriodMap(gId)
	this.Data["weekperiods"] = periods
	this.Data["mothperiods"] = mothperiods
	this.Data["luckyperiods"] = periods
	this.Data["total"] = list
	this.Data["gameid"] = gId
	this.TplName = "front/ranking/index.tpl"
}

//首页榜单查询展示
func (this *RankingApiController) Query() {
	//根据榜单类型和榜单期数进行查询
	rankingtype, _ := this.GetInt64("rankingType")
	period, _ := this.GetInt64("period")
	gid, _ := this.GetInt64("gameid")
	list := GetTypeAndPeriod(gid, rankingtype, period)
	var data = make(map[string]interface{})
	data["list"] = list
	this.Ctx.Output.JSON(data, false, false)
}

//单个会员账号查询
func (this *RankingApiController) AccountQuery() {
	var data = make(map[string]interface{})
	account := strings.TrimSpace(this.GetString("account"))
	gid, _ := this.GetInt64("gameid")
	total, weeks, months := QueryByAccount(gid, account)
	data["account"] = account
	data["total"] = total
	data["weeks"] = weeks
	data["months"] = months
	this.Ctx.Output.JSON(data, false, false)
}
