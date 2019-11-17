package question

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type QuestionAnswer struct {
	BaseModel
	GameId      int64
	Pid         int64
	Content     string
	ContentType int
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(QuestionAnswer))
}

func (model *QuestionAnswer) ReadOrCreate(col1 string, cols ...string) (bool, int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.ReadOrCreate(model, col1, cols...)
}

func (model *QuestionAnswer) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *QuestionAnswer) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *QuestionAnswer) Paginate(page int, limit int) (list []QuestionAnswer, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(QuestionAnswer))
	qs = qs.Filter("Pid", 0)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}
