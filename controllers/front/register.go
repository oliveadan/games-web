package front

import (
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	"html/template"
	"net/http"
	"phage-games-web/models/common"
	"phage-games-web/utils"
	"phage/models"
	"phage/models/system"
	. "phage/utils"
	"phagego/plugins/platform/regist"
	"time"
)

func validateReg(model *regist.RegParam) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(model.Account, "errmsg").Message("用户名必填")
	valid.MinSize(model.Account, 6, "errmsg").Message("用户名最少6个字符")
	valid.MaxSize(model.Account, 12, "errmsg").Message("用户名最长12个字符")
	valid.AlphaNumeric(model.Account, "errmsg").Message("用户名只能为字母或数字")
	valid.Required(model.Password, "errmsg").Message("密码必填")
	valid.MinSize(model.Password, 6, "errmsg").Message("密码最少6个字符")
	valid.MaxSize(model.Password, 16, "errmsg").Message("密码最长16个字符")
	valid.AlphaNumeric(model.Password, "errmsg").Message("密码只能为字母或数字")
	//valid.Required(model.RealName, "errmsg").Message("中文全名必填")
	//valid.MinSize(model.RealName, 2, "errmsg").Message("中文全名最少2个字")
	valid.MaxSize(model.RealName, 12, "errmsg").Message("中文全名最长12个字")
	valid.Required(model.Mobile, "errmsg").Message("手机号必填")
	valid.Mobile(model.Mobile, "errmsg").Message("手机号格式错误")
	//valid.Required(model.WithdrawPass, "errmsg").Message("取款密码必填")
	valid.AlphaNumeric(model.WithdrawPass, "errmsg").Message("取款密码包含非法字符")
	//valid.Numeric(model.WithdrawPass, "errmsg").Message("取款密码必须为4位数字")
	//valid.Length(model.WithdrawPass, 4, "errmsg").Message("取款密码必须为4位数字")
	if model.QqNo != "" {
		valid.Numeric(model.QqNo, "errmsg").Message("QQ号必须为数字")
	}
	if model.WxNo != "" {
		valid.AlphaNumeric(model.WxNo, "errmsg").Message("微信号格式错误")
	}
	if model.Email != "" {
		valid.Email(model.Email, "errmsg").Message("邮箱格式错误")
	}
	if model.Question != "" {
		valid.Required(model.Answer, "errmsg").Message("提示答案必填")
		valid.MaxSize(model.Answer, 20, "errmsg").Message("提示答案最长20个字")
	}

	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	if model.RePassword != "" && model.Password != model.RePassword {
		return true, "两次输入的密码不一致"
	}
	return false, ""
}

type RegisterController struct {
	beego.Controller
}

func (c *RegisterController) Get() {
	tpl := c.GetString("tpl")
	c.Data["xsrfdata"] = template.HTML(c.XSRFFormHTML())
	c.TplName = "front/register/" + tpl + ".tpl"
}

func (c *RegisterController) Post() {
	var msg string
	var code int
	var redirect = c.GetString("redirect")
	defer func() {
		var returnUrl string
		if code == 1 && redirect != "" {
			returnUrl = "location.href='" + redirect + "';"
		} else {
			returnUrl = "history.go(-1)"
		}
		c.Ctx.ResponseWriter.Write([]byte("<script>alert(\"" + msg + "\"); " + returnUrl + "</script>"))
	}()
	if !GetCpt().VerifyReq(c.Ctx.Request) {
		msg = "验证码错误"
		return
	}
	model := regist.RegParam{}
	if err := c.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validateReg(&model); hasError {
		msg = errMsg
		return
	}
	o := orm.NewOrm()
	if exists := o.QueryTable(new(common.Member)).Filter("Account", model.Account).Exist(); exists {
		msg = "当前用户名已被注册"
		return
	}
	sc := system.GetSiteConfigMap(utils.Scplatformtype, utils.Scregister, utils.Scplatformreg)
	reg := regist.PlatformRegister{
		PlatformType: sc[utils.Scplatformtype],
		PlatformName: sc[utils.Scplatformreg],
		ReqUrl:       sc[utils.Scregister],
		ReqMethod:    http.MethodPost,
	}
	ok, msg := reg.Regist(&model)
	if !ok {
		return
	}
	member := common.Member{
		BaseModel: models.BaseModel{
			Creator:    0,
			Modifior:   0,
			CreateDate: time.Now(),
			ModifyDate: time.Now(),
			Version:    0,
		},
		Account:      model.Account,
		Name:         model.RealName,
		Mobile:       model.Mobile,
		Flag:         1,
		ReferrerCode: model.Upline,
		RegIp:        c.Ctx.Input.IP(),
	}
	if _, err := o.Insert(&member); err != nil {
		msg = "注册失败，请重试"
		return
	}
	code = 1
	msg = "注册成功！请参加活动吧！"
	return
}
