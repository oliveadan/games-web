package upgrading

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/models"
	"time"
)

type UpgradingWeek struct {
	BaseModel
	GameId        int64
	Account       string
	WeekAmount    int64
	RiseAmount    int64
	PeriodString  string
	Period        int64
	Delivered     int64
	DeliveredTime time.Time
	CountEnable   int
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(UpgradingWeek))
}

func (model *UpgradingWeek) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *UpgradingWeek) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *UpgradingWeek) Paginate(page int, limit int, gId int64, account string, totalamount string, period string, delivered int64, riseamount string, countstatus string) (list []UpgradingWeek, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	qs := o.QueryTable(new(UpgradingWeek))
	if account != "" {
		cond = cond.And("Account__contains", account)
	}
	if totalamount != "" {
		cond = cond.And("WeekAmount__exact", totalamount)
	}
	if period != "" {
		cond = cond.And("Period__exact", period)
	}
	if delivered != 2 {
		cond = cond.And("Delivered__exact", delivered)
	}
	if riseamount != "" {
		cond = cond.And("RiseAmount__gt", riseamount)
	}
	if countstatus != "" {
		cond = cond.And("CountEnable", countstatus)
	}
	qs = qs.SetCond(cond)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-RiseAmount", "-WeekAmount")
	qs.All(&list)
	total, _ = qs.Count()
	return
}

//获取周榜期数
func GetPeriods() []UpgradingWeek {
	var periods []UpgradingWeek
	o := orm.NewOrm()
	_, err := o.QueryTable(new(UpgradingWeek)).OrderBy("Period").GroupBy("Period").All(&periods, "Period", "PeriodString")
	if err != nil {
		return nil
	}
	return periods
}

//根据会员账号进行查询
func GetUpGradingWeeks(account string) []UpgradingWeek {
	var upgradingweek []UpgradingWeek
	o := orm.NewOrm()
	_, err := o.QueryTable(new(UpgradingWeek)).Filter("Account", account).OrderBy("-Period").All(&upgradingweek)
	if err != nil {
		return nil
	}
	return upgradingweek
}
