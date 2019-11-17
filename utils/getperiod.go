package utils

import (
	"github.com/astaxie/beego/orm"
	. "phage-games-web/models/common"
	"sort"
	"strconv"
	"time"
)

//计算两个日期相差多少天
func timeSub(t1, t2 time.Time) int {
	t1 = t1.UTC().Truncate(24 * time.Hour)
	t2 = t2.UTC().Truncate(24 * time.Hour)
	return int(t1.Sub(t2).Hours() / 24)
}

//获取当天日期所在周的，周一的日期
func GetMonday(time2 time.Time) time.Time {
	var timecount = time2
	week := timecount.Weekday().String()
	switch week {
	case "Tuesday":
		timecount = timecount.AddDate(0, 0, -1)
		break
	case "Wednesday":
		timecount = timecount.AddDate(0, 0, -2)
		break
	case "Thursday":
		timecount = timecount.AddDate(0, 0, -3)
		break
	case "Friday":
		timecount = timecount.AddDate(0, 0, -4)
		break
	case "Saturday":
		timecount = timecount.AddDate(0, 0, -5)
		break
	case "Sunday":
		timecount = timecount.AddDate(0, 0, -6)
		break
	}
	return timecount
}

//获取组装的期数
func GetPeriodMap(gid int64) (map[int]string, [][]string) {
	//期数是活动开始的时间到 time.now()的时间
	var game Game
	o := orm.NewOrm()
	//获取游戏的开始和结束时间
	o.QueryTable(new(Game)).Filter("Id", gid).Filter("Enabled", 1).Filter("Deleted", 0).OrderBy("-Id").Limit(1).One(&game)
	//获取当天日期所在周的日期的周一的日期
	start := GetMonday(game.StartTime)
	//计算一共有多少期
	var days int
	day := timeSub(time.Now(), game.StartTime)
	day1 := day / 7
	/*if day%7 != 0 {
		days = day1 + 1
	} else {
		days = day1
	}*/
	days = day1 + 1
	var count time.Time
	count = start
	periods := make(map[int]string)
	for i := 1; i <= days; i++ {
		qishu := strconv.Itoa(i)
		if i == 1 {
			firststart := count.Format("01-02")
			firstend := count.Add(6 * 24 * time.Hour)
			firstend.Format("01-02")
			str := "第" + qishu + "期" + "(" + firststart + " " + firstend.Format("01-02") + ")"
			periods[i] = str
			count = firstend
		} else {
			count1 := count.Add(24 * time.Hour)
			start := count1.Format("01-02")
			count2 := count1.Add(6 * 24 * time.Hour)
			end := count2.Format("01-02")
			str := "第" + qishu + "期" + "(" + start + " " + end + ")"
			periods[i] = str
			count = count2
		}
	}
	var keys []int
	for k := range periods {
		keys = append(keys, k)
	}
	var periods1 [][]string
	sort.Sort(sort.Reverse(sort.IntSlice(keys)))
	for _, jj := range keys {
		var tmpArr []string
		tmpArr = append(tmpArr, strconv.Itoa(jj))
		tmpArr = append(tmpArr, periods[jj])
		periods1 = append(periods1, tmpArr)
	}
	return periods, periods1

}

//计算相差几个月
func GetSubMonth(gid int64) [][]string {
	var game Game
	var months []int
	var periods [][]string
	o := orm.NewOrm()
	o.QueryTable(new(Game)).Filter("Id", gid).Filter("Enabled", 1).OrderBy("-Id").Limit(1).One(&game)

	month := int(game.StartTime.Month())
	nowmonth := int(time.Now().Month())
	var t int
	//不是同一年
	if game.StartTime.Year() != time.Now().Year() {
		t = nowmonth
		if t == 1 {
			var onemonth []string
			onemonth = append(onemonth, strconv.Itoa(nowmonth))
			str := strconv.Itoa(nowmonth) + "月份"
			onemonth = append(onemonth, str)
			periods = append(periods, onemonth)
			return periods
		} else {
			for i := 1; i <= t; i++ {
				months = append(months, i)
			}
		}
		//同一年的情况下
	} else {
		t = nowmonth - month

		if t == 0 {
			var onemonth []string
			onemonth = append(onemonth, strconv.Itoa(month))
			str := strconv.Itoa(month) + "月份"
			onemonth = append(onemonth, str)
			periods = append(periods, onemonth)
			return periods
		}
		for i := 0; i <= t; i++ {
			if i == 0 {
				months = append(months, month)
				continue
			}
			months = append(months, month+i)
		}
	}
	sort.Sort(sort.Reverse(sort.IntSlice(months)))
	for _, jj := range months {
		var tmpArr []string
		tmpArr = append(tmpArr, strconv.Itoa(jj))
		str := strconv.Itoa(jj) + "月份"
		tmpArr = append(tmpArr, str)
		periods = append(periods, tmpArr)
	}
	return periods
}
