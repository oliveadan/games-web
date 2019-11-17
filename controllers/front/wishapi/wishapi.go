package wishapi

import (
	"html"
	. "phage-games-web/controllers/front"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/wish"
	. "phage/models"
	. "phage/utils"
	"strings"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/validation"
	"regexp"
)

type WishApiController struct {
	beego.Controller
}

func (this *WishApiController) Prepare() {
	this.EnableXSRF = false
}

// 首页
func (this *WishApiController) Get() {
	gId, _ := this.GetInt64("gid", 0)

	SetGameData(&this.Controller, &gId)

	// 愿望列表
	var wishList []Wish
	o := orm.NewOrm()
	qs := o.QueryTable(new(Wish))
	qs = qs.Filter("Enabled", 1)
	qs = qs.Filter("GameId", gId)
	qs = qs.OrderBy("-Thumbs")
	qs = qs.Limit(9)
	qs.All(&wishList, "Id", "Account", "Content", "Thumbs")
	setAccount(wishList)
	this.Data["wishList"] = wishList

	if IsWap(this.Ctx.Input.UserAgent()) {
		this.TplName = "front/wish/index-wap.tpl"
	} else {
		this.TplName = "front/wish/index-pc.tpl"
	}
}

// 许愿
func (this *WishApiController) Wish() {
	var code int
	var msg string
	defer Retjson(this.Ctx, &msg, &code)
	wc := strings.TrimSpace(this.GetString("content"))
	account := strings.TrimSpace(this.GetString("account"))
	mobile := strings.TrimSpace(this.GetString("mobile"))
	gId, err := this.GetInt64("gid")
	if err != nil {
		msg = "请刷新后重新许愿"
		return
	}
	if account == "" && mobile == "" {
		msg = "会员账号与手机号至少填一个"
		return
	}
	valid := validation.Validation{}
	o := orm.NewOrm()
	if account != "" {
		num, err := o.QueryTable(new(Member)).Filter("Account", account).Count()
		if err != nil {
			msg = "请刷新后重新许愿"
			return
		}
		if num != 1 {
			valid.Required(mobile, "errmsg").Message("非会员请填写手机号")
			valid.Phone(mobile, "errmsg").Message("手机号格式不正确")
		}
	} else {
		valid.Required(mobile, "errmsg").Message("非会员请填写手机号")
		valid.Phone(mobile, "errmsg").Message("手机号格式不正确")
	}
	valid.Required(wc, "errmsg").Message("您还没填写愿望，请填写")

	if valid.HasErrors() {
		for _, err := range valid.Errors {
			msg = err.Message
			return
		}
	}
	if account == "" {
		account = mobile
	}
	wc = html.EscapeString(wc)
	wish := Wish{GameId: gId, Account: account, Mobile: mobile, Content: wc, Thumbs: 0, Enabled: 0}
	ok, id, err := wish.ReadOrCreate("GameId", "Account")
	if ok {
		code = int(id)
		msg = "许愿成功，祝您愿望成真！"
		return
	} else {
		err := o.Read(&wish, "GameId", "Account")
		if err == nil && wish.Id > 0 {
			msg = "您已经许过愿了"
			return
		}
		beego.Error("front wish err", err)
		msg = "许愿失败了，请刷新后重新许愿"
		return
	}
}

func (this *WishApiController) Thumbs() {
	var code int
	var msg string
	defer Retjson(this.Ctx, &msg, &code)
	wishId, err := this.GetInt64("wishId", 0)
	gId, err := this.GetInt64("gid", 0)
	if gId == 0 || err != nil {
		msg = "点赞失败，请刷新后再试(1)"
		return
	}
	if wishId == 0 || err != nil {
		msg = "点赞失败，请刷新后再试(2)"
		return
	}
	ip := this.Ctx.Input.IP()
	o := orm.NewOrm()
	// 查询许愿的会员账号
	wish := Wish{BaseModel: BaseModel{Id: wishId}}
	err = o.Read(&wish)
	if err != nil {
		msg = "点赞失败，请刷新后再试(3)"
		return
	}
	account := wish.Account
	// 判断是否已经点赞过
	count, err := o.QueryTable(new(Thumbs)).Filter("GameId", gId).Filter("Account", account).Filter("Ip", ip).Count()
	if err != nil {
		msg = "点赞失败，请刷新后再试(4)"
		return
	}
	if count > 0 {
		msg = "只能点赞一次，您已经点赞过"
		return
	}
	num, err := o.QueryTable(new(Wish)).Filter("Id", wishId).Update(orm.Params{
		"Thumbs": orm.ColValue(orm.ColAdd, 1),
	})
	if num == 1 && err == nil {
		thumbs := Thumbs{GameId: gId, Ip: ip, Account: account}
		o.Insert(&thumbs)
		code = 1
		msg = "感谢您点赞，恭喜发财"
		return
	} else {
		msg = "点赞失败，请重试"
		return
	}
}

func (this *WishApiController) WishPage() {
	gId, err := this.GetInt64("gid", 0)
	if err != nil {
		gId = 0
	}
	page, err := this.GetInt("page", 1)
	if err != nil {
		page = 1
	}
	wishList := new(Wish).PaginateFront(page, 10, gId)

	setAccount(wishList)
	this.Data["json"] = wishList
	this.ServeJSON()
}

func (this *WishApiController) AllWish() {
	gId, err := this.GetInt64("gid", 0)
	if err != nil {
		gId = 0
	}
	o := orm.NewOrm()
	var wishList []Wish
	_, _ = o.QueryTable(new(Wish)).Filter("GameId", gId).Filter("Enabled", 1).Limit(-1).All(&wishList)
	setAccount(wishList)
	this.Data["json"] = wishList
	this.ServeJSON()
}

func setAccount(wishList []Wish) {
	for i, wish := range wishList {
		//判断会员账号中是否存在中文字符，如果存在跳过（一个中文字字符占3位，在下面进行截取的时候会出现下标越界的问题）
		var hzRegexp = regexp.MustCompile("^[\u4e00-\u9fa5]$")
		if hzRegexp.MatchString(wish.Account) {
			continue
		}
		wish.Account = SubString(wish.Account, 0, 2) + "***" + SubString(wish.Account, len(wish.Account)-2, 2)
		wishList[i] = wish
	}
}
