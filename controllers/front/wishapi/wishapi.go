package wishapi

import (
	. "games-web/controllers/front"
	. "games-web/models/common"
	. "games-web/models/gamedetail/wish"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/logs"
	"github.com/astaxie/beego/orm"
	"html"
	. "phage/models"
	. "phage/utils"
	"regexp"
	"strings"
	"time"
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

//许愿和砸金蛋联动
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
	if account == "" {
		msg = "请输入您的会员账号"
		return
	}
	o := orm.NewOrm()
	exist := o.QueryTable(new(Member)).Filter("Account", account).Exist()
	if !exist {
		msg = "您输入的会员账号不存在"
		return
	}
	wc = html.EscapeString(wc)
	wish := Wish{GameId: gId, Account: account, Mobile: mobile, Content: wc, Thumbs: 0, Enabled: 0}
	ok, id, err := wish.ReadOrCreate("GameId", "Account")
	if ok {
		code = int(id)
		msg = "许愿成功，祝您愿望成真！"
		//添加砸金蛋抽奖次数
		b := o.QueryTable(new(MemberLottery)).Filter("GameId", 10).Filter("Account", account).Exist()
		if !b {
			ml := MemberLottery{}
			ml.CreateDate = time.Now()
			ml.ModifyDate = time.Now()
			ml.GameId = 10
			ml.Account = account
			ml.Version = 0
			_, err := o.Insert(&ml)
			if err != nil {
				logs.Info("insert MemberLottery error", err)
			}
		} else {
			_, err := o.QueryTable(new(MemberLottery)).Filter("GameId", 10).Filter("Account", account).Update(orm.Params{"LotteryNums": orm.ColValue(orm.ColAdd, 1)})
			if err != nil {
				logs.Info("update MemberLottery err", err)
			}
		}
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
