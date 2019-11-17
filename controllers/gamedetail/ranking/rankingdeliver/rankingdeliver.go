package rankingdeliver

import (
	"fmt"
	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"math"
	"os"
	"phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/ranking"
	"phage-games-web/utils"
	"phage/controllers/sysmanage"
	"phage/models"
	"strconv"
	"strings"
	"time"
)

type RankingDeliverIndexController struct {
	sysmanage.BaseController
}

func (this *RankingDeliverIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *RankingDeliverIndexController) Get() {
	beego.Informational("query rankingdeliver")
	gId, _ := this.GetInt64("gameId", 0)
	rankingtype1 := strings.TrimSpace(this.GetString("RankingType"))
	rankingtype, _ := strconv.ParseInt(rankingtype1, 10, 64)
	account := strings.TrimSpace(this.GetString("account"))
	amount := strings.TrimSpace(this.GetString("amount"))
	period := strings.TrimSpace(this.GetString("Period"))
	rankingflag := strings.TrimSpace(this.GetString("RankingFlag"))
	delivered, _ := this.GetInt8("delivered", 0)
	limit, _ := beego.AppConfig.Int("pagelimit")

	//导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}

	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}

	list, total := new(Ranking).Paginate(page, limit, gId, rankingtype, account, amount, period, rankingflag, delivered)
	pagination.SetPaginator(this.Ctx, limit, total)
	this.Data["condArr"] = map[string]interface{}{"account": account,
		"rankingType":   rankingtype,
		"amount":        amount,
		"rankingflag":   rankingflag,
		"currentPeriod": period,
		"delivered":     delivered}
	if rankingtype == 0 || rankingtype == 2 {
		_, periods := utils.GetPeriodMap(gId)
		this.Data["periods"] = periods
	}
	if rankingtype == 1 {
		periods := utils.GetSubMonth(gId)
		this.Data["periods"] = periods
	}
	this.Data["rankingtype"] = rankingtype1

	this.Data["gameList"] = common.GetGames("ranking")
	this.Data["List"] = list
	this.TplName = "gamedetail/ranking/rankingdeliver/index.tpl"
}

func (this *RankingDeliverIndexController) Post() {

	gid, _ := this.GetInt64("gameid")
	// gId, _ := this.GetInt64("gameId", 0)
	rty, _ := this.GetInt64("ranktype", 0)

	if rty == 0 || rty == 2 {
		_, perio := utils.GetPeriodMap(gid)
		this.Data["json"] = perio
	}
	if rty == 1 {
		periods := utils.GetSubMonth(gid)
		this.Data["json"] = periods
	}
	if rty == 3 {
		ling := [1][2]string{{"", ""}}
		this.Data["json"] = ling
	}
	this.ServeJSON()
}

func (this *RankingDeliverIndexController) CreateDelivered() {
	/*
	 根据对应的活动，排行榜类型，期数生成派奖信息
	*/
	beego.Informational("createdelivered")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId")
	rankingtype, _ := this.GetInt64("RankingType")
	period, _ := this.GetInt64("Period")
	o := orm.NewOrm()
	var weekranking []Ranking
	var weekrankingconfig []RankingConfig
	o.QueryTable(new(Ranking)).Filter("GameId", gId).Filter("RankingType", rankingtype).Filter("Period", period).OrderBy("-Amount").Limit(50000).All(&weekranking)
	err := o.Begin()
	o.QueryTable(new(RankingConfig)).Filter("RankingType", rankingtype).OrderBy("MinRank").All(&weekrankingconfig)
	for i, v := range weekranking {
		var h int64
		h = int64(i + 1)
		weekupdate := Ranking{BaseModel: models.BaseModel{Id: v.Id}, Seq: h, Delivered: 1, Prize: ""}
		//如果会员为虚拟会员，则直接标记为已派奖
		if v.RankingFlag == 1 {
			_, err = o.Update(&weekupdate, "Delivered")
			if err != nil {
				beego.Error("update Delivered error", err)
				o.Rollback()
				msg = "生成失败"
				return
			}
		}
		_, err = o.Update(&weekupdate, "Seq", "Prize")
		if err != nil {
			beego.Error("update Seq eroor", err)
			o.Rollback()
		}
		for _, j := range weekrankingconfig {
			var h int64
			h = int64(i + 1)
			bool := h >= j.MinRank && h <= j.MaxRank && v.Amount > j.EffectiveBetting
			if bool {
				weekupdate := Ranking{BaseModel: models.BaseModel{Id: v.Id}, RankingType: v.RankingType, Prize: j.Prize}
				_, err = o.Update(&weekupdate, "Prize")
				if err != nil {
					beego.Error("update seq prize error", err)
					o.Rollback()
					msg = "生成失败"
					return
				}
			}
		}
	}
	o.Commit()
	msg = "生成成功"
}

