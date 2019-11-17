package utils

import . "phage/utils"
import (
	"phage-games-web/models/common"
)

func GetSiteConfigCodeMap() map[string]string {
	m := map[string]string{
		Scname:         "站点名称",
		Sccust:         "客服网址",
		Scofficial:     "官网网址",
		Scregister:     "官网注册网址,无则删除",
		Scpartner:      "合作经营条款与规则,无则删除",
		Scpromotion:    "优惠活动网址,无则删除",
		Scfqa:          "博彩责任,无则删除",
		Screcharge:     "快速充值中心网址,无则删除",
		Scnavopen:      "是否开启活动导航首页,1:开启；0:关闭",
		Scplatformtype: "平台类型：BOS/TBK",
		Scplatformreg:  "会员注册模板，模板名称咨询技术",
	}
	return m
}

func GetGameName(id int64) string {
	game := common.GetGame(id)
	return game.Name
}

func GetApprovelMap() map[int8]string {
	m := map[int8]string{
		0: "未审核",
		1: "审核通过",
		2: "审核拒绝",
		3: "已派奖"}
	return m
}

func GetGameTypeMap() map[string]string {
	m := map[string]string{
		"wish":       "许愿活动",
		"guagua":     "刮刮乐",
		"red":        "抢红包",
		"goldegg":    "砸金蛋",
		"rich":       "大富翁",
		"wheel":      "大转盘",
		"quest":      "问卷调查",
		"questscore": "问卷调查(计算分数)",
		"poker":      "翻牌活动",
		"integral":   "积分商城",
		"tiger":      "老虎机",
		"ranking":    "投注排行榜",
		"upgrading":  "电子金管家",
		"vote":       "投票活动-选票独立奖池版",
		"fifa":       "投票活动-选票独立奖池版(世界杯主题)",
		"vote2":      "投票活动-总奖池版",
		"fifa2018":   "投票活动-总奖池版(世界杯主题)",
		"signin":     "签到活动",
		"weeksignin": "周签到活动",
		"box":        "宝箱活动",
		"luckyfree":  "幸运免单",
		"kingrace":   "赌王争霸",
		"bobing":     "博饼",
		"sec":        "秒杀",
		"seckill":    "秒杀抢购组合活动",
		"rush":       "抢购",
		"vipvalue":   "VIP账号价值查询",
		"monthsign":  "月签到"}
	return m
}

//允许使用抽奖接口的活动
func GetAllowLottery() map[string]string {
	m := map[string]string{
		"guagua":    "刮刮乐",
		"red":       "抢红包",
		"goldegg":   "砸金蛋",
		"wheel":     "大转盘",
		"poker":     "翻牌活动",
		"tiger":     "老虎机",
		"box":       "宝箱活动",
		"luckyfree": "幸运免单",
		"kingrace":  "赌王争霸"}
	return m
}

func GetGameVersion() map[string][][]string {
	m := map[string][][]string{
		"wish":       [][]string{{"1", ""}},
		"guagua":     [][]string{{"1", ""}},
		"red":        [][]string{{"1", "基础红包"}, {"2", "神秘礼包"}, {"3", "飘红包"}, {"4", "简单红包"}},
		"goldegg":    [][]string{{"1", ""}},
		"rich":       [][]string{{"1", ""}},
		"wheel":      [][]string{{"1", ""}},
		"quest":      [][]string{{"1", ""}},
		"questscore": [][]string{{"1", ""}},
		"poker":      [][]string{{"1", ""}},
		"integral":   [][]string{{"1", "紫色版"}, {"2", "海滩版"}},
		"tiger":      [][]string{{"1", ""}},
		"ranking":    [][]string{{"1", ""}},
		"upgrading":  [][]string{{"1", ""}},
		"vote":       [][]string{{"1", ""}},
		"fifa":       [][]string{{"1", ""}},
		"vote2":      [][]string{{"1", ""}},
		"fifa2018":   [][]string{{"1", ""}},
		"box":        [][]string{{"1", ""}},
		"luckyfree":  [][]string{{"1", ""}},
		"kingrace":   [][]string{{"1", ""}},
		"bobing":     [][]string{{"1", ""}},
		"sec":        [][]string{{"1", ""}},
		"seckill":    [][]string{{"1", ""}},
		"rush":       [][]string{{"1", ""}},
		"signin":     [][]string{{"1", "签到，瓜分"}, {"2", "增加额外礼品"}, {"3", "增加翻倍排行"}, {"4", "看板娘"}, {"5", "简约版"}, {"6", "超简约版"}, {"7", "自适应"}, {"8", "星空版"}},
		"weeksignin": [][]string{{"1", ""}},
		"vipvalue":   [][]string{{"1", ""}},
		"monthsign":  [][]string{{"1", ""}},
	}
	return m
}

func GetGameVersionDetail(index int64, gametype string) string {
	indexx := index - 1
	if indexx < 0 {
		indexx = 0
	}
	versionmap := GetGameVersion()
	twodimension := versionmap[gametype]
	return twodimension[indexx][0] + " " + twodimension[indexx][1]
}

func GetQuestionContentTypeMap() map[int]string {
	m := map[int]string{
		1: "单选题",
		2: "多选题",
		3: "单行输入题",
		4: "多行输入题"}
	return m
}
