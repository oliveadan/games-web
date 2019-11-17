package gift

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Gift struct {
	BaseModel
	GameId        int64
	Seq           int
	Name          string
	Probability   int
	Quantity      int
	GiftType      int8
	Content       string
	Photo         string
	BroadcastFlag int8
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Gift))
}

func (model *Gift) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *Gift) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *Gift) Paginate(page int, limit int, gId int64) (list []Gift, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(Gift))
	qs = qs.Filter("GameId", gId)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("Probability", "Seq", "-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}

func GetGifts(gameId int64) []Gift {
	var list []Gift
	o := orm.NewOrm()
	_, err := o.QueryTable(new(Gift)).Filter("GameId", gameId).OrderBy("Seq").All(&list, "Id", "Seq", "Name")
	if err != nil {
		return nil
	}
	return list
}
