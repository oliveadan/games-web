package ranking

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/models"
	. "phage/utils"
	"sort"
	"strconv"
	"time"
)

type Ranking struct {
	BaseModel
	GameId        int64
	RankingType   int64     //类型0:周排行;1:月排行;2:幸运榜;3:总榜;
	Account       string    //会员账号
	Amount        int64     //有效投注
	Seq           int64     //排名
	Period        int64     //期数;月份
	PeriodString  string    //字符串形式显示期数
	RankingFlag   int64     //真假会员标识
	Prize         string    //奖品
	Delivered     int8      //是否派送
	DeliveredTime time.Time //派送时间
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Ranking))
}

//插入
func (model *Ranking) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

//更新
func (model *Ranking) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

//分页信息展示
func (model *Ranking) Paginate(page int, limit int, gId int64, rankingType int64, account string, amount string, period string, rankingflag string, delivered int8) (list []Ranking, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(Ranking))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	cond = cond.And("RankingType", rankingType)
	if account != "" {
		cond = cond.And("Account", account)
	}
	if amount != "" {
		cond = cond.And("Amount", amount)
	}

	if rankingType != 3 {
		if period != "" {
			cond = cond.And("Period", period)
		}
	}
	if rankingflag != "" {
		cond = cond.And("RankingFlag", rankingflag)
	}
	if delivered != 2 {
		cond = cond.And("Delivered", delivered)
	}
	qs = qs.SetCond(cond)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Period", "-Amount")
	qs.All(&list)
	total, _ = qs.Count()
	return
}

//根据类型获取期数
func GetPeriods(gameid int64, rankingtype int64) ([]Ranking, string) {
	var str string
	if rankingtype == 1 {
		str = "月"
	}
	var list []Ranking
	o := orm.NewOrm()
	_, err := o.QueryTable(new(Ranking)).Filter("GameId", gameid).Filter("RankingType", rankingtype).Distinct().OrderBy("Period").All(&list, "Period", "RankingType", "PeriodString")
	if err != nil {
		return nil, str
	}

	return list, str
}

//获取对应类型行期数
func GetAllPeriods(i int64) []Ranking {
	var list []Ranking
	o := orm.NewOrm()
	_, err := o.QueryTable(new(Ranking)).Filter("RankingType", i).Distinct().OrderBy("Period").All(&list, "Period")
	if err != nil {
		return nil
	}
	return list
}

//获取月排行期数
func GetMonthPeriod() []Ranking {
	var list []Ranking
	o := orm.NewOrm()
	_, err := o.QueryTable(new(Ranking)).Filter("RankingType", 1).Distinct().OrderBy("Period").All(&list, "Period")
	if err != nil {
		return nil
	}
	return list
}

//获取幸运排行期数
func GetLuckyPeriod() []Ranking {
	var list []Ranking
	o := orm.NewOrm()
	_, err := o.QueryTable(new(Ranking)).Filter("RankingType", 2).Distinct().OrderBy("Period").All(&list, "Period")
	if err != nil {
		return nil
	}
	return list
}

//根据活动类型和期数进行查询
func GetTypeAndPeriod(gid int64, rankingType int64, period int64) (rankings []Ranking) {
	var list []Ranking
	o := orm.NewOrm()
	_, err := o.QueryTable(new(Ranking)).Filter("GameId", gid).Filter("RankingType", rankingType).Filter("Period", period).OrderBy("Seq").Limit(100).All(&list)
	if err != nil {
		return nil
	}
	for i, v := range list {
		str1 := SubString(v.Account, 0, 2)
		len := len(v.Account)
		if len <= 3 {
			str2 := str1 + "***" + str1
			v.Account = str2
		} else {
			str2 := SubString(v.Account, len-3, len-1)
			v.Account = str1 + "***" + str2
		}

		list[i] = v
	}
	return list
}

//获取总榜信息
func GetTotals(gid int64) (totals []Ranking) {
	var total []Ranking
	o := orm.NewOrm()
	o.QueryTable(new(Ranking)).Filter("GameId", gid).Filter("RankingType", 3).OrderBy("Seq").Limit(100).All(&total)
	for i, v := range total {
		str1 := SubString(v.Account, 0, 2)
		len := len(v.Account)
		if len <= 3 {
			str2 := str1 + "***" + str1
			v.Account = str2
		} else {
			str2 := SubString(v.Account, len-3, len-1)
			v.Account = str1 + "***" + str2
		}

		total[i] = v
	}
	return total
}

