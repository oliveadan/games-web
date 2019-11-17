package member

import (
	"encoding/csv"
	"fmt"
	. "games-web/models/common"
	"html/template"
	"io/ioutil"
	"net/url"
	"phage/controllers/sysmanage"
	. "phage/models"
	"phage/utils"
	"strings"
	"time"

	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"github.com/astaxie/beego/validation"
	"os"
	"strconv"
)

func validate(member *Member) (hasError bool, errMsg string) {
	valid := validation.Validation{}
	valid.Required(member.Account, "errmsg").Message("会员账号必填")
	valid.MaxSize(member.Account, 255, "errmsg").Message("会员账号最长255个字符")
	valid.MaxSize(member.Name, 255, "errmsg").Message("姓名最长255个字符")
	valid.MaxSize(member.Mobile, 255, "errmsg").Message("手机号最长255个字符")
	if valid.HasErrors() {
		for _, err := range valid.Errors {
			return true, err.Message
		}
	}
	return false, ""
}

type MemberIndexController struct {
	sysmanage.BaseController
}

func (this *MemberIndexController) NestPrepare() {
	this.EnableXSRF = false
}

func (this *MemberIndexController) Get() {
	//导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}
	param1 := strings.TrimSpace(this.GetString("param1"))
	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(Member).Paginate(page, limit, param1)
	pagination.SetPaginator(this.Ctx, limit, total)
	// 返回值
	this.Data["param1"] = param1
	this.Data["dataList"] = list
	this.TplName = "common/member/index.tpl"
}

func (this *MemberIndexController) Delbatch() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	// 条件 要和Get函数保持一致
	o := orm.NewOrm()
	res, err := o.Raw("DELETE from ph_member WHERE id != 0").Exec()
	if err != nil {
		beego.Error("Delete batch memberLottery error", err)
		msg = "删除失败"
		return
	} else {
		code = 1
		num, _ := res.RowsAffected()
		msg = fmt.Sprintf("成功删除%d条记录", num)
		return
	}
}

func (this *MemberIndexController) ImportSign() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("Member upload file get file error")
		msg = "上传失败,请重试(1)"
		return
	}
	fname := url.QueryEscape(h.Filename)
	suffix := utils.SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".xlsx" {
		msg = "文件必须为 xlsx"
		return
	}
	o := orm.NewOrm()
	members := make([]Member, 0)
	accounts := make([]string, 0)
	xlsx, err := excelize.OpenReader(f)
	if err != nil {
		beego.Error("member importsign,open excel error", err)
		msg = "读取excel失败,请重试"
		return
	}
	if xlsx.GetSheetIndex("会员标识导入") == 0 {
		msg = "不存在《会员标识导入》sheet页"
		return
	}
	rows := xlsx.GetRows("会员标识导入")
	for i, row := range rows {
		if i == 0 {
			continue
		}
		account := strings.TrimSpace(row[0])
		if account == "" {
			msg = fmt.Sprintf("%s第%d行数据错误，请重试<br>", msg, i+1)
			continue
		}
		exist := o.QueryTable(new(Member)).Filter("Account", account).Exist()
		if exist {
			accounts = append(accounts, account)
		} else {
			var member Member
			member.Creator = this.LoginAdminId
			member.Modifior = this.LoginAdminId
			member.CreateDate = time.Now()
			member.ModifyDate = time.Now()
			member.Version = 0
			member.Account = account
			member.SignEnable = 1
			members = append(members, member)
		}
	}
	if msg != "" {
		msg = fmt.Sprintf("请处理以下错误后再导入：<br>%s", msg)
		return
	}
	if len(accounts) == 0 && len(members) == 0 {
		msg = "没有数据需要操作"
		return
	}
	o.Begin()
	// 将数组拆分导入，一次1000条
	var enderrmsg string
	var endokmsg string
	mlen := len(members)
	if mlen > 0 {
		var susNums int64
		for i := 0; i <= mlen/1000; i++ {
			end := 0
			if (i+1)*1000 >= mlen {
				end = mlen
			} else {
				end = (i + 1) * 1000
			}
			if i*1000 == end {
				continue
			}
			tmpArr := members[i*1000 : end]

			if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
				o.Rollback()
				beego.Error("member import, insert error", err)
				enderrmsg = "导入新会员失败"
				return
			} else {
				susNums += nums
			}
		}
		endokmsg = fmt.Sprintf("成功导入可签到会员%d个<br>", susNums)
	}
	lenaccount := len(accounts)
	if lenaccount > 0 {
		i, err := o.QueryTable(new(Member)).Filter("Account__in", accounts).Update(orm.Params{"SignEnable": 1})
		if err != nil {
			o.Rollback()
			beego.Error("update member error", err)
			enderrmsg += "更新已存在会员签到标识失败"
		}
		endokmsg += fmt.Sprintf("成功更新%d个已存在会员签到标识", i)
	}
	msg = endokmsg + enderrmsg
	code = 1
	o.Commit()
}

