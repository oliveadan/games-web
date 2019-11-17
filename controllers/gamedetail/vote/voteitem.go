package vote

import (
	"fmt"
	"html/template"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/vote"
	. "phage-games-web/models/rewardlog"
	"phage-games-web/utils"
	"phage/controllers/sysmanage"
	. "phage/models"
	"strconv"
	"time"

	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
)

func validate(voteItem *VoteItem) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(voteItem.Name, "errmsg").Message("选票名称必填")
	valid.MaxSize(voteItem.Name, 255, "errmsg").Message("选票名称最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type VoteItemIndexController struct {
	sysmanage.BaseController
}

func (this *VoteItemIndexController) Prepare() {
	this.EnableXSRF = false
}

func (this *VoteItemIndexController) Get() {
	beego.Informational("query voteItem ")
	gId, _ := this.GetInt64("gameId", 0)

	var voteGid int64
	games := GetGames("vote", "fifa")
	for _, v := range games {
		if v.Id == gId {
			voteGid = v.Id
		}
	}
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(VoteItem).Paginate(page, limit, voteGid)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 奖池因子
	var factor string
	gaAttrs := GetGameAttributes(voteGid)
	// map的key为选票id，[]float64中，0：奖池金额；1：每人分得金额
	var prizeMap = make(map[int64][2]string)
	if len(gaAttrs) == 1 {
		factor = gaAttrs[0].Value
		// 计算奖池
		f, err := strconv.ParseFloat(factor, 64)
		if err == nil {
			var totalVote int // 所有选票的总票数
			for _, v := range list {
				totalVote = totalVote + v.NumVote + v.NumAdjust
			}
			for _, v := range list {
				nums := v.NumVote + v.NumAdjust
				amount := float64(totalVote-nums) * f
				var perAmount float64
				if nums != 0 {
					perAmount = amount / float64(nums)
				}

				prizeMap[v.Id] = [2]string{fmt.Sprintf("%.2f", amount), fmt.Sprintf("%.2f", perAmount)}
			}
		}
	}
	// 返回值
	this.Data["voteGid"] = voteGid
	this.Data["factor"] = factor
	this.Data["gameList"] = games
	this.Data["dataList"] = list
	this.Data["prizeMap"] = prizeMap
	this.TplName = "gamedetail/vote/voteitem/index.tpl"
}

func (this *VoteItemIndexController) MarkFlag() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	flag, _ := this.GetInt("flag", 0)
	model := VoteItem{}
	model.Id = id
	model.Modifior = this.LoginAdminId
	model.Flag = flag
	if _, err := model.Update("Flag"); err != nil {
		msg = "设置失败，请刷新后重试"
		return
	}
	code = 1
	msg = "操作成功"
}

func (this *VoteItemIndexController) Generate() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, err := this.GetInt64("gid")
	if err != nil {
		msg = "活动获取失败，请重新查询"
		return
	}
	o := orm.NewOrm()
	// 选票
	var list []VoteItem
	if _, err := o.QueryTable(new(VoteItem)).Filter("GameId", gId).All(&list); err != nil {
		msg = "选票获取失败，请刷新后重试"
		return
	}
	gaAttrs := GetGameAttributes(gId)
	if len(gaAttrs) == 0 {
		msg = "奖池因子未配置，请配置后再生成"
		return
	}
	// map的key为选票id，[]float64中，0：奖池金额；1：每人分得金额
	var prizeMap = make(map[int64]string)
	// 计算奖池
	voteFactor, err := strconv.ParseFloat(gaAttrs[0].Value, 64)
	if err != nil {
		msg = "奖池因子异常，请重新配置后再生成"
		return
	}
	var totalVote int // 所有选票的总票数
	for _, v := range list {
		totalVote = totalVote + v.NumVote + v.NumAdjust
	}
	var ids = make([]int64, 0)
	for _, v := range list {
		if v.Flag != 1 {
			continue
		}
		nums := v.NumVote + v.NumAdjust
		if nums <= 0 {
			continue
		}
		perAmount := float64(totalVote-nums) * voteFactor / float64(nums)
		prizeMap[v.Id] = fmt.Sprintf("%.2f", perAmount)
		ids = append(ids, v.Id)
	}
	if len(ids) == 0 {
		msg = "未设置中奖选票，请先设置后再生成"
		return
	}
	// 投票详情
	var vdList []VoteDetail
	page := 1
	limit := 1
	offset := (page - 1) * limit
	qs := o.QueryTable(new(VoteDetail)).Filter("GameId", gId).Filter("VoteItemId__in", ids)
	qs = qs.Limit(limit)
	qs = qs.Offset(offset)
	qs = qs.OrderBy("Id")
	total, _ := qs.Count()
	if _, err := qs.All(&vdList); err != nil {
		msg = "获取投票详情失败，请刷新后重试"
		return
	}
	totalInt := int(total)
	if totalInt > limit {
		for page = 2; page <= ((totalInt-limit)/limit + 1); page++ {
			var listTmp []VoteDetail
			offset := (page - 1) * limit
			qs = qs.Offset(offset)
			if _, err := qs.All(&listTmp); err != nil {
				msg = "获取投票详情失败，请刷新后重试"
				return
			}
			vdList = append(vdList, listTmp...)
		}
	}

	// 生成中奖记录
	// 奖品信息
	o.Begin()
	// 中奖记录
	var rlList []RewardLog
	for _, v := range vdList {
		rl := RewardLog{BaseModel: BaseModel{Creator: this.LoginAdminId,
			CreateDate: time.Now(),
			Modifior:   this.LoginAdminId,
			ModifyDate: time.Now(),
			Version:    0},
			GameId:      gId,
			Account:     v.Account,
			GiftId:      v.Id,
			GiftName:    v.VoteItemName,
			GiftContent: prizeMap[v.VoteItemId],
			Delivered:   0}
		rlList = append(rlList, rl)
	}
	var susNum int64
	mlen := len(rlList)
	if mlen == 0 {
		msg = "没有中奖记录需要生成"
		return
	}
	if _, err := o.Delete(&RewardLog{GameId: gId, Delivered: 0}, "GameId", "Delivered"); err != nil {
		o.Rollback()
		msg = "生成失败，请重试(2)"
		return
	}
	for i := 0; i <= mlen/1000; i++ {
		end := 0
		if (i+1)*1000 >= mlen {
			end = mlen
		} else {
			end = (i + 1) * 1000
		}
		var tmpRlList []RewardLog
		for j := i * 1000; j < end; j++ {
			if o.QueryTable(new(RewardLog)).Filter("GameId", gId).Filter("Account", rlList[j].Account).Filter("GiftId", rlList[j].GiftId).Filter("Delivered", 1).Exist() {
				continue
			}
			tmpRlList = append(tmpRlList, rlList[j])
		}
		if nums, err := o.InsertMulti(len(tmpRlList), tmpRlList); err != nil {
			o.Rollback()
			msg = "生成中奖记录失败，请重试"
			return
		} else {
			susNum = susNum + nums
		}
	}
	o.Commit()
	code = 1
	msg = fmt.Sprintf("成功生成 %d 条中奖记录", susNum)
}

