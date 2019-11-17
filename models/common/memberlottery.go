package common

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type MemberLottery struct {
	BaseModel
	GameId      int64
	Account     string
	LotteryNums int
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(MemberLottery))
}

func (model *MemberLottery) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *MemberLottery) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *MemberLottery) Paginate(page int, limit int, gId int64, account string) (list []MemberLottery, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(MemberLottery))
	qs = qs.Filter("GameId", gId)
	if account != "" {
		qs = qs.Filter("Account__contains", account)
	}
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-ModifyDate", "-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}
