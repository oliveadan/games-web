package upgrading

import (
	"fmt"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/models"
	"time"
)

type UpgradingConfig struct {
	BaseModel
	GameId      int64
	Level       int64
	TotalAmount int64
	LevelGift   int64
	WeekAmount  int64
	MonthAmount int64
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(UpgradingConfig))
}
func GetUpgradingConfigs(gid int64) []UpgradingConfig {
	var list []UpgradingConfig
	o := orm.NewOrm()
	o.QueryTable(new(UpgradingConfig)).Filter("GameId", gid).OrderBy("-TotalAmount").All(&list)
	return list
}
func (model *UpgradingConfig) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *UpgradingConfig) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *UpgradingConfig) Paginate(page int, limit int, gId int64) (list []UpgradingConfig, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(UpgradingConfig)).Filter("GameId", gId)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}

func GetGift(amount int64, gid int64) int64 {
	upgradingconfigs := GetUpgradingConfigs(gid)
	for _, v := range upgradingconfigs {
		if v.TotalAmount < amount {
			fmt.Println()
			return v.LevelGift
		}
	}
	return 0
}
