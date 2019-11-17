package ranking

import (
	"fmt"
	. "games-web/models/common"
	. "games-web/models/gamedetail/ranking"
	"games-web/utils"
	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
	"html/template"
	"net/url"
	"phage/controllers/sysmanage"
	. "phage/models"
	. "phage/utils"
	"strconv"
	"strings"
	"time"
)

func validate(ranking *Ranking) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.MinSize(ranking.Account, 6, "errMsg").Message("会员账号最少6位数")
	valid.MaxSize(ranking.Account, 14, "errMsg").Message("会员账号最多14位数")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type RankingIndexController struct {
	sysmanage.BaseController
}

func (this *RankingIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *RankingIndexController) Get() {
	beego.Informational("query ranking")
	gId, _ := this.GetInt64("gameId", 0)
	rankingType := strings.TrimSpace(this.GetString("RankingType"))
	rankingType1, _ := strconv.ParseInt(rankingType, 10, 64)
	account := strings.TrimSpace(this.GetString("account"))
	amount := strings.TrimSpace(this.GetString("acmout"))
	period := strings.TrimSpace(this.GetString("Period"))
	rankingflag := strings.TrimSpace(this.GetString("RankingFlag"))
	//这里是用来识别标识的如果是全部的话，进行下面操作
	if rankingflag == "3" {
		rankingflag = ""
	}
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	//当总是总榜的时候进行特殊处理
	var list []Ranking
	var total int64
	//这个字符用来区别前端和后台
	str := "后台"
	if rankingType1 == 3 {
		list1, total1 := Paginate2(str)
		list = list1
		total = total1
		limit = 100
	} else {
		list2, total2 := new(Ranking).Paginate(page, limit, gId, rankingType1, account, amount, period, rankingflag, 2)
		list = list2
		total = total2
	}
	pagination.SetPaginator(this.Ctx, limit, total)
	//获取期数，和在首页是否显示的标记
	if rankingType1 == 0 || rankingType1 == 2 {
		if gId != 0 {
			_, periods := utils.GetPeriodMap(gId)
			this.Data["periods"] = periods
		}
	}
	if rankingType1 == 1 {
		if gId != 0 {
			periods := utils.GetSubMonth(gId)
			this.Data["periods"] = periods
		}
	}
	//这个字符传作用是在首页中，用于判断如果是总榜的时候屏蔽不需要的元素
	this.Data["str"] = str
	this.Data["condArr"] = map[string]interface{}{"account": account,
		"rankingType":   rankingType1,
		"amount":        amount,
		"rankingflag":   rankingflag,
		"currentPeriod": period}
	this.Data["gameList"] = GetGames("ranking")
	this.Data["List"] = list
	this.TplName = "gamedetail/ranking/ranking/index.tpl"
}

func (this *RankingIndexController) Post() {
	gId, _ := this.GetInt64("gameid", 0)
	rty, _ := this.GetInt64("ranktype", 0)
	list, _ := GetPeriods(gId, rty)
	this.Data["json"] = list
	this.ServeJSON()
}

