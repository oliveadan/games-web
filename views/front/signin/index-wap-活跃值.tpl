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
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/signin/v5/wap/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/signin/v5/wap/css/responsive.css"/>
    <style>
        .hdTime{
            border: 0;
            border-radius: 0;
            width: 370px;
            height: 60px;
            position: absolute;
            top: 274px;
            left: 205px;
            background: url('{{static_front}}/static/front/signin/v5/images/time.png') no-repeat;
            background-size: contain;
            line-height: 60px;
            font-size: 20px;
            text-align: right;
            padding-right: 30px;
        }
        .rankingButtonBar{
            margin-top: 106px;
        }
    </style>
</head>
<body>
<div id="wrap" class="clearfix">
    <div class="content event" id="contentEventDiv">
        <div class="eventMain">
            <div class="rankingSection">
                <div class="hdTime">
                </div>
                <div class="rankingButtonBar">
                    <div class="rankinginput">
                        <input type="hidden" id="gid" value="{{.gameId}}">
                        <input type="text" id="account" name="account" placeholder="请输入会员账号"><br><br>
                        <div class="rankingBtn1">
                        <img id="rankDay1Btn"
                            {{if eq .gameStatus 2}}
                              onclick="carveup({{.gameId}})" src="{{static_front}}/static/front/signin/v5/images/guafen.png"
                            {{else}}
                              src="{{static_front}}/static/front/signin/v5/wap/images/signin.png"
                            {{end}}
                              style="cursor: pointer;">&emsp;

                            <img onclick="Queryd()" src="{{static_front}}/static/front/signin/v5/wap/images/huoli.png"
                                     style="cursor: pointer;">
                            <a href="{{urlfor "DoorController.Query" "gid" .gameId}}">
                                <img src="{{static_front}}/static/front/signin/v5/wap/images/registered.png"
                                     style="cursor: pointer;">
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
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
            <label>会员账号：</label><input name="rlquerycode" id="rlquerycode" type="text" value="" placeholder="请输入会员帐号">
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
<!-- 返回顶部 结束 -->
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/common.js"></script>
<script src="{{static_front}}/static/front/signin/v5/js/jquery.countdown.min.js"></script>
<script>
    $(function () {
        var bool = false;
        $(".mobile-menu-btn").click(function () {
            if ($(".slide-menu").is(":hidden")) {
                $(".slide-menu").show();
            } else {
                $(".slide-menu").hide();
            }
        });
        $("#rankDay1Btn").click(function () {
            if (bool) {
                layer.msg("您今天已经签到了！");
                return
            }
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
                beforeSend: function () {
                    $("#rankDay1Btn").hide();
                },
                success: function (obj) {
                    if (obj.code == 0) {
                        $("#rankDay1Btn").show();
                        layer.msg(obj.msg, {icon: 2});
                    } else if (obj.code == 2) {
                        $("#rankDay1Btn").show();
                        bool = true;
                        layer.msg(obj.msg, {icon: 1});
                    } else if (obj.code == 1) {
                        bool = true;
                        var html = '';
                        if (obj.data.hasOwnProperty("giftContent")) {
                            html = '<div>恭喜您获得</div>';
                            html = html + '</br>';
                            html = html + '<span style="font-size:37px;color: red">' + obj.data.giftContent + '&nbsp;元</span>';
                        }
                        var level = "";
                        if (obj.data.force1 < 0) {
                            level = '<div><span style="color:orangered">您以达到最大等级</span></div>'
                        } else {
                            level = '<div>到<span style="color:red">' + obj.data.nextlevlelNme + '</span>还需<span style="color:red;">&nbsp;' + obj.data.force1 + obj.data.unit + '</span></div>'
                        }
                        html = html + level;
                        if (obj.data.hasOwnProperty("gift")) {
                            html = html + '</br>';
                            html = html + '<span style="font-weight: bolder;font-size:20px;color:#6C187C;" >' + obj.data.gift + '</span>';
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
    function carveup(id) {
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
            data: {"id": id, "account": account, "mobile": mobile, "name": name},
            success: function (info) {
                if (info.code === 1) {
                    location.href = {{urlfor "SigninCarveUPApiController.get"}};
                } else {
                    layer.msg(info.msg);
                }
            },
        });
    }

    function Queryd() {
            var account = $("#account").val();
            if (account == "") {
                layer.msg("请输入会员账号", {icon: 2});
                return;
            }
            $.ajax({
                url: '{{urlfor "SigninApiController.QueryDynamic"}}',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {"account": account},
                success: function (obj) {
                    console.log(obj);
                    var html = '';
                    var register = '活跃度可免费兑换幸运免单抽奖次数'+"<a style=color:red href='/luckyfree'>点击免费抽奖</a>";
                    html = '<div>'+obj.msg+'</div>'+'<br>';
                    html = html + register;
                    layer.alert(html);
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    layer.msg("请求异常，请稍后再试", {icon: 2});
                }
            })
    }
</script>
<script>
    var sta = {{.gameStatus}};
    if (sta === 2) {
        $(".hdTime").html("金猪迎春，财源滚滚");
    } else {
        // countdown
        $(".hdTime").countdown({{.endtime}}).on('update.countdown', function (event) {
            //活動倒數
            var $this = $(this).html(event.strftime(
                '<span>%D</span><b>天</b>'
                + '<span>%H</span><b>时</b>'
                + '<span>%M</span><b>分</b>'
                + '<span>%S</span><b>秒</b>'
                )
            );
        });
    }
</script>
</body>
</html>
