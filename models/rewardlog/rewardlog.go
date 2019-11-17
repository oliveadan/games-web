package rewardlog

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type RewardLog struct {
	BaseModel
	GameId        int64
	Deleted       int
	Account       string
	GiftId        int64
	Category      int64
	GiftName      string
	GiftContent   string
	Delivered     int8
	DeliveredTime time.Time
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(RewardLog))
}

func (model *RewardLog) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *RewardLog) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *RewardLog) Paginate(page int, limit int, gId int64, account string, timeStart string, timeEnd string, delivered int8, deleted int) (list []RewardLog, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(RewardLog))
	cond := orm.NewCondition()
	cond = cond.And("GameId", gId)
	cond = cond.And("Deleted", deleted)
	if account != "" {
		cond = cond.And("Account__contains", account)
	}
	if timeStart != "" {
		cond = cond.And("CreateDate__gte", timeStart)
	}
	if timeEnd != "" {
		cond = cond.And("CreateDate__lte", timeEnd)
	}
	if delivered != 2 {
		cond = cond.And("Delivered", delivered)
	}
	qs = qs.SetCond(cond)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}
