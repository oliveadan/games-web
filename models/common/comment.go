package common

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Comment struct {
	BaseModel
	GameId  int64
	Account string
	Mobile  string
	Content string
	Thumbs  int
	Tag     int
	Status  int
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Comment))
}

func (model *Comment) ReadOrCreate(col1 string, cols ...string) (bool, int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.ReadOrCreate(model, col1, cols...)
}

func (model *Comment) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *Comment) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *Comment) Paginate(page int, limit int, gId int64, account string, orderFiled string, enabled int8) (list []Comment, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(Comment))
	qs = qs.Filter("GameId", gId)
	if account != "" {
		qs = qs.Filter("Account__contains", account)
	}
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	if enabled != 9 {
		qs = qs.Filter("Enabled", enabled)
	}
	if orderFiled == "1" {
		qs = qs.OrderBy("-Id")
	} else if orderFiled == "2" {
		qs = qs.OrderBy("Id")
	} else if orderFiled == "3" {
		qs = qs.OrderBy("-Thumbs", "-Id")
	} else {
		qs = qs.OrderBy("-Id")
	}
	qs.All(&list)
	total, _ = qs.Count()
	return
}

func (model *Comment) PaginateFront(page int, limit int, gId int64) (list []Comment, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(Comment))
	qs = qs.Filter("GameId", gId)
	qs = qs.Filter("Status", 1)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-tag", "-Id")
	qs.All(&list, "Id", "Account", "Content", "Thumbs", "Tag", "CreateDate")
	total, _ = qs.Count()
	return
}