func (this *RankingDeliverIndexController) CreateTotal() {
	beego.Informational("crate total")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	o := orm.NewOrm()
	rankingdel := Ranking{GameId: gId, RankingType: 3}
	_, err1 := o.Delete(&rankingdel, "GameId", "RankingType")
	if err1 != nil {
		beego.Error("Delete deliver error", err1)
		msg = "删除失败"
	}
	models := make([]Ranking, 0)
	//idsDel := make([]int64, 0)
	var totals []orm.ParamsList
	//var ranking Ranking
	_, err := o.Raw("SELECT account,SUM(amount) ranking,ranking_flag from ph_ranking where game_id =  ? and  ranking_type = 0  group by account order BY  ranking DESC", gId).ValuesList(&totals)
	if err != nil {
		beego.Error("查询总信息错误", err)
	}
	for i, v := range totals {
		totalamount, _ := strconv.ParseInt(v[1].(string), 10, 64)
		rankflag, _ := strconv.ParseInt(v[2].(string), 10, 64)
		rankingtype := int64(3)
		rankingconfigs := GetRankingConfig(rankingtype)

		model := Ranking{}
		model.Account = v[0].(string)
		model.Amount = totalamount
		var h int64
		h = int64(i + 1)
		model.Seq = h
		for _, m := range rankingconfigs {
			bool := h >= m.MinRank && h <= m.MaxRank && totalamount >= m.EffectiveBetting
			if bool {
				model.Prize = m.Prize
				break
			}
		}
		if model.Prize == "" {
			model.Prize = "无"
		}
		model.GameId = gId
		model.RankingType = rankingtype
		model.RankingFlag = rankflag
		//如果为虚拟会员直接标记为已派送
		if rankflag == 1 {
			model.Delivered = 1
		}
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		model.CreateDate = time.Now()
		model.ModifyDate = time.Now()
		model.Version = 0
		models = append(models, model)
	}
	o.Begin()
	var susNums int64
	//将数组拆分导入，一次1000条
	mlen := len(models)
	if mlen > 0 {
		for i := 0; i <= mlen/1000; i++ {
			end := 0
			if (i+1)*1000 >= mlen {
				end = mlen
			} else {
				end = (i + 1) * 1000
			}
			tmpArr := models[i*1000 : end]
			if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
				o.Rollback()
				beego.Error("rankingtotal  insert error", err)
				msg = "插入失败"
				return
			} else {
				susNums += nums
			}
		}
	}
	o.Commit()
	msg = "总榜生成成功"
}

func (this *RankingDeliverIndexController) Delivered() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	delivered, _ := this.GetInt8("delivered")
	rl := Ranking{BaseModel: models.BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&rl)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		msg = "数据不存在，请确认"
		return
	}
	rl.Delivered = delivered
	rl.DeliveredTime = time.Now()
	rl.Modifior = this.LoginAdminId
	_, err1 := rl.Update("Delivered", "DeliveredTime")
	if err1 != nil {
		beego.Error("Enabled RewardLog error", err1)
		msg = "操作失败"
	} else {
		code = 1
		msg = "操作成功"
	}
}

