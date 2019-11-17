package common

import (
	. "phage/models"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type ShareDetail struct {
	BaseModel
	GameId   int64
	ShareOut string
	ShareUse string
	Ip       string
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(ShareDetail))
}

func (model *ShareDetail) Paginate(page int, limit int, gId int64, shareOut string, timeStart string, timeEnd string) (list []ShareDetail, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(ShareDetail))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	if shareOut != "" {
		cond = cond.And("ShareOut__contains", shareOut)
	}
	if timeStart != "" {
		cond = cond.And("CreateDate__gte", timeStart)
	}
	if timeEnd != "" {
		cond = cond.And("CreateDate__lte", timeEnd)
	}
	qs = qs.SetCond(cond)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}