func (this *MemberIndexController) RebootSign() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	// 条件 要和Get函数保持一致
	o := orm.NewOrm()
	res, err := o.QueryTable(new(Member)).Filter("Id__gt", 0).Update(orm.Params{"Force": 0, "Level": 0, "LevelName": ""})
	if err != nil {
		beego.Error("Delete batch memberLottery error", err)
		msg = "删除失败"
		return
	} else {
		code = 1
		msg = fmt.Sprintf("成功重置%d条记录", res)
		return
	}
}

func (this *MemberIndexController) Delone() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	id, _ := this.GetInt64("id")
	member := Member{BaseModel: BaseModel{Id: id}}
	o := orm.NewOrm()
	err := o.Read(&member)
	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		code = 1
		msg = "删除成功"
		return
	}
	_, err1 := o.Delete(&Member{BaseModel: BaseModel{Id: id}})
	if err1 != nil {
		beego.Error("Delete member error", err1)
		msg = "删除失败"
		return
	} else {
		code = 1
		msg = "删除成功"
		return
	}
}

func (this *MemberIndexController) Import() {
	var code int
	var msg string
	var url1 string
	defer sysmanage.Retjson(this.Ctx, &msg, &code, &url1)
	f, h, err := this.GetFile("file")
	defer f.Close()
	if err != nil {
		beego.Error("member upload file get file error", err)
		msg = "上传失败，请重试(1)"
		return
	}
	fname := url.QueryEscape(h.Filename)
	suffix := utils.SubString(fname, len(fname), strings.LastIndex(fname, ".")-len(fname))
	if suffix != ".csv" && suffix != ".xlsx" {
		msg = "文件必须为 csv 或者 xlsx"
		return
	}

	o := orm.NewOrm()
	members := make([]Member, 0)
	var countnum int64
	var countnumforce int64
	var countsign int64
	if suffix == ".csv" {
		cs, _ := ioutil.ReadAll(f)
		r2 := csv.NewReader(strings.NewReader(string(cs)))
		ss, _ := r2.ReadAll()
		sz := len(ss)
		if sz < 2 {
			msg = "文件内容为空"
			return
		}
		for i := 1; i < sz; i++ {
			if strings.TrimSpace(ss[i][0]) == "" {
				msg = fmt.Sprintf("%s第%d行账号为空<br>", msg, i+1)
				continue
			}
			// 已存在的会员跳过
			isExist := o.QueryTable(new(Member)).Filter("Account", strings.TrimSpace(ss[i][0])).Exist()
			if isExist {
				msg = fmt.Sprintf("%s第%d行会员账号已存在<br>", msg, i+1)
				continue
			}
			member := Member{Account: strings.TrimSpace(ss[i][0])}
			if len(ss[i]) > 1 {
				member.Name = strings.TrimSpace(ss[i][1])
			}
			if len(ss[i]) > 2 {
				member.Mobile = strings.TrimSpace(ss[i][2])
			}
			member.Creator = this.LoginAdminId
			member.Modifior = this.LoginAdminId
			member.CreateDate = time.Now()
			member.ModifyDate = time.Now()
			member.Version = 0
			if hasError, errMsg := validate(&member); hasError {
				msg = fmt.Sprintf("%s第%d行%s<br>", msg, i+1, errMsg)
				continue
			}
			members = append(members, member)
		}
	} else {
		// xls 或者 xlsx
		xlsx, err := excelize.OpenReader(f)
		if err != nil {
			beego.Error("member import, open excel error", err)
			msg = "读取excel失败，请重试"
			return
		}
		if xlsx.GetSheetIndex("会员导入") == 0 {
			msg = "不存在《会员导入》sheet页"
			return
		}
		rows := xlsx.GetRows("会员导入")
		for i, row := range rows {
			if len(msg) > 200 {
				msg = fmt.Sprintf("%s<br>...", msg)
				return
			}
			if i == 0 {
				continue
			}
			if len(row) < 1 {
				msg = fmt.Sprintf("%s第%d行账号为空<br>", msg, i+1)
				continue
			}
			// 已存在的会员跳过
			isExist := o.QueryTable(new(Member)).Filter("Account", strings.TrimSpace(row[0])).Exist()
			if isExist {
				//判断邀请码是否为空，如果不为空更新会员的邀请码
				invitationcode := strings.TrimSpace(row[3])
				force := strings.TrimSpace(row[4])
				dynamic := strings.TrimSpace(row[5])
				signEnable := strings.TrimSpace(row[6])
				if invitationcode != "" {
					num, err := o.QueryTable(new(Member)).Filter("Account", strings.TrimSpace(row[0])).Update(orm.Params{"InvitationCode": invitationcode})
					if num == 1 {
						countnum += 1
					}
					if err != nil {
						msg = "更新邀请码失败"
						return
					}
				}
				//判断签到点数是否为空，如果不为空更新会员的邀请码
				if force != "" {
					num1, err := o.QueryTable(new(Member)).Filter("Account", strings.TrimSpace(row[0])).Update(orm.Params{"Force": force})
					if num1 == 1 {
						countnumforce += 1
					}
					if err != nil {
						msg = "更新总点数失败"
						return
					}
				}
				//判断活力值是否为空
				if dynamic != "" {
					i, _ := strconv.ParseInt(dynamic, 10, 64)
					if i == 0 {
						_, err := o.QueryTable(new(Member)).Filter("Account", strings.TrimSpace(row[0])).Update(orm.Params{"Dynamic": 0})
						if err != nil {
							beego.Error("更新活力值失败", err)
							msg = "更新活力值失败"
							return
						}
					} else {
						_, err := o.QueryTable(new(Member)).Filter("Account", strings.TrimSpace(row[0])).Update(orm.Params{"Dynamic": orm.ColValue(orm.ColAdd, i)})
						if err != nil {
							beego.Error("更新活力值失败", err)
							msg = "更新活力值失败"
							return
						}
					}
				}
				if signEnable != "" {
					i, err := o.QueryTable(new(Member)).Filter("Account", strings.TrimSpace(row[0])).Update(orm.Params{"SignEnable": signEnable})
					if i == 1 {
						countsign += 1
					}
					if err != nil {
						beego.Error("更新签到标识失败", err)
						msg = "更新签到标识失败"
						return
					}
				}
				//检查是否
				//msg = fmt.Sprintf("%s第%d行会员账号已存在<br>", msg, i+1)
				continue
			}
			member := Member{Account: strings.TrimSpace(row[0])}
			if len(row) > 1 {
				member.Name = strings.TrimSpace(row[1])
			}
			if len(row) > 2 {
				member.Mobile = strings.TrimSpace(row[2])
			}

			if len(row) > 3 {
				invitationcode := strings.TrimSpace(row[3])
				member.InvitationCode = invitationcode
			}
			if len(row) > 4 {
				force := strings.TrimSpace(row[4])
				force1, _ := strconv.Atoi(force)
				member.Force = force1
			}
			if len(row) > 5 {
				dynamic := strings.TrimSpace(row[5])
				i, _ := strconv.ParseInt(dynamic, 10, 64)
				member.Dynamic = i
			}
			if len(row) > 6 {
				signEnable := strings.TrimSpace(row[6])
				i, _ := strconv.ParseInt(signEnable, 10, 64)
				member.SignEnable = i
			}

			member.Creator = this.LoginAdminId
			member.Modifior = this.LoginAdminId
			member.CreateDate = time.Now()
			member.ModifyDate = time.Now()
			member.Version = 0
			if hasError, errMsg := validate(&member); hasError {
				msg = fmt.Sprintf("%s第%d行%s<br>", msg, i+1, errMsg)
				continue
			}
			members = append(members, member)
		}
	}
	mlen := len(members)
	if mlen == 0 {
		if countnum != 0 && countnumforce != 0 {
			msg1 := fmt.Sprintf("成功更新了%d个会员的总点数<br>", countnumforce)
			msg = fmt.Sprintf("没有需要导入的数据<br>%s成功更新了%d个已存在会员的邀请码", msg1, countnum)
			return
		}
		if countnum != 0 {
			msg = fmt.Sprintf("没有需要导入的数据<br>成功更新了%d个已存在会员的邀请码", countnum)
			return
		}
		if countnumforce != 0 {
			msg = fmt.Sprintf("没有需要导入的数据<br>成功更新了%d个已存在会员的总点数", countnumforce)
			return
		}
		if countsign != 0 {
			msg = fmt.Sprintf("没有需要导入的数据<br>成功更新了%d个已存在会员的签到标识", countsign)
			return
		}
		msg = "没有需要导入的数据"
		return
	}

	var susNums int64
	// 将数组拆分导入，一次1000条
	for i := 0; i <= mlen/1000; i++ {
		end := 0
		if (i+1)*1000 >= mlen {
			end = mlen
		} else {
			end = (i + 1) * 1000
		}
		tmpArr := members[i*1000 : end]

		if nums, err := o.InsertMulti(len(tmpArr), tmpArr); err != nil {
			beego.Error("member import, insert error", err)
		} else {
			susNums += nums
		}
	}
	code = 1
	if countnumforce != 0 && countnum != 0 {
		msg = fmt.Sprintf("%s成功导入%d条记录<br>成功更新了%d个已存在会员的邀请码和%d个会员的总点数", msg, susNums, countnum, countnumforce)
	} else if countnum != 0 {
		msg = fmt.Sprintf("%s成功导入%d条记录<br>成功更新了%d个已存在会员的邀请码", msg, susNums, countnum)
	} else if countnumforce != 0 {
		msg = fmt.Sprintf("%s成功导入%d条记录<br>成功更新了%d个总点数", msg, susNums, countnumforce)
	} else if countsign != 0 {
		msg = fmt.Sprintf("%s成功导入%d条记录<br>成功更新了%d个总点数", msg, susNums, countsign)
	} else {
		msg = fmt.Sprintf("%s成功导入%d条记录", msg, susNums)
	}

	url1 = beego.URLFor("MemberIndexController.Get")
	return
}

