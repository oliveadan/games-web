package common

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type GamePeriod struct {
	BaseModel
	GameId    int64
	StartTime string
	EndTime   string
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(GamePeriod))
}

func (model *GamePeriod) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *GamePeriod) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func GetGamePeriod(id int64) []GamePeriod {
	var list []GamePeriod
	o := orm.NewOrm()
	_, err := o.QueryTable(new(GamePeriod)).Filter("GameId", id).OrderBy("StartTime").All(&list)
	if err != nil {
		return nil
	}
	return list
}
