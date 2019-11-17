<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/rich/css/base.css">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/rich/css/dicepostion.css">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/rich/css/css.css">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/png">

</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="head-top-nav">
    <div class="w1200 h90 clearfix">
        <div class="logo-wrap fl">
            <a href='{{urlfor "RichApiController.Get"}}' class="logo"></a>
        </div>
        <div class="top-nav-menu fl">
            <ul class="clearfix">
                <li class="fl first">
                    <a role="button" href='{{urlfor "RichApiController.Get"}}' class="main">首页</a>
                </li>
                <li class="fl first">
                    <a class="main" role="button"
                       onClick="document.getElementById('light').style.display='block'; document.getElementById('fade').style.display='block'"
                       style=" cursor: pointer">中奖查询</a>
                </li>
                <li class="fl first">
                    <a role="button" href="{{.officialSite}}" target="_blank" class="main">{{.siteName}}官网</a>
                </li>
                <li class="fl first">
                    <a role="button" href="{{.custServ}}" target="_blank" class="main">在线客服</a>
                </li>
            </ul>
        </div>
        <div class="login-wrap fr">
            <!-- 未登录 -->
            <ul class="clearfix">
                <li class="fl">
                    <span id="loginAccount">{{.loginAccount}}</span>
                </li>
                <li class="fl" id="li-login" style="{{if .loginAccount}}display:none;{{end}}">
                    <a class="loginOr-reg login" href="javascript:;"
                       onClick="document.getElementById('light1').style.display='block'; document.getElementById('fade').style.display='block'"></a>
                </li>
                <li class="fl" id="li-logout" style="{{if eq .loginAccount ""}}display:none;{{end}}">
                    <a class="logout"
                       href='{{urlfor "DoorController.Logout" "url" (urlfor "RichApiController.Get" "gid" .gameId)}}'>退出</a>
                </li>
            </ul>
        </div>
    </div>
</div>
<!-- 大富翁游戏框 -->
<div class="go-gridTop-box go-grid-box"
     style='background-image:url({{or (index .bgArr 0) "/static/front/rich/images/zillion-sbg001.jpg"}});'>
    <div class="w1200 grid-rel">
        <ul class="go-grid-game">
            {{range $i,$v := .stepArr}}
                <li class="grid-num{{numberAdd $i 1}}" data-index="{{numberAdd $i 1}}">
                    {{if (map_get $.giftPhotoMap (numberAdd $i 1))}}
                        <img class="grid-num{{numberAdd $i 1}}" src="{{map_get $.giftPhotoMap (numberAdd $i 1)}}">
                    {{else}}
                        {{numberAdd $i 1}}
                    {{end}}
                </li>
            {{end}}
            {{if lt .currentStage .totalStage}}
                <li class="grid-num31" data-index="31"><a
                            href='{{urlfor "RichApiController.Get" "gid" .gameId "stage" (numberAdd .currentStage 1) }}'>下一关</a>
                </li>
            {{else}}
                <li class="grid-num31">结束</li>
            {{end}}
        </ul>
        <em class="start-point" id="startPoint"></em>
        <em class="userKu-icon" id="kuBao-icon"></em>
        <div class="remnant-infos">
            过本关卡奖励 {{if eq 1 .currentStage}}8
            {{else if eq 2 .currentStage}}18
            {{else if eq 3 .currentStage}}38
            {{else if eq 4 .currentStage}}68
            {{else if eq 5 .currentStage}}88
            {{else if eq 6 .currentStage}}128
            {{else if eq 7 .currentStage}}168
            {{else if eq 8 .currentStage}}188
            元彩金{{end}}
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
        <span class="dice-stage">总关卡：{{.totalStage}}&nbsp;&nbsp;&nbsp;&nbsp;
				当前关卡：<span id="currentStage">{{.currentStage}}</span></span>
        <a href="javascript:;" class="throw-dice" id="throwDice"></a>
        <a href="javascript:;" class="throw-dicee" id="levelgift" onclick="getLevelGift()"></a>
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
<div class="go-gridBottom-box go-grid-box"
     style='background-image:url({{or (index .bgArr 1) "/static/front/rich/images/zillion-sbg002.jpg"}});'>
    <div class="w1200 grid-rel">
        <div class="remnant-info">
            您在第<span id="accountStage">{{if .accountStage}}{{.accountStage}}{{else}}1{{end}}</span>关
            第<span id="accountStep">{{if .accountStep}}{{.accountStep}}{{else}}0{{end}}</span>步
            &nbsp;&nbsp;剩余投掷次数：<span id="lotteryNums">0</span>
        </div>
        <div class="throwDice-infoBox">
            <div class="infoBox-top clearfix">
                <b class="fl">活动倒计时：<span class="bai">{{.gameMsg}}</span></b>
            </div>
            <div class="infoBox-main">
                <p>{{.announcement}}
                </p>
            </div>
        </div>
    </div>
