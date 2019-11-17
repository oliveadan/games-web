package routers

import (
	"games-web/controllers/common/game"
	"games-web/controllers/common/gameperiod"
	"games-web/controllers/common/member"
	"games-web/controllers/common/memberlottery"
	"games-web/controllers/common/sharedetail"
	"games-web/controllers/front"
	"games-web/controllers/front/bobingapi"
	"games-web/controllers/front/goldeggapi"
	"games-web/controllers/front/guaguaapi"
	"games-web/controllers/front/integralapi"
	"games-web/controllers/front/monthsigninapi"
	"games-web/controllers/front/pokerapi"
	"games-web/controllers/front/questapi"
	"games-web/controllers/front/questscoreapi"
	"games-web/controllers/front/rankingapi"
	"games-web/controllers/front/redapi"
	"games-web/controllers/front/richapi"
	"games-web/controllers/front/signinapi"
	"games-web/controllers/front/tigerapi"
	"games-web/controllers/front/upgradingapi"
	"games-web/controllers/front/vipvalueapi"
	"games-web/controllers/front/voteapi"
	"games-web/controllers/front/weeksignin"
	"games-web/controllers/front/wheelapi"
	"games-web/controllers/front/wishapi"
	"games-web/controllers/gamedetail/integral"
	"games-web/controllers/gamedetail/monthsignin"
	"games-web/controllers/gamedetail/question"
	"games-web/controllers/gamedetail/questionscore"
	"games-web/controllers/gamedetail/ranking/ranking"
	"games-web/controllers/gamedetail/ranking/rankingconfig"
	"games-web/controllers/gamedetail/ranking/rankingdeliver"
	"games-web/controllers/gamedetail/rich"
	"games-web/controllers/gamedetail/signin"
	"games-web/controllers/gamedetail/upgrading"
	"games-web/controllers/gamedetail/vipvalue"
	"games-web/controllers/gamedetail/vote"
	"games-web/controllers/gamedetail/wheel"
	"games-web/controllers/gamedetail/wish"
	"games-web/controllers/gift/assignmember"
	"games-web/controllers/gift/gift"
	"games-web/controllers/rewardlog"
	_ "phage/routers"

	"games-web/controllers/front/boxapi"
	"games-web/controllers/front/kingrace"
	"games-web/controllers/front/luckyfree"
	"games-web/controllers/gamedetail/box"

	"games-web/controllers/common/comment"
	"games-web/controllers/front/sec"
	"games-web/controllers/front/seckill"
	seckillandrush2 "games-web/controllers/gamedetail/seckillandrush"
	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &front.DoorController{})
	beego.Router("/login", &front.DoorController{}, "post:Login")
	beego.Router("/logincpt", &front.DoorController{}, "post:LoginCpt")
	beego.Router("/logout", &front.DoorController{}, "*:Logout")
	beego.Router("/rllist", &front.DoorController{}, "*:RlList")                    // 展示随机中奖记录
	beego.Router("/query", &front.DoorController{}, "get:Query")                    // 跳转中奖查询页面 目前仅用于手机端
	beego.Router("/querycode", &front.DoorController{}, "post:QueryInvitationCode") // 查询邀请码
	beego.Router("/register", &front.RegisterController{})

	// 前端公共/wish/wish
	beego.Router("/frontshare/lottery", &front.LotteryController{}, "post:Lottery")
	beego.Router("/frontshare/lotteryquery", &front.LotteryController{}, "*:LotteryQuery")
	beego.Router("/share", &front.ShareController{})
	//月签到
	beego.Router("/monthsign", &monthsigninapi.MonthSigninApiController{})
	beego.Router("/monthsignin/login", &monthsigninapi.MonthSigninApiController{}, "post:Login")
	beego.Router("/monthsignin/signin", &monthsigninapi.MonthSigninApiController{}, "post:SignIn")
	beego.Router("/monthsignin/querygift", &monthsigninapi.MonthSigninApiController{}, "post:QueryGift")
	beego.Router("/monthsignin/logout", &monthsigninapi.MonthSigninApiController{}, "post:Logout")
	beego.Router("/monthsignin/daygift", &monthsigninapi.MonthSigninApiController{}, "post:QueryDaysGift")
	beego.Router("/monthsignin/getdaygift", &monthsigninapi.MonthSigninApiController{}, "post:GetDaysGift")
	beego.Router("/monthsignin/retroactive", &monthsigninapi.MonthSigninApiController{}, "post:Retroactive")
	//VIP账号价值查询
	beego.Router("/vipvalue", &vipvalueapi.VipValueApiController{})
	// 秒杀
	beego.Router("/sec", &sec.SecApiController{})
	// 秒杀抢购组合活动
	beego.Router("/seckill", &seckill.SeckillApiController{})
	// 博饼
	beego.Router("/bobing", &bobingapi.BobingFrontController{})
	//赌王争霸
	beego.Router("/kingrace", &KingRaceapi.KingRaceApiController{})
	//幸运免单
	beego.Router("/luckyfree", &luckyfree.LuckyFreeApiController{})
	//宝箱
	beego.Router("/box", &boxapi.BoxApiController{})
	beego.Router("/box/lotteryquery", &boxapi.BoxApiController{}, "post:LotteryQuery")
	// 签到
	beego.Router("/signin", &signinapi.SigninApiController{})
	beego.Router("/signin/carvup", &signinapi.SigninCarveUPApiController{})
	beego.Router("/signin/page", &signinapi.SigninApiController{}, "post:SigninPage")
	beego.Router("/signin/querydynamic", &signinapi.SigninApiController{}, "post:QueryDynamic")
	// 周签到
	beego.Router("/weeksignin", &weeksignin.WeekSigninApiController{})
	//添加评论
	beego.Router("/add/share", &signinapi.AddMomentApiController{})
	// 投票活动(总奖池版)
	beego.Router("/fifa2018", &voteapi.Fifa2018ApiController{})                    // 世界杯专题
	beego.Router("/fifa2018/teams", &voteapi.Fifa2018ApiController{}, "get:Teams") // 世界杯专题
	beego.Router("/fifa2018/vote", &voteapi.Fifa2018ApiController{}, "get:Vote")   // 世界杯专题
	// 投票活动(奖池因子版)
	beego.Router("/vote", &voteapi.VoteApiController{})
	beego.Router("/vote/go", &voteapi.VoteApiController{}, "post:VoteGo")
	beego.Router("/vote/search", &voteapi.VoteApiController{}, "get:Search")
	beego.Router("/fifa", &voteapi.FifaApiController{})                    // 世界杯专题
	beego.Router("/fifa/teams", &voteapi.FifaApiController{}, "get:Teams") // 世界杯专题
	beego.Router("/fifa/vote", &voteapi.FifaApiController{}, "get:Vote")   // 世界杯专题
	//投票活动（总奖池版）
	beego.Router("/vote2", &voteapi.VoteApiController{})
	beego.Router("/vote2/go", &voteapi.VoteApiController{}, "post:VoteGo")
	// 金管家
	beego.Router("/upgrading", &upgradingapi.UpgradingApiController{})
	beego.Router("/upgrading/query", &upgradingapi.UpgradingApiController{}, "get:Query")
	// 金管家嵌套页面
	beego.Router("/upgrading/iframe", &upgradingapi.UpgradingIframeController{})
	// 排行榜
	beego.Router("/ranking", &rankingapi.RankingApiController{})
	beego.Router("/ranking/query", &rankingapi.RankingApiController{}, "get:Query")
	beego.Router("/ranking/accountquery", &rankingapi.RankingApiController{}, "get:AccountQuery")
	// 老虎机
	beego.Router("/tiger", &tigerapi.TigerApiController{})
	// 积分活动
	beego.Router("/integral", &integralapi.IntegralApiController{})
	beego.Router("/integral/explain", &integralapi.IntegralApiController{}, "get:Explain")
	beego.Router("/integral/iframe", &integralapi.IntegralApiController{}, "get:Iframe")
	// 翻牌活动
	beego.Router("/poker", &pokerapi.PokerApiController{})
	// 问卷调查
	beego.Router("/quest", &questapi.QuestApiController{})
	// 问卷调查(计分版)
	beego.Router("/questscore", &questscoreapi.QuestscoreApiController{}, "*:Login")
	beego.Router("/questscore/index", &questscoreapi.QuestscoreApiController{})
	beego.Router("/questscore/result", &questscoreapi.QuestscoreApiController{}, "get:Result")
	beego.Router("/questscore/ranking", &questscoreapi.QuestscoreApiController{}, "get:Ranking")
	beego.Router("/questscore/category", &questscoreapi.CategoryapiController{})
	beego.Router("/questscore/correct", &questscoreapi.CorrectapiController{})
	// 大转盘
	beego.Router("/wheel", &wheelapi.WheelApiController{})
	// 砸金蛋
	beego.Router("/goldegg", &goldeggapi.GoldeggApiController{})
	beego.Router("/goldeggiframe", &goldeggapi.GoldeggIframeController{})
	// 红包
	beego.Router("/red", &redapi.RedApiController{})
	// 许愿活动
	beego.Router("/wish", &wishapi.WishApiController{})
	beego.Router("/wish/wish", &wishapi.WishApiController{}, "post:Wish")
	beego.Router("/wish/thumbs", &wishapi.WishApiController{}, "post:Thumbs")
	beego.Router("/wish/wishpage", &wishapi.WishApiController{}, "post:WishPage")
	beego.Router("/wish/allwish", &wishapi.WishApiController{}, "post:AllWish")
	// 大富翁活动
	beego.Router("/rich", &richapi.RichApiController{})
	beego.Router("/rich/login", &richapi.RichApiController{}, "post:Login")
	beego.Router("/rich/dice", &richapi.RichApiController{}, "post:Dice")
	beego.Router("/rich/levelgift", &richapi.RichApiController{}, "post:GetLevelGift")
	//刮刮乐活动
	beego.Router("/guagua", &guaguaapi.GuaGuaApiController{})
	// 全服通知服务
	beego.Router("/ws/join", &front.WsController{}, "get:Join")
	// 后台管理系统
	var adminRouter string = beego.AppConfig.String("adminrouter")

	beego.Router(adminRouter+"/game/index", &game.GameIndexController{})
	beego.Router(adminRouter+"/game/delone", &game.GameIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/game/enabled", &game.GameIndexController{}, "get:Enabled")
	beego.Router(adminRouter+"/game/add", &game.GameAddController{})
	beego.Router(adminRouter+"/game/edit", &game.GameEditController{})
	beego.Router(adminRouter+"/gameperiod/index", &gameperiod.GamePeriodIndexController{})
	beego.Router(adminRouter+"/gameperiod/addtime", &gameperiod.GamePeriodAddController{})
	beego.Router(adminRouter+"/gameperiod/delone", &gameperiod.GamePeriodIndexController{}, "get:Delone")

	beego.Router(adminRouter+"/mb/index", &member.MemberIndexController{})
	beego.Router(adminRouter+"/mb/delone", &member.MemberIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/mb/import", &member.MemberIndexController{}, "post:Import")
	beego.Router(adminRouter+"/mb/delbatch", &member.MemberIndexController{}, "post:Delbatch")
	beego.Router(adminRouter+"/mb/reboot", &member.MemberIndexController{}, "post:RebootSign")
	beego.Router(adminRouter+"/mb/importsign", &member.MemberIndexController{}, "post:ImportSign")
	beego.Router(adminRouter+"/mb/add", &member.MemberAddController{})
	beego.Router(adminRouter+"/mb/edit", &member.MemberEditController{})

	beego.Router(adminRouter+"/gift/index", &gift.GiftIndexController{})
	beego.Router(adminRouter+"/gift/delone", &gift.GiftIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/gift/add", &gift.GiftAddController{})
	beego.Router(adminRouter+"/gift/edit", &gift.GiftEditController{})
	//抽奖次数
	beego.Router(adminRouter+"/memlottery/index", &memberlottery.MemberLotteryIndexController{})
	beego.Router(adminRouter+"/memlottery/delone", &memberlottery.MemberLotteryIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/memlottery/delbatch", &memberlottery.MemberLotteryIndexController{}, "post:Delbatch")
	beego.Router(adminRouter+"/memlottery/import", &memberlottery.MemberLotteryIndexController{}, "post:Import")
	beego.Router(adminRouter+"/memlottery/add", &memberlottery.MemberLotteryAddController{})
	beego.Router(adminRouter+"/memlottery/edit", &memberlottery.MemberLotteryEditController{})
	//内定会员
	beego.Router(adminRouter+"/assignmem/index", &assignmember.AssignMemberIndexController{})
	beego.Router(adminRouter+"/assignmem/delone", &assignmember.AssignMemberIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/assignmem/import", &assignmember.AssignMemberIndexController{}, "post:Import")
	beego.Router(adminRouter+"/assignmem/add", &assignmember.AssignMemberAddController{})
	beego.Router(adminRouter+"/assignmem/edit", &assignmember.AssignMemberEditController{})
	beego.Router(adminRouter+"/assignmem/deleall", &assignmember.AssignMemberIndexController{}, "post:Delbatch")
	//许愿活动
	beego.Router(adminRouter+"/wish/index", &wish.WishIndexController{})
	beego.Router(adminRouter+"/wish/delone", &wish.WishIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/wish/enabled", &wish.WishIndexController{}, "get:Enabled")
	beego.Router(adminRouter+"/wish/reward", &wish.WishIndexController{}, "post:Reward")
	beego.Router(adminRouter+"/wish/export", &wish.WishIndexController{}, "post:Export")
	beego.Router(adminRouter+"/wish/CheckboxDelone", &wish.WishIndexController{}, "post:CheckboxDelone")
	//中奖记录
	beego.Router(adminRouter+"/rewardlog/index", &rewardlog.RewardLogIndexController{})
	beego.Router(adminRouter+"/rewardlog/delone", &rewardlog.RewardLogIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/rewardlog/delivered", &rewardlog.RewardLogIndexController{}, "get:Delivered")
	beego.Router(adminRouter+"/rewardlog/deliveredbatch", &rewardlog.RewardLogIndexController{}, "post:Deliveredbatch")
	beego.Router(adminRouter+"/rewardlog/deleteall", &rewardlog.RewardLogIndexController{}, "post:Delbatch")
	beego.Router(adminRouter+"/rewardlog/import", &rewardlog.RewardLogIndexController{}, "post:Import")
	beego.Router(adminRouter+"/rewardlog/add", &rewardlog.RewardLogAddController{})
	beego.Router(adminRouter+"/rewardlog/edit", &rewardlog.RewardLogEditController{})
	//分享记录
	beego.Router(adminRouter+"/sharedetail/index", &sharedetail.ShareDetailIndexController{})
	beego.Router(adminRouter+"/sharedetail/delone", &sharedetail.ShareDetailIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/sharedetail/export", &sharedetail.ShareDetailIndexController{}, "get:Export")
	//评论记录
	beego.Router(adminRouter+"/comment/index", &comment.CommentIndexController{})
	beego.Router(adminRouter+"/comment/del", &comment.CommentIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/comment/status", &comment.CommentIndexController{}, "get:Status")
	beego.Router(adminRouter+"/comment/tag", &comment.CommentIndexController{}, "post:Tag")
	// 大富翁活动
	beego.Router(adminRouter+"/richattr/index", &rich.RichAttributeIndexController{})
	beego.Router(adminRouter+"/richstep/index", &rich.RichStepIndexController{})
	beego.Router(adminRouter+"/richstep/delone", &rich.RichStepIndexController{}, "get:Delone")
	// 大转盘活动
	beego.Router(adminRouter+"/wheelattr/index", &wheel.WheelAttributeIndexController{})
	// 问卷调查
	beego.Router(adminRouter+"/quest/index", &question.QuestionIndexController{})
	beego.Router(adminRouter+"/quest/delone", &question.QuestionIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/questanswer/index", &question.QuestionAnswerIndexController{})
	beego.Router(adminRouter+"/questanswer/export", &question.QuestionAnswerIndexController{}, "get:Export")
	// 问卷调查(计分版)
	beego.Router(adminRouter+"/questscore/index", &questionscore.QuestionscoreIndexController{})
	beego.Router(adminRouter+"/questscore/delone", &questionscore.QuestionscoreIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/questscor/import", &questionscore.QuestionscoreIndexController{}, "post:Import")
	beego.Router(adminRouter+"/questscore/batchdel", &questionscore.QuestionscoreIndexController{}, "post:Batchdel")
	beego.Router(adminRouter+"/questscoreanswer/modify", &questionscore.QuestionscoreIndexController{}, "post:ModifyAttr")

	beego.Router(adminRouter+"/questscoreanswer/index", &questionscore.QuestionscoreAnswerIndexController{})
	beego.Router(adminRouter+"/questscoreanswer/export", &questionscore.QuestionscoreAnswerIndexController{}, "get:Export")
	// 积分商城
	// 商品
	beego.Router(adminRouter+"/goods/index", &integral.GoodsIndexController{})
	beego.Router(adminRouter+"/goods/delone", &integral.GoodsIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/goods/add", &integral.GoodsAddController{})
	beego.Router(adminRouter+"/goods/edit", &integral.GoodsEditController{})
	// 积分管理
	beego.Router(adminRouter+"/integral/index", &integral.IntegralIndexController{})
	beego.Router(adminRouter+"/integral/delone", &integral.IntegralIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/integral/delbatch", &integral.IntegralIndexController{}, "post:Delbatch")
	beego.Router(adminRouter+"/integral/import", &integral.IntegralIndexController{}, "post:Import")
	beego.Router(adminRouter+"/integral/add", &integral.IntegralAddController{})
	beego.Router(adminRouter+"/integral/edit", &integral.IntegralEditController{})
	//投注排行榜
	beego.Router(adminRouter+"/ranking/index", &ranking.RankingIndexController{})
	beego.Router(adminRouter+"/ranking/add", &ranking.AddRankingController{})
	beego.Router(adminRouter+"/ranking/edit", &ranking.EditRankingController{})
	beego.Router(adminRouter+"/ranking/del", &ranking.RankingIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/ranking/del", &ranking.RankingIndexController{}, "post:Delbatch")
	beego.Router(adminRouter+"/ranking/import", &ranking.RankingIndexController{}, "post:Import")
	//投注排行榜配置信息
	beego.Router(adminRouter+"/rankingconfig/index", &rankingconfig.RankingConfigIndexController{})
	beego.Router(adminRouter+"/rankingconfig/add", &rankingconfig.AddRankingConfigController{})
	beego.Router(adminRouter+"/rankingconfig/edit", &rankingconfig.EditRankingConfigController{})
	beego.Router(adminRouter+"/rankingconfig/delone", &rankingconfig.RankingConfigIndexController{}, "get:Delone")
	//投注排行搒派奖信息
	beego.Router(adminRouter+"/rakningdeliver/deliver", &rankingdeliver.RankingDeliverIndexController{})
	beego.Router(adminRouter+"/rakningdeliver/create", &rankingdeliver.RankingDeliverIndexController{}, "post:CreateDelivered")
	beego.Router(adminRouter+"/rakningdeliver/createtotal", &rankingdeliver.RankingDeliverIndexController{}, "post:CreateTotal")
	beego.Router(adminRouter+"/rakningdeliver/Delivered", &rankingdeliver.RankingDeliverIndexController{}, "get:Delivered")
	beego.Router(adminRouter+"/rakningdeliver/Deliveredbatch", &rankingdeliver.RankingDeliverIndexController{}, "post:Deliveredbatch")
	beego.Router(adminRouter+"/rakningdeliver/export", &rankingdeliver.RankingDeliverIndexController{}, "post:Export")
	//电子金管家
	//配置信息
	beego.Router(adminRouter+"/upgradingconfig/index", &upgrading.UpgradingAttribute{})
	beego.Router(adminRouter+"/upgradingconfig/add", &upgrading.AddUpgradingAttribute{})
	beego.Router(adminRouter+"/upgradingconfig/edit", &upgrading.EditUpgradingAttribute{})
	beego.Router(adminRouter+"/upgradingconfig/delone", &upgrading.UpgradingAttribute{}, "get:Delone")
	//电子金管家周信息
	beego.Router(adminRouter+"/upgradingweek/index", &upgrading.UpgradingWeekController{})
	beego.Router(adminRouter+"/upgradingweek/add", &upgrading.AddUpgradingWeekController{})
	beego.Router(adminRouter+"/upgradingweek/edit", &upgrading.EditUpgradingWeekController{})
	beego.Router(adminRouter+"/upgradingweek/delone", &upgrading.UpgradingWeekController{}, "get:Delone")
	beego.Router(adminRouter+"/upgradingweek/import", &upgrading.UpgradingWeekController{}, "post:Import")
	beego.Router(adminRouter+"/upgradingweek/Delbatch", &upgrading.UpgradingWeekController{}, "post:Delbatch")
	beego.Router(adminRouter+"/upgradingweek/delivered", &upgrading.UpgradingWeekController{}, "get:Delivered")
	beego.Router(adminRouter+"/upgradingweek/deliveredbatch", &upgrading.UpgradingWeekController{}, "post:Deliveredbatch")
	beego.Router(adminRouter+"/upgradingweek/Countgift", &upgrading.UpgradingWeekController{}, "post:CountGift")
	//电子金管家总信息
	beego.Router(adminRouter+"/upgrading/index", &upgrading.UpgradingController{})
	beego.Router(adminRouter+"/upgrading/export", &upgrading.UpgradingController{}, "post:Export")
	beego.Router(adminRouter+"/upgrading/delbatch", &upgrading.UpgradingController{}, "post:Delbatch")
	beego.Router(adminRouter+"/upgrading/createtotal", &upgrading.UpgradingController{}, "post:CreateTotal")
	beego.Router(adminRouter+"/upgrading/countweek", &upgrading.UpgradingController{}, "post:CountWeek")
	beego.Router(adminRouter+"/upgrading/countmonth", &upgrading.UpgradingController{}, "post:CountMonth")
	beego.Router(adminRouter+"/upgrading/edit", &upgrading.UpgradingEditController{})
	beego.Router(adminRouter+"/upgrading/import", &upgrading.UpgradingController{}, "post:Import")
	// 投票活动-投票详情
	beego.Router(adminRouter+"/votedetail/index", &vote.VoteDetailIndexController{})
	beego.Router(adminRouter+"/votedetail/delone", &vote.VoteDetailIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/votedetail/export", &vote.VoteDetailIndexController{}, "get:Export")
	// 投票活动-选票(奖池因子版)
	beego.Router(adminRouter+"/voteitem/index", &vote.VoteItemIndexController{})
	beego.Router(adminRouter+"/voteitem/delone", &vote.VoteItemIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/voteitem/add", &vote.VoteItemAddController{})
	beego.Router(adminRouter+"/voteitem/edit", &vote.VoteItemEditController{})
	beego.Router(adminRouter+"/voteitem/modifyfactor", &vote.VoteItemIndexController{}, "post:ModifyFactor")
	beego.Router(adminRouter+"/voteitem/markflag", &vote.VoteItemIndexController{}, "get:MarkFlag")
	beego.Router(adminRouter+"/voteitem/generate", &vote.VoteItemIndexController{}, "get:Generate")
	// 投票活动-选票(总奖池版)
	beego.Router(adminRouter+"/voteitem2/index", &vote.VoteItem2IndexController{})
	beego.Router(adminRouter+"/voteitem2/delone", &vote.VoteItem2IndexController{}, "get:Delone")
	beego.Router(adminRouter+"/voteitem2/add", &vote.VoteItem2AddController{})
	beego.Router(adminRouter+"/voteitem2/edit", &vote.VoteItem2EditController{})
	beego.Router(adminRouter+"/voteitem2/modifyprize", &vote.VoteItem2IndexController{}, "post:ModifyPrize")
	beego.Router(adminRouter+"/voteitem2/markflag", &vote.VoteItem2IndexController{}, "get:MarkFlag")
	beego.Router(adminRouter+"/voteitem2/generate", &vote.VoteItem2IndexController{}, "get:Generate")
	// 签到活动-签到等级
	beego.Router(adminRouter+"/signinlevel/index", &signin.SigninLevelIndexController{})
	beego.Router(adminRouter+"/signinlevel/delone", &signin.SigninLevelIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/signinlevel/add", &signin.SigninLevelAddController{})
	beego.Router(adminRouter+"/signinlevel/edit", &signin.SigninLevelEditController{})
	beego.Router(adminRouter+"/signinlevel/modifyattr", &signin.SigninLevelIndexController{}, "post:ModifyAttr")
	beego.Router(adminRouter+"/signinlevel/uplodimg", &signin.SigninLevelIndexController{}, "post:UplodImg")
	//开宝箱活动
	beego.Router(adminRouter+"/check/index", &box.BoxIndexController{})
	beego.Router(adminRouter+"/check/delone", &box.BoxIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/check/add", &box.BoxAddController{})
	//秒杀和抢购
	beego.Router(adminRouter+"/seckillandrush/index", &seckillandrush2.SeckillAndRushIndexController{})
	beego.Router(adminRouter+"/seckillandrush/delone", &seckillandrush2.SeckillAndRushIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/seckillandrush/add", &seckillandrush2.SeckillAndRushAddController{})

	//VIP账号查询
	beego.Router(adminRouter+"/vipvalue/index", &vipvalue.VipValueIndexController{})
	beego.Router(adminRouter+"/vipvalue/delone", &vipvalue.VipValueIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/vipvalue/batchdel", &vipvalue.VipValueIndexController{}, "post:BatchDel")
	beego.Router(adminRouter+"/vipvalue/import", &vipvalue.VipValueIndexController{}, "post:Import")
	beego.Router(adminRouter+"/vipvalue/add", &vipvalue.VipValueAddController{})
	beego.Router(adminRouter+"/vipvalue/edit", &vipvalue.VipValueEditController{})
	//月签到
	beego.Router(adminRouter+"/ms/index", &monthsignin.MonthsigninBetIndexController{})
	beego.Router(adminRouter+"/ms/delone", &monthsignin.MonthsigninBetIndexController{}, "get:Delone")
	beego.Router(adminRouter+"/ms/delbatch", &monthsignin.MonthsigninBetIndexController{}, "post:DelBatch")
	beego.Router(adminRouter+"/ms/import", &monthsignin.MonthsigninBetIndexController{}, "post:Import")
	beego.Router(adminRouter+"/ms/add", &monthsignin.MonthsigninBetAddController{})
	beego.Router(adminRouter+"/ms/edit", &monthsignin.MonthsigninBetEditController{})
}
