package questapi

import (
	"html"
	"html/template"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/question"
	. "phage/utils"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type QuestApiController struct {
	beego.Controller
}

func (this *QuestApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)
	// 问卷内容
	var list []Question
	o := orm.NewOrm()
	o.QueryTable(new(Question)).Filter("GameId", gId).OrderBy("Pid", "Seq", "Id").All(&list)

	this.Data["questList"] = list
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/quest/index-wap.tpl"
	} else {
		this.TplName = "front/quest/index-pc.tpl"
	}
}

func (this *QuestApiController) Post() {
	var code int
	var msg string
	defer func() {
		var gameId int64
		SetGameData(&this.Controller, &gameId)
		this.Data["code"] = *(&code)
		this.Data["msg"] = &msg
		if IsWap(this.Ctx.Input.UserAgent()) {
			this.TplName = "front/quest/info-wap.tpl"
		} else {
			this.TplName = "front/quest/info-pc.tpl"
		}
	}()

	gId, err := this.GetInt64("gid", 0)
	var inputMap = this.Input()
	if err != nil || gId == 0 {
		msg = "问卷获取失败，请返回后刷新重试"
		return
	}

	o := orm.NewOrm()
	// 活动情况校验
	var game Game
	err = o.QueryTable(new(Game)).Filter("Id", gId).One(&game, "Deleted", "Enabled", "StartTime", "EndTime")
	if err != nil {
		beego.Error("Lotterycontroller error", err)
		msg = "问卷活动获取错误，请刷新后重试(2)"
		return
	}
	if game.Deleted != 0 || game.Enabled != 1 {
		msg = "问卷活动已停止！"
		return
	}
	if game.StartTime.After(time.Now()) {
		msg = "问卷活动将于" + game.StartTime.Format("2006-01-02 15:04:05") + "开启，敬请关注！"
		return
	}
	if game.EndTime.Before(time.Now()) {
		msg = "问卷活动已结束！"
		return
	}

	var qaList []QuestionAnswer
	var opts []string
	for k, v := range inputMap {
		if len(v) == 0 || k == "gid" || k == "_xsrf" {
			continue
		}
		// 选择题
		if strings.HasPrefix(k, "option") {
			opts = append(opts, v...)
		} else {
			qa := QuestionAnswer{}
			qa.Content = k + "," + html.EscapeString(v[0])
			qa.ContentType = 2
			qaList = append(qaList, qa)
		}
	}
	if len(opts) > 0 {
		qa := QuestionAnswer{}
		qa.Content = strings.Join(opts, ",")
		qa.ContentType = 1
		qaList = append(qaList, qa)
	}
	if len(qaList) == 0 {
		msg = "问卷提交失败，请返回重试"
		return
	}

	qa := QuestionAnswer{}
	qa.Creator = 0
	qa.Modifior = 0
	qa.CreateDate = time.Now()
	qa.ModifyDate = time.Now()
	qa.Version = 0
	qa.GameId = gId
	qa.Pid = 0
	qa.Content = html.EscapeString(this.Ctx.Input.IP())
	qa.ContentType = 0

	// 验证是否已提交
	isExist := o.QueryTable(new(QuestionAnswer)).Filter("GameId", gId).Filter("Pid", 0).Filter("Content", qa.Content).Exist()
	if isExist {
		code = 1
		msg = "您的问卷已提交，请勿重复提交！"
		return
	}
	o.Begin()
	id, err := o.Insert(&qa)
	if err != nil {
		o.Rollback()
		msg = "提交失败，请返回重试(1)"
		return
	}
	for i := 0; i < len(qaList); i++ {
		qaList[i].Creator = 0
		qaList[i].Modifior = 0
		qaList[i].CreateDate = time.Now()
		qaList[i].ModifyDate = time.Now()
		qaList[i].Version = 0
		qaList[i].GameId = gId
		qaList[i].Pid = id
	}
	if _, err = o.InsertMulti(len(qaList), &qaList); err != nil {
		o.Rollback()
		msg = "提交失败，请返回重试(2)"
		return
	}
	o.Commit()
	code = 1
	msg = "问卷到此结束，感谢您的参与！"
}
