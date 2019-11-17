package common

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Thumbs struct {
	Id      int64
	GameId  int64
	Account string
	Ip      string
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Thumbs))
}
