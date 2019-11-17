package question

import (
	"fmt"
	. "phage-games-web/models/common"
	. "phage-games-web/models/gamedetail/question"
	"phage/controllers/sysmanage"
	. "phage/utils"
	"strconv"
	"strings"

	"github.com/360EntSecGroup-Skylar/excelize"
	"github.com/astaxie/beego"
	"github.com/astaxie/beego/orm"
	"github.com/astaxie/beego/utils/pagination"
	"math"
	"os"
	"time"
)

type QuestionAnswerIndexController struct {
	sysmanage.BaseController
}

func (this *QuestionAnswerIndexController) Get() {
	//导出
	isExport, _ := this.GetInt("isExport", 0)
	if isExport == 1 {
		this.Export()
		return
	}

	gId, _ := this.GetInt64("gameId", 0)

	page, err := this.GetInt("p")
	if err != nil {
		page = 1
	}
	o := orm.NewOrm()
	// 查询问题列表，包含选项
	var questList []Question
	o.QueryTable(new(Question)).Filter("GameId", gId).OrderBy("Seq", "Id").All(&questList, "Id", "Pid", "Seq", "Content", "ContentType")
	var tableHeadList = make([]Question, 0) // 表格头部
	var opMap = make(map[int64]Question)    // 选项ID和选项map
	for _, v := range questList {
		if v.Pid == 0 {
			tableHeadList = append(tableHeadList, v)
		} else {
			opMap[v.Id] = v
		}
	}

	var accountMap = make(map[int64]string)
	var rows = make(map[int64]map[int64]string)
	// 分页查询问卷结果
	limit, _ := beego.AppConfig.Int("pagelimit")
	list, total := new(QuestionAnswer).Paginate(page, limit)
	pagination.SetPaginator(this.Ctx, limit, total)

	if len(list) > 0 {
		pids := make([]int64, 0)
		for _, v := range list {
			pids = append(pids, v.Id)
			accountMap[v.Id] = v.Content
		}
		o.QueryTable(new(QuestionAnswer)).Filter("GameId", gId).Filter("Pid__in", pids).OrderBy("-Pid").All(&list, "Pid", "Content", "ContentType", "CreateDate")
		for _, v := range list {
			if v.ContentType == 1 {
				qids := strings.Split(v.Content, ",")
				for _, qidstr := range qids {
					qid, _ := strconv.ParseInt(qidstr, 10, 64)
					if len(rows[v.Pid]) == 0 {
						rows[v.Pid] = make(map[int64]string)
						rows[v.Pid][0] = accountMap[v.Pid]
						rows[v.Pid][-1] = v.CreateDate.Format("2006-01-02 15:04:05")
					}
					rows[v.Pid][opMap[qid].Pid] = fmt.Sprintf("%s%s; ", rows[v.Pid][opMap[qid].Pid], opMap[qid].Content)
				}
			} else if v.ContentType == 2 {
				qidstr := SubString(v.Content, 0, strings.Index(v.Content, ","))
				qid, _ := strconv.ParseInt(qidstr, 10, 64)
				if len(rows[v.Pid]) == 0 {
					rows[v.Pid] = make(map[int64]string)
					rows[v.Pid][0] = accountMap[v.Pid]
					rows[v.Pid][-1] = v.CreateDate.Format("2006-01-02 15:04:05")
				}
				rows[v.Pid][qid] = SubString(v.Content, strings.Index(v.Content, ",")+1, 0)
			}
		}
	}
	var rowsList = make([]map[int64]string, 0)
	for _, v := range rows {
		rowsList = append(rowsList, v)
	}
	// 返回值
	this.Data["tableHeadList"] = tableHeadList
	this.Data["gameList"] = GetGames("quest")
	this.Data["dataList"] = rowsList
	this.Data["accountMap"] = accountMap
	this.TplName = "gamedetail/question/questionanswer/index.tpl"
}

