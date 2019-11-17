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
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/signin/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/signin/css/responsive.css"/>
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
        <div class="eventMain">
            <div class="headd" style="text-align: center">
                <img src="/static/front/signin/images/top12.png">
            </div>
            <div class="rankingSection" >
                <div {{if eq .gameStatus  2}} style="display:none"{{end}} class="wrapper-feature-title" id="rankingImgTitle"><img id="imgTitle-1" src="{{static_front}}/static/front/signin/images/top10.png">
                </div>
                <div {{if eq .gameStatus  2}} style="display:none"{{end}} id="eventRanking">
                    <div id="eventRankingTableDiv">
                        <div id="eventRankingTitleDiv">
                            <h1 id="eventRankingTitle" class="english">签到 <br class="rankingbr"/>奖金榜</h1></div>
                        <table id="eventRankingTable">
                            <thead>
                            <th class="ranking">排名</th>
                            <th class="amount">奖金(元)</th>
                            <th class="account">会员</th>
                            <th class="account">等级</th>
                            </thead>
                            <tbody>
                            {{range $i,$v := .rlList}}
                            <tr>
                            {{if lt $i 3}}
                                <td class="ranking enlarge"><img id="rankingMedal"
                                                                 src="{{static_front}}/static/front/signin/images/no{{numberAdd $i 1}}.png"/>
                                </td>
                                <td class="amount enlarge">{{$v.GiftContent}}</td>
                                <td class="account enlarge">{{substr $v.Account 0 3}}***</td>
                                <td class="account enlarge">{{$v.GiftName}}</td>
                            {{else}}
                                <td class="ranking">{{numberAdd $i 1}}</td>
                                <td class="amount">{{$v.GiftContent}}</td>
                                <td class="account">{{substr $v.Account 0 3}}***</td>
                                <td class="account">{{$v.GiftName}}</td>
                            {{end}}
                            </tr>
                            {{end}}
                            <tr class="eventRankingTableBorder">
                                <td>
                                    <div class="rankingBorder"></div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div {{if eq .gameStatus  2}} style="display:none"{{end}} class="wrapper-feature-title" id="rankingImgTitle"><img id="imgTitle-1" src="{{static_front}}/static/front/signin/images/top11.png">
                </div>
                <div {{if eq .gameStatus  2}} style="display:none"{{end}} id="eventRanking">
                    <div id="eventRankingTableDiv">
                        <div id="eventRankingTitleDiv">
                            <h1 id="eventRankingTitle" class="english">签到 <br class="rankingbr"/>奖金榜</h1></div>
                        <table id="eventRankingTable">
                            <thead>
                            <th class="ranking">排名</th>
                            <th class="amount">奖金(元)</th>
                            <th class="account">会员</th>
                            <th class="account">翻倍</th>
                            </thead>
                            <tbody>
                            {{range $i,$v := .rlList1}}
                            <tr>
                            {{if lt $i 3}}
                                <td class="ranking enlarge"><img id="rankingMedal"
                                                                 src="{{static_front}}/static/front/signin/images/no{{numberAdd $i 1}}.png"/>
                                </td>
                                <td class="amount enlarge">{{$v.GiftContent}}</td>
                                <td class="account enlarge">{{substr $v.Account 0 3}}***</td>
                                <td class="account enlarge">{{$v.GiftName}}</td>
                            {{else}}
                                <td class="ranking">{{numberAdd $i 1}}</td>
                                <td class="amount">{{$v.GiftContent}}</td>
                                <td class="account">{{substr $v.Account 0 3}}***</td>
                                <td class="account">{{$v.GiftName}}</td>
                            {{end}}
                            </tr>
                            {{end}}
                            <tr class="eventRankingTableBorder">
                                <td>
                                    <div class="rankingBorder"></div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="rankingButtonBar">
                    {{if eq .gameStatus 2}}
                    <div class="rankinginput1" style="background-image: url({{static_front}}/static/front/signin/images/name.png);">
                        <input type="text" id="name" name="name" placeholder="请输入真实姓名">
                    </div>
                    <div class="rankinginput1">
                        <input type="text" id="mobile" name="mmobile" placeholder="请输入手机号码">
                    </div>
                    {{end}}
                    <div class="rankinginput">
                        <input type="hidden" id="gid" value="{{.gameId}}">
                        <input type="text" id="account" name="account" placeholder="请输入会员账号"><br><br>
                        <div class="rankingBtn1">
                            {{if eq .gameStatus 2}}
                                <img  onclick="carveup({{.gameId}})" src="{{static_front}}/static/front/signin/images/signinguafen.png"
                                      style="cursor: pointer;">
                            {{else}}
                                <img id="rankDay1Btn" src="{{static_front}}/static/front/signin/images/signin.png"
                                     style="cursor: pointer;">
                            {{end}}
                                &emsp;&emsp;
                                <a href="{{.officialRegist}}" >
                                    <img id="rankDay1Btn" src="{{static_front}}/static/front/signin/images/registered.png"
                                         style="cursor: pointer;">
                                </a>
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
                                <img class="ruleTitleImg" src="{{static_front}}/static/front/signin/images/tx_rules.png"/>
                            {{str2html .gameRule}}
                            </div>
                        </div>
                    </div>
                </div>
            </div>
           <!-- <div class="eventTxtContainer">
                <div class="eventTxt" id="eventTxt">
                    <img class="ruleTitleImg" src="/static/front/signin/images/tx_resp.png"/>
                {{str2html .gameStatement}}
                </div> -->
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
        $("#rankDay1Btn").click(function () {
            var account = $("#account").val();
            if (account == "") {
                layer.msg("请输入会员账号", {icon: 2});
                return;
            }
            $.ajax({
                url: '{{urlfor "SigninApiController.Post"}}',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {"gid": $("#gid").val(), "account": account},
                success: function (obj) {
                    console.log(obj)
                    if (obj.code == 0) {
                        layer.msg(obj.msg, {icon: 2});
                    } else if (obj.code == 2) {
                        layer.msg(obj.msg, {icon: 1});
                    } else if (obj.code == 1) {
                        var html = '';
                        if (obj.data.hasOwnProperty("giftContent")) {
                            html = '<div>恭喜您获得</div>';
                            html = html + '</br>';
                            html = html + '<span style="font-size:37px;color: red">'+obj.data.giftContent+'&nbsp;元</span>';
                        }
                        var level = "";
                        if(obj.data.force1<0){
                            level = '<div><span style="color:orangered">您以达到最大等级</span></div>'
                        }else{
                            level = '<div>到<span style="color:red">'+obj.data.nextlevlelNme+'</span>还需<span style="color:red;">&nbsp;' + obj.data.force1 +obj.data.unit+'</span></div>'
                        }
                        html = html + level;
                        if(obj.data.hasOwnProperty("gift")){
                            html = html + '</br>';
                            html = html + '<span style="font-weight: bolder;font-size:20px;color:#6C187C;" >'+obj.data.gift+'</span>';
                        }
                        layer.alert(html, {title: obj.msg, icon: 6,});
                    } else if (obj.code == 3) {
                        html = '<div>恭喜您获得<span style="color:red;">&nbsp;' + obj.data.giftContent + '&nbsp;元</span></div>';
                        var register = "<a style=\"color:red\" href=\"{{.officialRegist}}\">点击进行注册</a>";
                        html = html + '<div><span style="color:blue">注册会员账号，签到可得更多彩金</span><br>' + register + '</div>';
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
<script>
    function  carveup(id){
        var account = $("#account").val();
        var mobile = $("#mobile").val();
        var name = $("#name").val();
        if (account == "") {
            layer.msg("请输入会员账号", {icon: 2});
            return;
        }
        if (mobile == "") {
            layer.msg("请输入手机号码", {icon: 2});
            return;
        }
        if (name == "") {
            layer.msg("请输入真实姓名", {icon: 2});
            return;
        }
        $.ajax({
            url: {{urlfor "SigninCarveUPApiController.Post"}},
            type: "post",
            data: {"id": id, "account": account,"mobile":mobile,"name":name},
            success: function (info) {
                if (info.code === 1) {
                        location.href = info.url;
                }else{
                    layer.msg(info.msg);
                }
            },
        });
    }
</script>
</body>
</html>
