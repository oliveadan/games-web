package ranking

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	. "phage/models"
	"time"
)

type RankingConfig struct {
	BaseModel
	GameId           int64
	MinRank          int64  //最小名次
	MaxRank          int64  //最大等级
	RankingType      int64  //榜单类型
	EffectiveBetting int64  //有效投注
	Prize            string //奖品
}

func init() {
	orm.RegisterModelWithPrefix(beego.AppConfig.String("mysqlpre"), new(RankingConfig))
}

func (model *RankingConfig) Create() (int64, error) {
	model.CreateDate = time.Now()
	model.ModifyDate = time.Now()
	model.Version = 0
	o := orm.NewOrm()
	return o.Insert(model)
}

func (model *RankingConfig) Update(cols ...string) (int64, error) {
	if cols != nil {
		cols = append(cols, "ModifyDate", "Modifior")
	}
	model.ModifyDate = time.Now()
	o := orm.NewOrm()
	return o.Update(model, cols...)
}

func (model *RankingConfig) Paginate(page int, limit int, gId int64, rankingtype int64) (list []RankingConfig, total int64) {
	if page < 1 {
		page = 1
	}
	offset := (page - 1) * limit
	o := orm.NewOrm()
	qs := o.QueryTable(new(RankingConfig))
	cond := orm.NewCondition()
	cond.And("GameId", gId)

	if rankingtype != 5 {
		cond = cond.And("RankingType", rankingtype)
	}
	qs = qs.SetCond(cond)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("-RankingType", "MinRank")
	qs.All(&list)
	total, _ = qs.Count()
	return
}

func GetRankingConfig(rankingtype int64) []RankingConfig {
	var rankingconfigs []RankingConfig
	o := orm.NewOrm()
	o.QueryTable(new(RankingConfig)).Filter("RankingType", rankingtype).OrderBy("MinRank").OrderBy("MinRank").All(&rankingconfigs)
	return rankingconfigs
}