func (this *VoteItemIndexController) ModifyFactor() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	gId, err := this.GetInt64("gid", 0)
	if err != nil || gId == 0 {
		msg = "活动获取失败，请重新查询"
		return
	}
	vf, err := this.GetFloat("factor", 0)
	if err != nil {
		msg = "奖池因子必须为数字"
		return
	}
	model := GameAttribute{}
	model.GameId = gId
	model.Code = utils.Votefactor
	model.Value = strconv.FormatFloat(vf, 'f', 2, 64)
	model.CreateDate = time.Now()
	model.Creator = this.LoginAdminId
	model.ModifyDate = time.Now()
	model.Modifior = this.LoginAdminId
	model.Version = 0
	if created, id, err := model.ReadOrCreate("GameId", "Code"); err != nil {
		msg = "修改失败，请刷新后重试"
		return
	} else if !created {
		model.Id = id
		model.Value = strconv.FormatFloat(vf, 'f', 2, 64)
		if _, err = model.Update("Value"); err != nil {
			msg = "修改失败，请刷新后重试"
			return
		}
	}
	code = 1
	msg = "修改成功"
	return
}

func (this *VoteItemIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	voteItem := VoteItem{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&voteItem)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&voteItem, "Id")
	if err1 != nil {
		beego.Error("Delete voteItem error", err1)
		msg = "删除失败"
	} else {
		code = 1
		msg = "删除成功"
	}
}

type VoteItemAddController struct {
	sysmanage.BaseController
}

func (this *VoteItemAddController) Get() {
	this.Data["gameList"] = GetGames("vote", "fifa")
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "gamedetail/vote/voteitem/add.tpl"
}

func (this *VoteItemAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	model := VoteItem{}
	if err := this.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&model); hasError {
		msg = errMsg
		return
	}
	model.Creator = this.LoginAdminId
	model.Modifior = this.LoginAdminId
	_, err1 := model.Create()
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert voteItem error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type VoteItemEditController struct {
	sysmanage.BaseController
}

func (this *VoteItemEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	voteItem := VoteItem{BaseModel: BaseModel{Id: id}}

	err := o.Read(&voteItem)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("VoteItemIndexController.get"), 302)
	} else {
		this.Data["gameList"] = GetGames("vote", "fifa")
		this.Data["data"] = voteItem
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "gamedetail/vote/voteitem/edit.tpl"
	}
}

func (this *VoteItemEditController) Post() {
	var code int
	var msg string
	var url string = beego.URLFor("VoteItemIndexController.get")
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url)
	model := VoteItem{}
	if err := this.ParseForm(&model); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&model); hasError {
		msg = errMsg
		return
	}
	cols := []string{"Seq", "Name", "NumAdjust"}
	model.Modifior = this.LoginAdminId
	_, err := model.Update(cols...)
	if err != nil {
		msg = "更新失败"
		beego.Error("Update voteItem error", err)
	} else {
		code = 1
		msg = "更新成功"
	}
}