//根据会员账号进行查询
func QueryByAccount(gid int64, account string) (all Ranking, w []Ranking, m []Ranking) {
	//会员的总榜信息
	var total Ranking
	//会员的的周榜信息
	week := make([]Ranking, 0)
	//会员的月榜信息
	month := make([]Ranking, 0)
	o := orm.NewOrm()
	//判断会员是否是假会员
	var flag Ranking
	o.QueryTable(new(Ranking)).Filter("GameId", gid).Filter("Account", account).One(&flag)
	//如果是虚拟会员，所有返回为空
	if flag.RankingFlag == 1 {
		return total, week, month
	}

	/*//获取总榜
	totalall :=GetTotal1()
	//遍历总榜查询是否存在会员信息
	for i,v := range totalall{
		if v.Account == account{
			total.Account = v.Account
			total.Amount  = v.Amount
			j,_ := strconv.ParseInt(fmt.Sprintf("%d",i+1),10,64)
			total.Seq = j
			break
		}
	}*/
	o.QueryTable(new(Ranking)).Filter("GameId", gid).Filter("Account", account).Filter("RankingType", 0).All(&week)
	o.QueryTable(new(Ranking)).Filter("GameId", gid).Filter("Account", account).Filter("RankingType", 1).All(&month)
	o.QueryTable(new(Ranking)).Filter("GameId", gid).Filter("Account", account).Filter("RankingType", 3).All(&total)
	return total, week, month
}

//结构体排序方法
type RankingWrapper struct {
	Ranking []Ranking
	by      func(p, q *Ranking) bool
}
type SortBy func(p, q *Ranking) bool

func (aw RankingWrapper) Len() int {
	return len(aw.Ranking)
}
func (aw RankingWrapper) Swap(i, j int) {
	aw.Ranking[i], aw.Ranking[j] = aw.Ranking[j], aw.Ranking[i]
}
func (aw RankingWrapper) Less(i, j int) bool {
	return aw.by(&aw.Ranking[i], &aw.Ranking[j])
}
func SortRanking(Ranking []Ranking, by SortBy) {
	sort.Sort(RankingWrapper{Ranking, by})
}

//当活动类型是总榜的时候用此方法，会员经过处理
func Paginate2(str string) (list []Ranking, total int64) {
	o := orm.NewOrm()
	o.QueryTable(new(Ranking)).Filter("RankingType", 0).All(&list)
	models := make([]Ranking, 0)
	allmap := make(map[string]int64)
	//利用map对总榜数据进行筛选
	for _, v := range list {
		_, ok := allmap[v.Account]
		if ok {
			allmap[v.Account] = allmap[v.Account] + v.Amount
		} else {
			allmap[v.Account] = v.Amount
		}
	}
	//筛选完成后放入新的切片
	for v := range allmap {
		model := Ranking{}
		model.Account = v
		model.Amount = allmap[v]
		model.RankingType = 3
		models = append(models, model)
	}
	//添加会员标识
	for _, v := range list {
		for j, h := range models {
			if v.Account == h.Account {
				h.RankingFlag = v.RankingFlag
				models[j] = h
			}
		}
	}
	total, _ = strconv.ParseInt(fmt.Sprintf("%d", len(models)), 10, 64)

	//对新的切片根据投注金额进行排序
	sort.Sort(RankingWrapper{models, func(p, q *Ranking) bool {
		return q.Amount < p.Amount
	}})
	if str == "后台" {
		for i, v := range models {
			j, _ := strconv.ParseInt(fmt.Sprintf("%d", i+1), 10, 64)
			v.Seq = j
			models[i] = v
		}
		return models, total
	}
	//将排序后的切片中的会员账号进行处理
	for i, v := range models {
		str1 := SubString(v.Account, 0, 2)
		len := len(v.Account)
		str2 := SubString(v.Account, len-3, len-1)
		v.Account = str1 + "***" + str2
		j, _ := strconv.ParseInt(fmt.Sprintf("%d", i+1), 10, 64)
		v.Seq = j
		models[i] = v
	}
	if len(models) < 100 {
		total, _ = strconv.ParseInt(fmt.Sprintf("%d", len(models)), 10, 64)
		return models, total
	}

	//取前100条数据
	models = models[:100]
	//总条数等于新切片的长度
	return models, total
}

//获取会员账号没有处理的总榜信息
func GetTotal() (list []Ranking) {
	o := orm.NewOrm()
	o.QueryTable(new(Ranking)).Filter("RankingType", 0).All(&list)
	models := make([]Ranking, 0)
	allmap := make(map[string]int64)
	//利用map对总榜数据进行筛选
	for _, v := range list {
		_, ok := allmap[v.Account]
		if ok {
			allmap[v.Account] = allmap[v.Account] + v.Amount
		} else {
			allmap[v.Account] = v.Amount
		}
	}
	//筛选完成后放入新的切片
	for v := range allmap {
		model := Ranking{}
		model.Account = v
		model.Amount = allmap[v]
		model.RankingType = 3
		models = append(models, model)
	}
	//对新的切片根据投注金额进行排序
	sort.Sort(RankingWrapper{models, func(p, q *Ranking) bool {
		return q.Amount < p.Amount
	}})
	return models
}
