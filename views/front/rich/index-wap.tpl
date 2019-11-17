<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/rich/wap/css/base.css">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/rich/wap/css/dicepostion.css">
    <script type="text/javascript" src="{{static_front}}/static/front/rich/wap/js/respond.min.js"></script>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/rich/wap/css/css.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<!-- 头部开始 -->
<header class="dd_hd" id="hometop">
    <div class="hd_comm">
        <div style=" width:120px; margin:0 auto;"><a href="/rich"><span class="dd_logo"></span></a></div>
        <div style="right:32px;top:15px;position:absolute; ">
            <ul class="top_nav">
                <!-- 登录选项<li><a class="loginOr-reg login" href="javascript:;" onclick="document.getElementById('light1').style.display='block'; document.getElementById('fade').style.display='block'" style=" color:#fff; font-size: 1rem;">登录</a></li>-->
                <li id="d-k"><a href="/query?gid={{.gameId}}" class="dd_cart12"></a></li>
            </ul>
        </div>
    </div>
</header>
<!-- 头部结束 -->
<!-- 大富翁游戏框 -->
<div class="go-gridTop-box go-grid-box"
   {{/* {{if eq 2 .currentStage}} style="background: url({{static_front}}/static/front/rich/wap/images/m-bg2.jpg) center 40px no-repeat;"
    {{else if eq 3 .currentStage}}style="background: url({{static_front}}/static/front/rich/wap/images/m-bg3.jpg) center 40px no-repeat;"
    {{else if eq 4 .currentStage}}style="background: url({{static_front}}/static/front/rich/wap/images/m-bg4.jpg) center 40px no-repeat;"
    {{else if eq 5 .currentStage}}style="background: url({{static_front}}/static/front/rich/wap/images/m-bg5.jpg) center 40px no-repeat;"
    {{end}}*/}}>
    <div style="margin: 0 auto; width:360px; padding-top:20px;">
        <ul class="go-grid-game">
            {{range $i,$v := .stepArr}}
                <li class="grid-num{{numberAdd $i 1}}" data-index="{{numberAdd $i 1}}">
                    {{if (map_get $.giftPhotoMap (numberAdd $i 1))}}
                        <img class="allGrid grid-num{{numberAdd $i 1}}" src="{{map_get $.giftPhotoMap (numberAdd $i 1)}}">
                    {{else}}
                        {{numberAdd $i 1}}
                    {{end}}
                </li>
            {{end}}
            {{if lt .currentStage .totalStage}}
                <li class="grid-num31" data-index="31">
                    <a href='{{urlfor "RichApiController.Get" "gid" .gameId "stage" (numberAdd .currentStage 1) }}'>下一关</a>
                </li>
            {{else}}
                <li class="grid-num31">
                    <a href="javascript:void(0);">终点</a>
                </li>
            {{end}}
        </ul>
        <em class="userKu-icon" id="kuBao-icon"></em>
        <a href="javascript:;" class="throw-dice" id="throwDice"></a>
        <a href="javascript:;" class="throw-dices" onclick="getLevelGift()" id="levelgift"></a>
        <!-- 以下是新版骰子效果，不支持IE -->
        <div class="dicenewWrap">
            <div class="dicenew dicenew1">
                <div class="dot"></div>
            </div>
            <div class="dicenew dicenew1 inner"></div>
            <div class="dicenew dicenew2">
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
            <div class="dicenew dicenew2 inner"></div>
            <div class="dicenew dicenew3">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
            <div class="dicenew dicenew3 inner"></div>
            <div class="dicenew dicenew4">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
            <div class="dicenew dicenew4 inner"></div>
            <div class="dicenew dicenew5">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
            <div class="dicenew dicenew5 inner"></div>
            <div class="dicenew dicenew6">
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>
            <div class="dicenew dicenew6 inner"></div>
            <div class="dicenew cover x"></div>
            <div class="dicenew cover y"></div>
            <div class="dicenew cover z"></div>
        </div>
        <!-- 以上是新版骰子效果，不支持IE -->
        <span class="dice-icon" id="diceIcon" style="display:none;"></span>
    </div>