func (this *QuestionAnswerIndexController) Export() {

	gId, _ := this.GetInt64("gameId", 0)
	o := orm.NewOrm()
	// 查询问题列表，包含选项
	var questList []Question
	o.QueryTable(new(Question)).Filter("GameId", gId).OrderBy("Seq", "Id").All(&questList, "Id", "Pid", "Seq", "Content", "ContentType")
	var tableHeadList = make([]Question, 0) // 表格头部
	var opMap = make(map[int64]Question)    // 选项ID和选项map
	for _, v := range questList {
		if v.Pid == 0 {
			tableHeadList = append(tableHeadList, v)
		} else {
			opMap[v.Id] = v
		}
	}

	var accountMap = make(map[int64]string)
	var rows = make(map[int64]map[int64]string)
	// 分页查询问卷结果
	page := 1
	limit := 1000
	list, total := new(QuestionAnswer).Paginate(page, limit)
	totalInt := int(total)
	if totalInt > limit {
		page1 := (float64(totalInt) - float64(limit)) / float64(limit)
		page2 := int(math.Ceil(page1))
		for page = 2; page <= (page2 + 1); page++ {
			list1, _ := new(QuestionAnswer).Paginate(page, limit)
			for _, v := range list1 {
				list = append(list, v)
			}
		}
	}
	if len(list) > 0 {
		pids := make([]int64, 0)
		for _, v := range list {
			pids = append(pids, v.Id)
			accountMap[v.Id] = v.Content
		}
		o.QueryTable(new(QuestionAnswer)).Filter("GameId", gId).Filter("Pid__in", pids).OrderBy("-Pid").Limit(-1).All(&list, "Pid", "Content", "ContentType", "CreateDate")
		for _, v := range list {
			if v.ContentType == 1 {
				qids := strings.Split(v.Content, ",")
				for _, qidstr := range qids {
					qid, _ := strconv.ParseInt(qidstr, 10, 64)
					if len(rows[v.Pid]) == 0 {
						rows[v.Pid] = make(map[int64]string)
						rows[v.Pid][0] = accountMap[v.Pid]
						rows[v.Pid][-1] = v.CreateDate.Format("2006-01-02 15:04:05")
					}
					rows[v.Pid][opMap[qid].Pid] = fmt.Sprintf("%s%s; ", rows[v.Pid][opMap[qid].Pid], opMap[qid].Content)
				}
			} else if v.ContentType == 2 {
				qidstr := SubString(v.Content, 0, strings.Index(v.Content, ","))
				qid, _ := strconv.ParseInt(qidstr, 10, 64)
				if len(rows[v.Pid]) == 0 {
					rows[v.Pid] = make(map[int64]string)
					rows[v.Pid][0] = accountMap[v.Pid]
					rows[v.Pid][-1] = v.CreateDate.Format("2006-01-02 15:04:05")
				}
				rows[v.Pid][qid] = SubString(v.Content, strings.Index(v.Content, ",")+1, 0)
			}
		}
	}
	var rowsList = make([]map[int64]string, 0)
	for _, v := range rows {
		rowsList = append(rowsList, v)
	}
	head := map[int]string{0: "C1", 1: "D1", 2: "E1", 3: "F1", 4: "G1", 5: "H1", 6: "I1", 7: "J1", 8: "K1", 9: "L1", 10: "M1", 11: "N1", 12: "O1", 13: "P1", 14: "Q1", 15: "R1", 16: "S1", 17: "T1", 18: "U1", 19: "V1", 20: "W1", 21: "X1", 22: "Y1", 23: "Z1", 24: "AA1", 25: "AB1", 26: "AC1", 27: "AD1", 28: "AE1"}
	body := map[int]string{0: "C", 1: "D", 2: "E", 3: "F", 4: "G", 5: "H", 6: "I", 7: "J", 8: "K", 9: "L", 10: "M", 11: "N", 12: "O", 13: "P", 14: "Q", 15: "R", 16: "S", 17: "T", 18: "U", 19: "V", 20: "W", 21: "X", 22: "Y", 23: "Z", 24: "AA", 25: "AB", 26: "AC", 27: "AD", 28: "AE"}
	xlsx := excelize.NewFile()
	xlsx.SetCellValue("Sheet1", "A1", "提交IP")
	xlsx.SetCellValue("Sheet1", "B1", "提交时间")
	for i, v := range tableHeadList {
		xlsx.SetCellValue("Sheet1", head[i], v.Content)
	}
	for i, v := range rowsList {
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("A%d", i+2), v[0])
		xlsx.SetCellValue("Sheet1", fmt.Sprintf("B%d", i+2), v[-1])
		for s, vo := range tableHeadList {

			xlsx.SetCellValue("Sheet1", fmt.Sprintf(body[s]+"%d", i+2), v[vo.Id])
		}
	}
	// Save xlsx file by the given path.
	fileName := fmt.Sprintf("./tmp/excel/quest_%s.xlsx", time.Now().Format("20060102150405"))
	err := xlsx.SaveAs(fileName)
	if err != nil {
		beego.Error("Export reward error", err.Error())
	} else {
		defer os.Remove(fileName)
		this.Ctx.Output.Download(fileName)
	}
}