func (this *MemberIndexController) Export() {
	o := orm.NewOrm()
	var members []Member
	_, err := o.QueryTable(new(Member)).Limit(-1).All(&members)
	if err != nil {
		beego.Error("导出失败", err)
		return
	}

	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "账号")
	xlsx.SetCellValue("Sheet1", "B1", "等级")
	xlsx.SetCellValue("Sheet1", "C1", "总点数")
	xlsx.SetCellValue("Sheet1", "D1", "签到时间")
	xlsx.SetCellValue("Sheet1", "E1", "手机号码")
	for i, value := range members {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), value.Account)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), value.Level)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("C%d", i+2), value.Force)
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("D%d", i+2), value.LastSigninDate.Format("2006-01-02 15:04:05"))
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("E%d", i+2), value.Mobile)

	}
	fileName := fmt.Sprintf("./tmp/excel/memberlist_%s.xlsx", time.Now().Format("20060102150405"))
	err1 := xlsx.SaveAs(fileName)
	if err1 != nil {
		beego.Error("Export member error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}

type MemberAddController struct {
	sysmanage.BaseController
}

func (this *MemberAddController) Get() {
	this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
	this.TplName = "common/member/add.tpl"
}

func (this *MemberAddController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	member := Member{}
	if err := this.ParseForm(&member); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&member); hasError {
		msg = errMsg
		return
	}
	member.Creator = this.LoginAdminId
	member.Modifior = this.LoginAdminId
	_, _, err1 := member.ReadOrCreate("Account")
	if err1 != nil {
		msg = "添加失败"
		beego.Error("Insert member error", err1)
	} else {
		code = 1
		msg = "添加成功"
	}
}

type MemberEditController struct {
	sysmanage.BaseController
}

func (this *MemberEditController) Get() {
	id, _ := this.GetInt64("id")
	o := orm.NewOrm()
	member := Member{BaseModel: BaseModel{Id: id}}

	err := o.Read(&member)

	if err == orm.ErrNoRows || err == orm.ErrMissPK {
		this.Redirect(beego.URLFor("MemberIndexController.get"), 302)
	} else {
		this.Data["data"] = member
		this.Data["xsrfdata"] = template.HTML(this.XSRFFormHTML())
		this.TplName = "common/member/edit.tpl"
	}
}

func (this *MemberEditController) Post() {
	var code int
	var msg string
	defer sysmanage.Retjson(this.Ctx, &msg, &code)
	member := Member{}
	if err := this.ParseForm(&member); err != nil {
		msg = "参数异常"
		return
	} else if hasError, errMsg := validate(&member); hasError {
		msg = errMsg
		return
	}
	cols := []string{"Account", "Name", "Mobile", "Force", "InvitationCode", "SignEnable"}
	member.Modifior = this.LoginAdminId
	_, err1 := member.Update(cols...)
	if err1 != nil {
		msg = "更新失败"
		beego.Error("Update member error", err1)
	} else {
		code = 1
		msg = "更新成功"
	}
}
