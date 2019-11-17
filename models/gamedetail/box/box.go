package box

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Box struct {
	Id           int64
	GameId       int64
	BronzeboxId  int64
	SilverboxId  int64
	GoldboxId    int64
	ExtremeboxId int64
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Box))
}

func (model *Box) Create() (int64, error) {
	o := orm.NewOrm()
	return o.Insert(model)
}

func GetBoxs() []Box {
	var list []Box
	o := orm.NewOrm()
	o.QueryTable(new(Box)).OrderBy("-Id").All(&list)
	return list
}
