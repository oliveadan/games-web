package common

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type GameAttribute struct {
	BaseModel
	GameId int64
	Code   string
	Value  string
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(GameAttribute))
}

func (model *GameAttribute) ReadOrCreate(col1 string, cols ...string) (bool, int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.ReadOrCreate(model, col1, cols...)
}

func (model *GameAttribute) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *GameAttribute) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func GetGameAttributes(gId int64) []GameAttribute {
	var gaList []GameAttribute
	o := orm.NewOrm()
	o.QueryTable(new(GameAttribute)).Filter("GameId", gId).All(&gaList, "Id", "GameId", "Code", "Value")
	return gaList
}
