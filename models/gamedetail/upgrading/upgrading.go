package upgrading

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"phage/models"
	"time"
)

type Upgrading struct {
	models.BaseModel
	GameId      int64
	Account     string
	TotalAmount int64
	Level       int64
	CurrentGift int64
	TotalGift   int64
	WeekSalary  int64
	MonthSalary int64
	Balance     int64
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Upgrading))
}

func (model *Upgrading) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *Upgrading) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *Upgrading) Paginate(page int, limit int, gId int64, account string, totalamount string, currentgift string) (list []Upgrading, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(Upgrading))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	if account != "" {
		cond = cond.And("Account__contains", account)
	}
	if totalamount != "" {
		cond = cond.And("TotalAmount__exact", totalamount)
	}
	if currentgift != "" {
		cond = cond.And("CurrentGift__gte", currentgift)
	}
	qs = qs.SetCond(cond)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-TotalAmount")
	qs.All(&list)
	total, _ = qs.Count()
	return
}

//根据会员账号进行查询
func GetUpGrading(account string) Upgrading {
	var upgrading Upgrading
	o := orm.NewOrm()
	o.QueryTable(new(Upgrading)).Filter("Account", account).One(&upgrading)
	return upgrading
}
