package monthsignin

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"time"
)

type MonthsigninLog struct {
	Id         int64
	GameId     int64
	Account    string
	SigninDate time.Time //签到天数
	GiftId     int64     //已领取奖励的总天数
	Status     int64     //0正常签到1补签
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(MonthsigninLog))
}
