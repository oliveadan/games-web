package rich

import (
	"fmt"
	. "games-web/models/common"
	"games-web/utils"
	"html/template"
	"os"
	"phage/controllers/sysmanage"
	. "phage/models"
	. "phage/utils"
	"strconv"
	"strings"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
)

type RichAttributeIndexController struct {
	sysmanage.BaseController
}

func (this *RichAttributeIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *RichAttributeIndexController) Get() {
	beego.Informational("query rich attribute ")
	gId, _ := this.GetInt64("gameId", 0)
	if gId == 0 {
		gId, _ = this.GetSession("currentGameId").(int64)
	}
	var list []GameAttribute
	o := orm.NewOrm()
	o.QueryTable(new(GameAttribute)).Filter("GameId", gId).OrderBy("Code").All(&list, "Code", "Value")
	var m = make(map[string]string)
	var photoMap = make(map[string]string)
	for _, v := range list {
		if v.Code == utils.Richbackstep || v.Code == utils.Richtotalstage || v.Code == utils.Richunplayday || v.Code == utils.Richrate {
			if v.Code == utils.Richrate {
				rates := strings.Split(v.Value, ",")
				for i, rate := range rates {
					m[fmt.Sprintf("rate%d", i+1)] = rate
				}
			} else {
				m[v.Code] = v.Value
			}
		} else {
			photoMap[v.Code] = v.Value
		}
	}
	// 返回值
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.Data["gameList"] = GetGames("rich")
	this.Data["dataMap"] = m
	this.Data["photoMap"] = photoMap
	this.TplName = "gamedetail/rich/richattribute/index.tpl"
}

func (this *RichAttributeIndexController) Post() {
	// 上传背景图，放在这里省的再加个路由，还要配置权限
	if this.GetString("isUpload") == "Y" {
		beego.Info("rich attribute upload")
		this.upload()
		return
	}

	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, err := this.GetInt64("GameId", 0)
	if err != nil {
		msg = "活动获取失败，请刷新后重试"
		return
	}
	// 总关卡数
	totalstage, err := this.GetInt64(utils.Richtotalstage, 0)
	if err != nil {
		msg = "总步数必须为数字"
		return
	}
	// 未参与活动天数
	unplayday, err := this.GetInt64(utils.Richunplayday)
	if err != nil {
		msg = "未参与活动天数必须为数字"
		return
	}
	// 退步的步数
	backstep, err := this.GetInt64(utils.Richbackstep)
	if err != nil {
		msg = "退步数必须为数字"
		return
	}
	// 点数概率
	rate1, err := this.GetInt64("rate1", 0)
	if err != nil || rate1 < 0 || rate1 > 100 {
		msg = "点数概率必须为 0-100 的数字"
		return
	}
	rate2, err := this.GetInt64("rate2", 0)
	if err != nil || rate2 < 0 || rate2 > 100 {
		msg = "点数概率必须为 0-100 的数字"
		return
	}
	rate3, err := this.GetInt64("rate3", 0)
	if err != nil || rate3 < 0 || rate3 > 100 {
		msg = "点数概率必须为 0-100 的数字"
		return
	}
	rate4, err := this.GetInt64("rate4", 0)
	if err != nil || rate4 < 0 || rate4 > 100 {
		msg = "点数概率必须为 0-100 的数字"
		return
	}
	rate5, err := this.GetInt64("rate5", 0)
	if err != nil || rate5 < 0 || rate5 > 100 {
		msg = "点数概率必须为 0-100 的数字"
		return
	}
	rate6, err := this.GetInt64("rate6", 0)
	if err != nil || rate6 < 0 || rate6 > 100 {
		msg = "点数概率必须为 0-100 的数字"
		return
	}

	o := orm.NewOrm()
	o.Begin()

	qs := o.QueryTable(new(GameAttribute)).Filter("GameId", gId)
	qs = qs.Filter("Code__in", utils.Richtotalstage, utils.Richunplayday, utils.Richbackstep, utils.Richrate)
	if _, err := qs.Delete(); err != nil {
		o.Rollback()
		msg = "保存失败，请重试(1)"
		return
	}
	models := []GameAttribute{
		{BaseModel: BaseModel{Creator: this.LoginAdminId,
			Modifior:   this.LoginAdminId,
			CreateDate: time.Now(),
			ModifyDate: time.Now()},
			GameId: gId,
			Code:   utils.Richtotalstage,
			Value:  strconv.FormatInt(totalstage, 10)},
		{BaseModel: BaseModel{Creator: this.LoginAdminId,
			Modifior:   this.LoginAdminId,
			CreateDate: time.Now(),
			ModifyDate: time.Now()},
			GameId: gId,
			Code:   utils.Richunplayday,
			Value:  strconv.FormatInt(unplayday, 10)},
		{BaseModel: BaseModel{Creator: this.LoginAdminId,
			Modifior:   this.LoginAdminId,
			CreateDate: time.Now(),
			ModifyDate: time.Now()},
			GameId: gId,
			Code:   utils.Richbackstep,
			Value:  strconv.FormatInt(backstep, 10)},
		{BaseModel: BaseModel{Creator: this.LoginAdminId,
			Modifior:   this.LoginAdminId,
			CreateDate: time.Now(),
			ModifyDate: time.Now()},
			GameId: gId,
			Code:   utils.Richrate,
			Value:  fmt.Sprintf("%d,%d,%d,%d,%d,%d", rate1, rate2, rate3, rate4, rate5, rate6)}}
	if _, err := o.InsertMulti(4, models); err != nil {
		o.Rollback()
		msg = "保存失败, 请重试(2)"
		return
	} else {
		o.Commit()
		this.SetSession("currentGameId", gId)
		code = 1
		msg = "保存成功"
		return
	}
}