func (this *RankingDeliverIndexController) Deliveredbatch() {
	beego.Informational("Deliveredbatch")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, _ := this.GetInt64("gameId", 0)
	rankingtype, _ := this.GetInt64("RankingType")
	account := strings.TrimSpace(this.GetString("account"))
	totalamount := strings.TrimSpace(this.GetString("totalamount"))
	period := strings.TrimSpace(this.GetString("Period"))
	delivered, _ := this.GetInt8("delivered", 2)

	o := orm.NewOrm()
	qs := o.QueryTable(new(Ranking))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	cond = cond.And("RankingType", rankingtype)
	if rankingtype != 3 {
		cond = cond.And("Period", period)
	}
	if account != "" {
		cond = cond.And("Account__contains", account)
	}
	if totalamount != "" {
		cond = cond.And("WeekAmount__exact", totalamount)
	}
	if delivered != 2 {
		cond = cond.And("Delivered", delivered)
	}
	qs = qs.SetCond(cond)
	if num, err := qs.Update(orm.Params{"Delivered": 1, "DeliveredTime": time.Now(), "Modifior": this.LoginAdminId}); err != nil {
		beego.Error("Delivered batch ranking error", err)
		msg = "批量标记失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功标记%d条记录", num)
	}
}

func (this *RankingDeliverIndexController) Export() {
	beego.Informational("export ranking")
	gId, _ := this.GetInt64("gameId", 0)
	rankingtype1 := strings.TrimSpace(this.GetString("RankingType"))
	rankingtype, _ := strconv.ParseInt(rankingtype1, 10, 64)
	account := strings.TrimSpace(this.GetString("account"))
	amount := strings.TrimSpace(this.GetString("amount"))
	period := strings.TrimSpace(this.GetString("Period"))
	rankingflag := strings.TrimSpace(this.GetString("RankingFlag"))
	delivered, _ := this.GetInt8("delivered", 0)

	page := 1
	limit := 1000
	list, total := new(Ranking).Paginate(page, limit, gId, rankingtype, account, amount, period, rankingflag, delivered)
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(Ranking).Paginate(page, limit, gId, rankingtype, account, amount, period, rankingflag, delivered)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}
	gameName := utils.GetGameName(gId)
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "游戏名称")
	xlsx.SetCellValue("Sheet1", "B1", "会员账号")
	xlsx.SetCellValue("Sheet1", "C1", "有效投注")
	xlsx.SetCellValue("Sheet1", "D1", "排名")
	xlsx.SetCellValue("Sheet1", "E1", "期数")
	xlsx.SetCellValue("Sheet1", "F1", "奖品")
	xlsx.SetCellValue("Sheet1", "G1", "会员标识")
	xlsx.SetCellValue("Sheet1", "H1", "是否派送")
	xlsx.SetCellValue("Sheet1", "I1", "派送时间")
	xlsx.SetCellValue("Sheet1", "J1", "排行类型")
	for i, value := range list {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), gameName)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.Amount)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.Seq)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("E%d", i+2), value.Period)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("F%d", i+2), value.Prize)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("G%d", i+2), value.RankingFlag)
		if value.Delivered == 1 {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("H%d", i+2), "已派送")
		} else {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("H%d", i+2), "未派送")
		}
		if !value.DeliveredTime.IsZero() {
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("I%d", i+2), value.DeliveredTime.Format("2006-01-02 15:04:05"))
		}
		fmt.Println("类型", value.RankingType)
		switch value.RankingType {
		case 0:
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("j%d", i+2), "周排行")
		case 1:
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("j%d", i+2), "月排行")
		case 2:
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("j%d", i+2), "幸运榜")
		case 3:
			xlsx.SetCellValue("Sheet1", fmt.Sprintf("j%d", i+2), "总榜")

		}
	}
	fileName := fmt.Sprintf("./tmp/excel/rankinglist_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export reward error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}
