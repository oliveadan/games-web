package common

import (
	. "phage/models"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type Game struct {
	BaseModel
	GameVersion   int64
	Name          string
	Description   string
	Deleted       int8
	StartTime     time.Time
	EndTime       time.Time
	Enabled       int8
	Announcement  string
	BindDomain    string
	GameType      string
	GameRule      string
	GameStatement string
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(Game))
}

func GetGame(id int64) Game {
	model := Game{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	o.Read(&model)
	return model
}

func (model *Game) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *Game) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	//model.Version =
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *Game) Paginate(page int, limit int, gamtype string) (list []Game, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(Game))
	qs = qs.Filter("Deleted", 0)
	if gamtype != "" {
		qs = qs.Filter("GameType", gamtype)
	}
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-Id")
	qs.All(&list)
	total, _ = qs.Count()
	return
}

func GetGames(gtype ...string) []Game {
	var list []Game
	o := orm.NewOrm()
	qs := o.QueryTable(new(Game)).Filter("Deleted", 0)
	if len(gtype) > 0 {
		qs = qs.Filter("GameType__in", gtype)
	}
	qs = qs.OrderBy("-Id")
	_, err := qs.All(&list, "Id", "Name")
	if err != nil {
		return nil
	}
	return list
}