</div>
<!-- 活动动态 -->
<div class="actDynamic-box go-grid-box">
    <div class="w1200">
        <div class="actDynamic clearfix">
            <div class="fl actDynamic-r clearfix">
                <span class="fl title">活动动态：</span>
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
    <div class="w1200">
        <h2 class="zillion-h2">活动细则</h2>
        <div class="act-rule">
            <p>
                {{str2html .gameStatement}}
            </p>
        </div>
    </div>
</div>
<div class="footer-con">
    <div class="web-bottom">
        <div class="bottom-con w1200 clearfix">
            <a href="{{.officialSite}}">关于{{.siteName}}</a>
            {{if .officialRegist}}| <a href="{{.officialRegist}}">开户与存提款</a>{{end}}
            {{if .officialPartner}}| <a href="{{.officialPartner}}">合作经营条款与规则</a>{{end}}
            {{if .officialPromot}}| <a href="{{.officialPromot}}">优惠活动规则</a>{{end}}
            {{if .officialFqa}}| <a href="{{.officialFqa}}">博彩责任</a>{{end}}
            <p>本网站属于{{.siteName}}授权和监管，所有版权归{{.siteName}}，违者必究。
                <br>©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p>
        </div>
    </div>
</div>
<div class="down-limit" id="zillion-winSack-wd" style="display:none;">
    <div class="bgimg"></div>
    <!-- 中奖弹窗 -->
    <div class="zillion-pub-wd">
        <div class="zillWd-head">
            <!-- 库宝 -->
            <em class="kuBao-icon kuBao-priIcon" style="margin-bottom:30px;"></em>
            <!-- 关闭按钮 -->
            <em class="close-btn" id="closeBtn"><img src="{{static_front}}/static/front/rich/images/xy_06.png"></em>
        </div>
        <div class="zillWd-body">
            <div class="zillWd-info">哎呦，运气不错哦，恭喜您获得</div>
            <div class="zill-price" id="priceMsg" style="padding:20px 0 23px;"></div>
        </div>
    </div>
</div>
<div class="down-limit" id="zillion-noPrice" style="display:none;">
    <div class="bgimg"></div>
    <!-- 没中奖 -->
    <div class="zillion-pub-wd">
        <div class="zillWd-head">
            <!-- 库宝 -->
            <em class="kuBao-icon kuBao-failIcon" style="margin-bottom:30px;"></em>
        </div>
        <div class="zillWd-body">
            <div class="zillWd-info" id="noPriceMsg"></div>
            <a style="margin-top:50px;" href="javascript:;" class="zillWd-btn" id="noPrice-btn"></a>
        </div>
    </div>
</div>
<!--大富翁查询-->
<div id="light" class="white_content">
    <div class="cxbox">
        <div class="cxbox_bt">
            <div style=" position: absolute; left: 30%; top:0px;">
                <img src="{{static_front}}/static/front/rich/images/search.png" width="299" height="174" alt=""/>
            </div>
            <a href="javascript:void(0);" style="color:#000000;font-weight: bold;text-decoration:none;"
               onClick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'"
               class="gban">
                <img src="{{static_front}}/static/front/rich/images/xy_06.png">
            </a>
        </div>
        <div class="cxbox_hy"
             style=" height: 300px;padding: 100px 0 0 20px; background: url({{static_front}}/static/front/rich/images/d-bg.jpg) no-repeat;">
            <em class="kuBao-icon kuBao-priIcon" style="margin-bottom:30px;"></em>
            <p style="padding-left: 10px;">会员账号：</p>  <input id="queryAccount" type="text" value=""
                                                             placeholder="输入查询的会员帐号"/>
            <a href="javascript:queryBtn()" class="search11"></a>
            <div class="cxbox_bd"
                 style="color:#000000;font-weight: bold; overflow-y: scroll; width: 100%; height:230px; ">
                <table border="0" cellpadding="0" cellspacing="0" style=" width:98%;margin-top:10px;">
                    <tr class="ad">
                        <td>序号</td>
                        <td>奖品名称</td>
                        <td>中奖日期</td>
                        <td>是否派彩</td>
                    </tr>
                    <tbody id="queryContent">

                    </tbody>
                </table>
                <div class="quotes" style="padding:10px 0px;"></div>
            </div>
        </div>

    </div>
