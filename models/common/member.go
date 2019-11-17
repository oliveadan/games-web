package common

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Member struct {
	BaseModel
	Account        string
	Name           string
	Mobile         string
	Level          int
	LevelName      string
	Force          int
	LastSigninDate time.Time
	Flag           int
	RegIp          string // 注册ip
	InvitationCode string // 邀请码、推荐码
	ReferrerCode   string // 推荐人的码
	Dynamic        int64  // 活力值
	SignEnable     int64  // 签到标识 0不可以签到，1可以签到
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Member))
}

func (model *Member) ReadOrCreate(col1 string, cols ...string) (bool, int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.ReadOrCreate(model, col1, cols...)
}

func (model *Member) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *Member) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *Member) Paginate(page int, limit int, param1 string) (list []Member, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(Member))
	cond := orm.NewCondition()
	if param1 != "" {
		cond = cond.AndCond(cond.And("Account__contains", param1).Or("Name__contains", param1).Or("Mobile__contains", param1))
		qs = qs.SetCond(cond)
	}
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}
