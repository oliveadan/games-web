package common

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type IpLimitLog struct {
	Id      int64
	GameId  int64
	Ip      string
	Account string
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(IpLimitLog))
}

func (model *IpLimitLog) ReadOrCreate(col1 string, cols ...string) (bool, int64, error) {
	o := orm.NewOrm()
	return o.ReadOrCreate(model, col1, cols...)
}
