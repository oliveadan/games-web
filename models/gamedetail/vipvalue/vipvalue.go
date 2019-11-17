package vipvalue

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"phage/models"
	"time"
)

type VipValue struct {
	models.BaseModel
	GameId       int64
	Account      string
	VipLevel     int64
	RegisterDate time.Time
	RegisterDays int64
	Value        string
	GetEnable    int64
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(VipValue))
}

func (model *VipValue) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *VipValue) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *VipValue) Paginate(page int, limit int, gId int64) (list []VipValue, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(VipValue))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)

	qs = qs.SetCond(cond)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs.All(&list)
	total, _ = qs.Count()
	return
}
