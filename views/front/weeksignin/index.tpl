<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Expires" content="0"/>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/css/common-pc.css"/>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/weeksignin/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/weeksignin/css/responsive.css"/>
</head>
<body>
<div id="wrap" class="clearfix">
    <div id="wrapper-header">
        <div id="header" class="clearfix">
            <div class="mobile-menu-btn"></div>
            <div class="wrapper-slide-menu">
                <ul class="slide-menu">
                    <li><a href="{{.officialSite}}">官网首页</a></li>
                    <li><a href="{{.officialPromot}}">优惠活动</a></li>
                    <li><a href="{{.officialRegist}}">免费注册</a></li>
                    <li><a href="{{.custServ}}">在线客服</a></li>
                </ul>
            </div>
            <h1 id="logo"><a href="index.html"><img src="{{static_front}}/static/img/logo240x80.png" alt="{{.siteName}}"/></a></h1>
            <div id="menu">
                <ul class="clearfix">
                    <li class="navItem"><a href="{{.officialSite}}">官网首页</a></li>
                    <li class="navItem"><a href="{{.officialPromot}}">优惠活动</a></li>
                    <li class="navItem"><a href="{{.officialRegist}}">免费注册</a></li>
                    <li class="navItem"><a href="{{.custServ}}">在线客服</a></li>
                </ul>
            </div>
            <div id="langDeskTopMenu">
                <div id="langDeskTopOptionDiv"></div>
            </div>
        </div>
    </div>

    <div class="content event" id="contentEventDiv">
        <div id="eventBanner">
            <img id="eventImg" {{if eq .gameStatus 2}}src="{{static_front}}/static/front/weeksignin/images/guafen.jpg"{{else}} src="{{static_front}}/static/front/weeksignin/images/topbg.jpg"{{end}}/>
        </div>

        <div class="eventMain">
            <div class="reel" id="leftReel">
                <div class="reelHeader"></div>
                <div class="reelBody"></div>
            </div>
            <div class="reel" id="rightReel">
                <div class="reelHeader"></div>
                <div class="reelBody"></div>
            </div>
            <div class="goldBarDiv">
                <div class="goldBar"></div>
            </div>
            <div class="rankingSection" >

                <div {{if eq .gameStatus  2}} style="display:none"{{end}} id="eventRanking">
                    <div id="eventRankingTableDiv">
                        <div id="eventRankingTitleDiv">
                            <h1 id="eventRankingTitle" class="english">签到 <br class="rankingbr"/>奖金榜</h1></div>
                    </div>
                </div>
                <div class="rankingButtonBar">
                    <div class="rankinginput">
                        <input type="hidden" id="gid" value="{{.gameId}}">
                        <input type="text" id="account" name="account" placeholder="请输入会员账号">
                        <div class="rankingBtn1">
                            {{if eq .gameStatus 2}}
                                <img  onclick="carveup({{.gameId}})" src="/static/front/weeksignin/images/signinguafen.png"
                                      style="cursor: pointer;">
                            {{else}}
                                <img id="rankDay1Btn" src="/static/front/weeksignin/images/signin.png"
                                     style="cursor: pointer;">
                            {{end}}
                        </div>
                    </div>
                    <div class="rankingBtn2" {{if eq .gameStatus 2}}style="display: none"{{end}}>
                        <a href="javascript:void(0);" class="rl_search">查看奖金记录&gt;&gt;</a>
                        <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="rl_search_mobile">查看奖金记录&gt;&gt;</a>
                    </div>
                </div>
            </div>
            <div id="ruleContainer">
                <div class="eventDiv" id="eventDiv-3">
                    <div class="wrapper-event" id="wrapper-rule">
                        <div class="wrapper-rule-col-2">
                            <div class="wrapper-rule-broder" id="rulePanel">
                                <img class="ruleTitleImg" src="/static/front/weeksignin/images/tx_rules.png"/>
                            {{str2html .gameRule}}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="eventTxtContainer">
                <div class="eventTxt" id="eventTxt">
                    <img class="ruleTitleImg" src="/static/front/weeksignin/images/tx_resp.png"/>
                {{str2html .gameStatement}}
                </div>
            </div>
        </div>
    </div>
    <div id="wrapper-footer">
        <div class="footer">
            <div class="inner"><p id="copyRightTxt">Copyright &copy;{{date .nowdt "Y"}} {{.siteName}} All rights
                reserved.</p></div>
        </div>
    </div>
    <div class="fries-wrapper" id="coinLayer"></div>
</div>
<!-- 中奖记录查询 开始 -->
<div id="rl_dialog" class="rldialog">
    <div class="rlbox">
        <div class="rlbox_bt">
            <span>输入会员账号查询</span>
            <a href="javascript:void(0);" class="rl_dialog_close">X</a>
        </div>
        <div class="rlbox_hy">
            <label>会员账号：</label><input name="rlquerycode" id="rlquerycode" type="text"  value="" placeholder="请输入会员帐号">
            <button type="button" class="rl_searchbtn">查 询</button>
        </div>
        <div class="rlbox_bd">
            <table width="480" border="0" cellpadding="0" cellspacing="0">
                <tr class="ad">
                    <td>签到奖励</td>
                    <td>签到时间</td>
                    <td>是否派彩</td>
                </tr>
                <tbody id="rl_content"></tbody>
            </table>
            <div class="rl_pages"></div>
        </div>
    </div>
</div>
<div id="rl_fade" class="rldialog_zz"></div>
<!-- 中奖记录查询 结束 -->

<!-- 返回顶部 开始 -->
<a href="javaScript:void(0);" class="go-top" style="display: inline;"><img src="{{static_front}}/static/front/img/gotop.svg"></a>
<!-- 返回顶部 结束 -->
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/common.js"></script>
<script>
    $(function () {
        $(".mobile-menu-btn").click(function () {
            if ($(".slide-menu").is(":hidden")) {
                $(".slide-menu").show();
            } else {
                $(".slide-menu").hide();
            }
        });
        $("#rankDay1Btn").one().click(function () {
            var account = $("#account").val();
            if (account == "") {
                layer.msg("请输入会员账号", {icon: 2});
                return;
            }
            $.ajax({
                url: '{{urlfor "WeekSigninApiController.Post"}}',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {"gid": $("#gid").val(), "account": account},
                success: function (obj) {
                    if (obj.code == 0) {
                        layer.msg(obj.msg, {icon: 2});
                    }  else if (obj.code == 1) {
                        var html = '';
                        html = '<div>恭喜您获得<span style="color:red;">&nbsp;' + obj.data.gift + '</span></div>';
                        layer.alert(html, {title: obj.msg, icon: 6});
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    layer.msg("请求异常，请稍后再试", {icon: 2});
                }
            })
        });
    });
</script>
</body>
</html>