func (this *RankingIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	ranking := Ranking{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	_, err := o.Delete(&ranking, "Id")
	if err != nil {
		beego.Error("Delete member error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}
func (this *RankingIndexController) Delbatch() {
	beego.Informational(this.LoginAdminId, "删除所有投注排行榜")
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	ranktype, _ := this.GetInt64("RankingType", 6)
	period, _ := this.GetInt64("Period", 0)
	gId, _ := this.GetInt64("GameId")
	ranking := Ranking{RankingType: ranktype, Period: period, GameId: gId}
	o := orm.NewOrm()
	i, err := o.Delete(&ranking, "RankingType", "Period")
	if err != nil {
		beego.Error("Delete batch ranking error", err)
		msg = "删除失败"
	} else {
		code = 1
		msg = fmt.Sprintf("成功删除%d条", i)
	}

}
func (this *RankingIndexController) Import() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("ranking upload file get file error", err)
		msg = "上传失败，请重试(1)"
		return
	}
	fname := url.QueryEscape(h.Filename)
	suffix := SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".xlsx" {
		msg = "文件必须为 xlsx"
		return
	}
	o := orm.NewOrm()
	models := make([]Ranking, 0)
	idsDel := make([]int64, 0)

	// xlsx
	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("ranking import, open excel error", err)
		msg = "读取excel失败，请重试"
		return
	}

	rankingtype := map[string]int64{"周排行": 0, "月排行": 1, "幸运榜": 2}
	var str string
	for i := range rankingtype {
		fmt.Println(i)
		if xlsx.GetSheetIndex(i) == 0 {
			msg = "不存在<<周排行 >>,<<月排行>>或<<幸运榜>>sheet页脚"
		} else {
			msg = ""
			str = i
			break
		}
	}
	rows := xlsx.GetRows(str)
	//定义期数，下面查询本期是否存在使用
	var period int64
	var gameid int64
	for i, row := range rows {
		if i == 0 {
			period1, err := strconv.ParseInt(strings.TrimSpace(row[1]), 10, 0)
			period = period1
			if err != nil {
				msg = fmt.Sprintf("%s第%d行排行榜期数必须为数字<br>", msg, i+1)
				return
			}
			gameid1, err := strconv.ParseInt(strings.TrimSpace(row[3]), 10, 0)
			gameid = gameid1
			if err != nil {
				msg = fmt.Sprintf("%s第%d行游戏id数必须为数字<br>", msg, i+1)
				return
			}
			continue
		}
		if i == 1 {
			continue
		}
		if len(row) < 3 {
			msg = fmt.Sprintf("%s第%d行活动会员账号、有效投注、排名、标识不能为空<br>", msg, i+1)
			continue
		}
		account := strings.TrimSpace(row[0])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行会员账号不能为空<br>", msg, i+1)
			continue
		}
		amount, err := strconv.ParseInt(strings.TrimSpace(row[1]), 10, 0)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行有效投注必须为数字<br>", msg, i+1)
			continue
		}
		/*seq, err := strconv.ParseInt(strings.TrimSpace(row[2]), 10, 0)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行排名必须为数字<br>", msg, i+1)
			continue
		}*/
		flag, err := strconv.ParseInt(strings.TrimSpace(row[2]), 10, 0)
		if err != nil {
			msg = fmt.Sprintf("%s第%d行标识必须为数字<br>", msg, i+1)
			continue
		}
		if flag != 0 && flag != 1 {
			msg = fmt.Sprintf("%s第%d行标识必须为0或者1<br>", msg, i+1)
			continue
		}
		var tmpModel Ranking
		// 根据会员期数、排行榜类型和会员账号判断  会员信息是否已经存在，
		err1 := o.QueryTable(new(Ranking)).Filter("RankingType", rankingtype[str]).Filter("GameId", gameid).Filter("Period", period).Filter("Account", account).One(&tmpModel)
		if err1 != nil && err1 != orm.ErrNoRows {
			msg = fmt.Sprintf("%s第%d行数据错误，请重试<br>", msg, i+1)
			continue
		}
		if err1 == nil { // 如果存在将其id收集，后面进行删除，进行覆盖导入
			idsDel = append(idsDel, tmpModel.Id)
		}
		//查询活动是否存在
		bool := o.QueryTable(new(Game)).Filter("Id", gameid).Exist()
		if !bool {
			msg = fmt.Sprint("活动不存在，请先创建活动。")
		}
		periods, _ := utils.GetPeriodMap(gameid)
		model := Ranking{}
		period2 := int(period)
		model.Period = period
		model.PeriodString = periods[period2]
		model.Account = account
		model.Amount = amount
		model.GameId = gameid
		model.RankingType = rankingtype[str]
		/*model.Seq = seq*/
		model.RankingFlag = flag
		model.Creator = this.LoginAdminId
		model.Modifior = this.LoginAdminId
		model.CreateDate = time.Now()
		model.ModifyDate = time.Now()
		model.Version = 0
		models = append(models, model)
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
		return
	}
	if len(models) == 0 {
		msg = "导入表格为空，请确认"
		return
	}
	o.Begin()
	if len(idsDel) > 0 {
		idslen := len(idsDel)
		for i := 0; i <= idslen/1000; i++ {
			end := 0
			if (i+1)*1000 >= idslen {
				end = idslen
			} else {
				end = (i + 1) * 1000
			}
			tmpArr := idsDel[i*1000 : end]

			if _, err = o.QueryTable(new(Ranking)).Filter("Id__in", tmpArr).Delete(); err != nil {
				o.Rollback()
				msg = "导入失败，请重试"
				return
			}
		}
	}
	var susNums int64
	//将数组拆分导入，一次1000条
	mlen := len(models)
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
			beego.Error("memberlottery import, insert error", err)
			msg = "上传失败，请重试(2)"
			return
		} else {
			susNums += nums
		}
	}
	o.Commit()
	code = 1
	msg = fmt.Sprintf("成功导入%d条记录", susNums)
	return
}

type AddRankingController struct {
	sysmanage.BaseController
}

func (this *AddRankingController) Get() {
	beego.Informational("add ranking")
	gId, _ := this.GetInt64("gameId", 0)
	if gId == 0 {
		gId, _ = this.GetSession("currentGameId").(int64)
	}
	this.Data["gameList"] = GetGames("ranking")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/ranking/ranking/add.tpl"
}

func (this *AddRankingController) Post() {
	var code int
	var msg string
	url := beego.URLFor("RankingIndexController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	ranking := Ranking{}
	if err := this.ParseForm(&ranking); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&ranking); hasError {
		msg = errMsg
		return
	}
	periods, _ := utils.GetPeriodMap(ranking.GameId)
	period := int(ranking.Period)
	ranking.PeriodString = periods[period]
	ranking.Creator = this.LoginAdminId
	ranking.Modifior = this.LoginAdminId
	_, err1 := ranking.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert ranking error", err1)
	} else {
		code = 1
		msg = "添加成功"
		return
	}
}

type EditRankingController struct {
	sysmanage.BaseController
}

func (this *EditRankingController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	ranking := Ranking{BaseModel: BaseModel{Id: id}}
	err := o.Read(&ranking)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("RankingIndexController.get"), 302)
	} else {
		this.Data["data"] = ranking
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/ranking/ranking/edit.tpl"
	}
}
func (this *EditRankingController) Post() {
	var code int
	var msg string
	url := beego.URLFor("RankingIndexController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	ranking := Ranking{}
	if err := this.ParseForm(&ranking); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&ranking); hasError {
		msg = errMsg
		return
	}
	cols := []string{"RankingType", "Account", "Amount", "Seq", "Period", "RankingFlag", "PeriodString"}
	periods, _ := utils.GetPeriodMap(ranking.GameId)
	period := int(ranking.Period)
	ranking.PeriodString = periods[period]
	ranking.Modifior = this.LoginAdminId
	_, err := ranking.Update(cols...)
	if err != nil {
		msg = "更新失败"
		beego.Error("Updte ranking error", err)
	} else {
		code = 1
		msg = "更新成功"
	}
}
