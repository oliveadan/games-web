package question

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/models"
	"time"
)

type QuestionscoreRanking struct {
	BaseModel
	GameId  int64
	Account string
	Score   int64
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(QuestionscoreRanking))
}

func (model *QuestionscoreRanking) ReadOrCreate(clo1 string, cols ...string) (bool, int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.ReadOrCreate(model, clo1, cols...)
}
