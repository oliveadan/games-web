package monthsignin

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/models"
	"time"
)

type MonthsigninBet struct {
	BaseModel
	GameId     int64
	Account    string
	Bet        int64
	SurplusBet int64
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(MonthsigninBet))
}

func (model *MonthsigninBet) ReadOrCreate(col1 string, cols ...string) (bool, int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.ReadOrCreate(model, col1, cols...)
}

func (model *MonthsigninBet) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *MonthsigninBet) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *MonthsigninBet) Paginate(page int, limit int, gId int64, account string) (list []MonthsigninBet, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(MonthsigninBet))
	qs = qs.Filter("GameId", gId)
	if account != "" {
		qs = qs.Filter("Account__contains", account)
	}
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Bet")
	qs.All(&list)
	total, _ = qs.Count()
	return
}