</div>
<!-- 游戏框中间显示会员各项信息 -->
<div class="go-gridBottom-box go-grid-box">
    <div class="w1200 ">
        <div class="remnant-info">
            总关卡：{{.totalStage}}<br>
            当前关卡：<span id="currentStage">{{.currentStage}}</span>
        </div>
        <div class="remnant-infos">
            过本关卡奖励 {{if eq 1 .currentStage}}8元
            {{else if eq 2 .currentStage}}18元
            {{else if eq 3 .currentStage}}38元
            {{else if eq 4 .currentStage}}68元
            {{else if eq 5 .currentStage}}88元
            {{else if eq 6 .currentStage}}128元
            {{else if eq 7 .currentStage}}168元
            {{else if eq 8 .currentStage}}188元
            {{end}}
        </div>
        <div class="infos2">
            <div class="infosSon" >本关投掷次数获得方式：</div>
            {{if eq 1 .currentStage}}
                1.每日自动获得 次数+1 <br>
                2.昨日打码100以上次数+1
            {{else if eq 2 .currentStage}}
                1.昨日打码100+  次数+1 <br>
                2.昨日线上【银行转账】通道充值100以上次数+1
            {{else if eq 3 .currentStage}}
                1.昨日打码100+  次数+1 <br>
                2.昨日线上【银行转账】通道充值100以上次数+1
            {{else if eq 4 .currentStage}}
                1.昨日线上【银联支付】通道充值100以上次数+1<br>
                2.昨日大发六合彩游戏投注500以上次数+1
            {{else if eq 5 .currentStage}}
                1.昨日线上【银联支付】通道充值100以上次数+1<br>
                2.昨日大发六合彩游戏投注500以上次数+1
            {{else if eq 6 .currentStage}}
                1.昨日线上【银联支付】通道充值100以上次数+1<br>
                2.昨日大发六合彩游戏投注500以上次数+1
            {{else if eq 7 .currentStage}}
                昨日线上【银行转账】或【银联支付】通道充值200以上次数+1
            {{else if eq 8 .currentStage}}
                昨日线上【银行转账】或【银联支付】通道充值200以上次数+1
            {{end}}
        </div>
        <!--登录后显示的会员信息和退出按钮-->
        <div class="remnant-info2" style="{{if eq .loginAccount ""}}display:none;{{end}}">会员：<span
                    id="loginAccount">{{.loginAccount}}</span> <a href="javascript:;" onclick="exit()"><img
                        src="{{static_front}}/static/front/rich/wap/images/exit.png"></a>
        </div>
        <!--结束登录后显示的会员信息和退出按钮-->
        <div class="remnant-info" style="top:300px;">
            您在第<span id="accountStage">{{if .accountStage}}{{.accountStage}}{{else}}1{{end}}</span>关
            第<span id="accountStep">{{if .accountStep}}{{.accountStep}}{{else}}0{{end}}</span>步</br>
            剩余投掷次数：<span id="lotteryNums">0</span>
        </div>
        <div class="throwDice-infoBox">
            <div class="infoBox-top clearfix"><b class="fl">活动倒计时：<br>
                    <span class="bai">{{.gameMsg}}</span></b>
            </div>
        </div>
    </div>
</div>
<!-- 活动动态 -->
<div class="actDynamic-box go-grid-box">
    <div class="w1200">
        <div class="actDynamic clearfix">
            <div class="fl actDynamic-r clearfix"><span class="fl title">活动动态：</span>
                <div class="fl clearfix dynamic-box" id="scroll-box">
                    <ul id="scroll-start">
                        {{range $index, $vo := .rlList}}
                            <li>恭喜 {{$vo.account}} 获得 {{$vo.gift}} !</li>
                        {{end}}
                    </ul>
                    <ul id="scroll-end">
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- 活动说明 -->
<div class="act-rule-box grid-rel">
    <div class="w1200">
        <h2 class="zillion-h2">活动说明</h2>
        <div class="act-rule">
            {{str2html .gameRule}}
        </div>
    </div>
</div>
<div class="act-rule-box grid-rel">
    <div class="w1200">
        <h2 class="zillion-h2">活动细则</h2>
        <div class="act-rule">
            {{str2html .gameStatement}}
        </div>
    </div>
</div>
<!-- 页面底部结束 -->
<!-- 中奖弹窗 -->
<div class="down-limit" id="zillion-winSack-wd" style="display:none;">
    <div class="bgimg"></div>
    <div class="zillion-pub-wd ">
        <div class="zillWd-head">
            <!-- 库宝 -->
            <em class="kuBao-icon kuBao-priIcon" style="margin-bottom:30px;"></em>
            <!-- 关闭按钮 -->
            <em class="close-btn" id="closeBtn">×</em></div>
        <div class="zillWd-body">
            <div class="zillWd-info">哎呦，运气不错哦，恭喜您获得</div>
            <div class="zill-price" id="priceMsg" style="padding:20px 0 23px;"></div>
            <a style="margin-top:50px;" href="javascript:;" class="zillWd-btn" id="noPrice-btn">关闭</a></div>
    </div>
