package seckillandrush

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type SeckillAndRush struct {
	Id        int64
	SeckillId int64
	RushId    int64
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(SeckillAndRush))
}

func (model *SeckillAndRush) Create() (int64, error) {
	o := orm.NewOrm()
	return o.Insert(model)
}

func GetSeckillAndRush() []SeckillAndRush {

	var list []SeckillAndRush
	o := orm.NewOrm()
	o.QueryTable(new(SeckillAndRush)).OrderBy("-Id").All(&list)
	return list
}