</div>
<div id="fade" class="black_overlay"></div>
<!--大富翁查询  end-->


<!--大富翁登陆-->
<div id="light1" class="white_content1">
    <div class="cxbox1" style=" width: 580px">
        <div class="cxbox_bt">
            <div style=" position: absolute; left: 28%; top:0px;">
                <img src="{{static_front}}/static/front/rich/images/login.png" width="299" height="174" alt=""/>
            </div>

            <a href="javascript:void(0)" style="color:#000000;font-weight: bold;text-decoration:none;"
               onClick="document.getElementById('light1').style.display='none';document.getElementById('fade').style.display='none';"
               class="gban">
                <img src="{{static_front}}/static/front/rich/images/xy_06.png">
            </a>
        </div>
        <div class="cxbox_hy"
             style=" height: 230px;padding: 100px 0 0 90px; background: url(/static/front/rich/images/d-bg.jpg) no-repeat;background-size:cover;">
            <p>会员账号：</p>
            <input name="account" id="account" type="text" value="" placeholder="请输入会员帐号"/>
            <button class="stat" type="button" id="login"></button>
        </div>
    </div>
    <div id="fade" class="black_overlay"></div>
    <!--大富翁登陆  end-->
</div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/rich/js/dice.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script type="text/javascript">
    var isIE = false;
    $("#login").click(function () {
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
            function (res, status) {
                layer.msg(res.msg);
                if (res.code == 1) {
                    _username = $("#account").val();
                    localStorage.username = _username;
                    setTimeout(function () {
                        location.href = res.data || location.href;
                    }, 1000);
                }
            });
    }

    function queryBtn() {
        if ($("#queryAccount").val() == "") {
            layer.msg("会员账号不能为空");
            return
        }
        $.post('{{urlfor "LotteryController.LotteryQuery"}}', {
                gid: $("#gid").val(),
                account: $("#queryAccount").val(),
                page: 1,
                pagesize: 1000
            },
            function (res, status) {
                console.log(res)
                if (res.code == 1) {
                    var html = "";
                    var list = res.data.list;
                    if (res.data.total > 0) {
                        for (var i = 0; i < list.length; i++) {
                            html = html + '<tr class="ad"><td>' + (i + 1) + "</td><td>"
                                + list[i].gift + "</td><td>"
                                + list[i].createDate + "</td><td>"
                                + (list[i].delivered == 1 ? "已派彩" : "未派彩") + "</td></tr>";
                        }
                    } else {
                        html = '<tr class="ad"><td colspan="3">没有中奖记录</td></tr>';
                    }
                    $("#queryContent").html(html);
                } else {
                    layer.msg(res.msg);
                }
            });
    }

    $(function () {
        $("#lotteryNums").text({{.lotteryNums}});
        var bl = {{.addLottery}};
        if (bl === true) {
            layer.open({
                title: '恭喜您',
                content: '已为您免费添加一次抽奖次数'
            })
        }
        $(document).ready(function () {
            {{if eq .accountStage .currentStage}}
            kubaoMove({{$.accountStep}});
            if (!!window.ActiveXObject || "ActiveXObject" in window) {
                isIE = true;
                layer.msg("为了获得更好的体验，请使用其他浏览器！");
            }
            {{end}}
        });
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
            content: '<div style="padding:30px;"><input type="number" style="outline-style:none; border: 1px solid #ccc;border-radius: 3px; padding: 13px 14px;width:270px;font-weight: 700; font-size: 14px; " type="number" id="mobile" placeholder="请输入您的手机号" ></div>',
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