</div>
</div>
<!-- 没中奖弹窗 -->
<div class="down-limit" id="zillion-noPrice" style="display:none;">
    <div class="bgimg"></div>
    <!-- 没中奖 -->
    <div class="zillion-pub-wd">
        <div class="zillWd-head">
            <!-- 库宝 -->
            <em class="kuBao-icon kuBao-failIcon" style="margin-bottom:30px;"></em></div>
        <div class="zillWd-body">
            <div class="zillWd-info">哎呀，此次没有中奖，再接再厉！</div>
            <a style="margin-top:50px;" href="javascript:;" class="zillWd-btn" id="noPrice-btn">关闭</a></div>
    </div>
</div>
<!--大富翁登陆-->
<div id="light1" class="white_content1">
    <div class="cxbox"><a href="javascript:void(0)" style="color:#000000;font-weight: bold;text-decoration:none;"
                          onClick="document.getElementById('light1').style.display='none';document.getElementById('fade').style.display='none'"
                          class="gban"><img src="{{static_front}}/static/front/rich/wap/images/close.png"
                                            alt=""/></a>
        <div class="cxbox_hy" style=" height: 150px;padding: 20px 0 0 30px; ">
            <input name="querycode" id="account" type="text" value="" placeholder="输入帐号"/>
            <button id="login1" class="stat" type="button" name="button"></button>
        </div>
    </div>
    <div id="fade" class="black_overlay"></div>
</div>
<!--大富翁登陆  end-->
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/rich/wap/js/dice.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script language="javascript" type="text/javascript">
    var isIE = false;

    //退出
    function exit() {
        $.ajax({
            url: '/logout',
            dataType: 'json',
            cache: false,
            type: 'GET',
            success: function (obj) {
                localStorage.clear();
                window.location.reload();
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var x = 1;
            }
        })
    }

    //登录
    $("#login1").click(function () {
        if ($("#account").val() == "") {
            layer.msg("会员账号不能为空");
            return
        }
        login();
    });

    function login() {
        $.post('{{urlfor "RichApiController.Login"}}', {
                gid: $("#gid").val(),
                account: $("#account").val()
            },
            function (res) {
                layer.msg(res.msg);
                if (res.code == 1) {
                    _username = $("#account").val();
                    localStorage.username = _username;
                    $('.logined').fadeIn();
                    setTimeout(function () {
                        location.href = res.data || location.href;
                    }, 1000);
                }
            });
    }

    //显示会员剩余投资次数
    $(function () {
        $("#lotteryNums").text({{.lotteryNums}});
        var bl = {{.addLottery}};
        if (bl === true) {
            layer.open({
                title: '恭喜您',
                content: '已为您免费添加一次抽奖次数'
            })
        }
        {{if eq .accountStage .currentStage}}
        $(document).ready(function () {
            kubaoMove({{$.accountStep}})
        });
        {{end}}
    });
</script>
<script>
    function getLevelGift() {
        var gid = $("#gid").val();
        var account = {{.loginAccount}};
        var stage ={{.currentStage}};
        if (account == "") {
            layer.msg("请登录后再进行领取");
            return
        }
        layer.open({
            type: 1,
            title: '获取过关奖励',
            btn: ['提交', '取消'],
            content: '<div style="padding: 30px" ><input type="number" style="outline-style:none; border: 1px solid #ccc;border-radius: 3px; padding: 13px 14px;width:5rem;font-weight: 700; font-size: 14px; " id="mobile" placeholder="请输入您的手机号" ></div>',
            yes: function () {
                $.ajax({
                    url: {{urlfor "RichApiController.GetLevelGift"}},
                    type: "post",
                    data: {"gid": gid, "account": account, "stage": stage, "mobile": $("#mobile").val()},
                    success: function (info) {
                        if (info.code === 1) {
                            layer.closeAll();
                        } else {
                            $("#mobile").val("");
                        }
                        layer.msg(info.msg);
                    },
                });
            }
        });
    }
</script>
</body>
</html>