func (this *RichAttributeIndexController) upload() {
	var code int
	var msg string
	var uploadName string
	var data = make(map[string]string)
	defer sysmanage.Retjson(this.Ctx, &msg, &code, data)
	gId, err := this.GetInt64("GameId", 0)
	if err != nil {
		msg = "活动获取失败，请刷新后重试"
		return
	}
	if gId == 0 {
		msg = "请先选择活动"
		return
	}
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("RichAttribute upload file get file error", err)
		msg = "上传失败，请重试(1)"
		return
	} else {
		fname := h.Filename
		part := SubString(fname, 0, 1)
		if part != "a" && part != "b" {
			msg = "文件名错误，请参考命名规则(1)"
			return
		}
		stage := SubString(fname, 1, strings.LastIndex(fname, ".")-1)
		if _, err := strconv.ParseInt(stage, 10, 64); err != nil {
			msg = "文件名错误，请参考命名规则(2)"
			return
		}

		suffix := SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
		uploadPath := fmt.Sprintf("upload/%d/%s/%d/", time.Now().Year(), time.Now().Month().String(), time.Now().Day())
		if flag, _ := PathExists(uploadPath); !flag {
			if err2 := os.MkdirAll(uploadPath, 0644); err2 != nil {
				beego.Error("RichAttribute upload file get file error", err2)
				msg = "上传失败，请重试(2)"
				return
			}
		}

		uploadName = uploadPath + strconv.FormatInt(time.Now().UnixNano(), 10) + suffix
		err3 := this.SaveToFile("file", uploadName)
		if err3 != nil {
			beego.Error("RichAttribute upload file save file error2", err3)
			msg = "上传失败，请重试(3)"
			return
		}
		// 上传成功后，直接修改数据库
		uploadName = "/" + uploadName
		gaCode := part + stage
		ga := GameAttribute{BaseModel: BaseModel{
			Creator:    this.LoginAdminId,
			Modifior:   this.LoginAdminId,
			CreateDate: time.Now(),
			ModifyDate: time.Now(),
			Version:    0},
			GameId: gId,
			Code:   gaCode,
			Value:  uploadName}
		o := orm.NewOrm()
		if created, _, err := o.ReadOrCreate(&ga, "GameId", "Code"); err == nil {
			// 要更新
			if !created {
				ga.Value = uploadName
				o.Update(&ga, "Value")
			}
		} else {
			msg = "数据更新失败，请重试"
			return
		}
		code = 1
		msg = "上传成功"
		data["stage"] = stage
		data["part"] = part
		data["path"] = uploadName
	}
}
