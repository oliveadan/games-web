<!DOCTYPE HTML>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" href="app.png">
    <link href="{{static_front}}/static/front/red/v4/css/main.css" rel="stylesheet">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/red/v4/css/component.css"/>
    <script src="{{static_front}}/static/front/red/v4/js/modernizr.custom.js"></script>
    <link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans+Condensed:300"/>
    <link rel="stylesheet" href="{{static_front}}/static/front/red/v4/css/jquery.countdown.css"/>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <style>
    </style>
</head>

<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="contant">
    <div class="top">
    </div>
    <div class="midder">
        <div class="midder-img">
        </div>
        <div class="midder-wz">
            <div class="daojishi">
                <span class="tips" id="tips"></span>
                <span class="count-down" id="count-down"></span>
            </div>
            <div id="countdown"></div>
            <div>
                <div class="iputzh">
                    <input type="text" name="commentNameField" id="username" placeholder="请输入会员账号">
                    <div id="btn">
                        <a href="#" onClick="checkUser()" rel="external nofollow" class="gdt ylw">抢红包</a>
                    </div>
                    <div id="back"></div>
                    <div id="login" class="md-content">
                        <div class=" popup flip" style="display: block;">
                            <div class="popup-t">
                                <a href="javascript:;" onclick="close_hongbao()" class="b1 close">
                                    <img id="close_all" src="{{static_front}}/static/front/red/v4/images/x.png">
                                </a>
                                <div class="b2">
                                    <p class="b3">恭喜发财，大吉大利!</p>
                                    <p class="b5" id="b5">您还有<span id="lotteryNums">0</span>次机会</p>
                                </div>
                                <a href="javascript:;" onclick="startGame()" class="b6"><img id="cred"
                                                                                             src="{{static_front}}/static/front/red/v4/images/open.png"></a>
                            </div>
                        </div>
                    </div>

                    <div id="hongbao_result" class="reward flip" style="display:none;">
                        <div class="reward-t">
                            <a href="javascript:;" onclick="close_hongbao()" class="b1 close">
                                <img id="close_all2" src="{{static_front}}/static/front/red/v4/images/x.png">
                            </a>
                        </div>
                        <div class="reward-b">
                            <p class="w2">恭喜发财，大吉大利!</p>
                            <p class="w3">00.00<em>元</em></p>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>
    <!-- 底部按钮 -->
    <div class="booter">
        <button id="rule1" class="md-trigger md-setperspective" data-modal="modal-18">活动详情</button>
        <button id="rule2" class="md-trigger md-setperspective" data-modal="modal-19">中奖查询</button>
    </div>
</div>
<!-- 弹窗内容 -->
<div class="md-modal md-effect-19" id="modal-18">
    <div class="md-content">
        <button class="md-close">关闭</button>
        <div>
            {{str2html .gameRule}}
        </div>
    </div>
</div>
<div class="md-modal md-effect-19" id="modal-19">
    <div id="light" class="md-content">
        <button class="md-close">关闭</button>

        <div class="cxbox">
            <div class="cxbox_hy">
                <!--<p>会员账号：</p>-->
                <input name="querycode" id="querycode" type="text" value="" placeholder="输入帐号查询"> <a href="javascript:;"
                                                                                                     onClick="queryBtn()">
                    查 询</a>
            </div>
            <div class="cxbox_bd" style="color:#ffe681;">
                <table width="480" border="0" cellpadding="0" cellspacing="0">
                    <tr class="ad">
                        <td>红包金额</td>
                        <td>领取时间</td>
                        <td>是否派彩</td>
                    </tr>
                    <tbody id="query_content"></tbody>
                </table>
                <div class="quotes" style="padding:10px 0px;"></div>
            </div>
        </div>

    </div>
</div>

<div class="md-overlay"></div>
<script type="text/javascript" src="{{static_front}}/static/front/red/v4/js/classie.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/red/v4/js/modalEffects.js"></script>
<script>
    // this is important for IEs
    var polyfilter_scriptpath = '/js/';
</script>
<script type="text/javascript" src="{{static_front}}/static/front/red/v4/js/jquery-1.7.1.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/red/v4/js/jquery.countdown.js"></script>
<script>
    var t = {{.countDown}};
    var int;
    var gameMsg = "";
    {{if eq .gameStatus 1}}
    gameMsg = "抢红包即将开始";
    {{else if eq .gameStatus 2}}
    gameMsg = "本期抢红包已结束，敬请期待下期！";
    {{else if eq .gameStatus 3}}
    gameMsg = "抢红包进行中";
    {{else}}
    gameMsg = {{.gameMsg}}
            {{end}}
        document.getElementById("tips").innerHTML = gameMsg;

    function getRTime() {
        if (t <= 0) {
            window.clearInterval(int);
            location.href = location.href;
        }
        var d = Math.floor(t / 60 / 60 / 24);
        var h = Math.floor(t / 60 / 60 % 24);
        var m = Math.floor(t / 60 % 60);
        var s = Math.floor(t % 60);

        var countDownMsg = "";
        if (d > 0) {
            countDownMsg += d + "天";
        }
        if (h > 0) {
            countDownMsg += h + "时";
        }
        if (m > 0) {
            countDownMsg += m + "分";
        }
        if (s > 0) {
            countDownMsg += s + "秒";
        } else {
            countDownMsg += "00秒";
        }
        document.getElementById("count-down").innerHTML = "倒计时：" + countDownMsg;
        t = t - 1;
    }

    if (t > 0) {
        int = setInterval(getRTime, 1000);
    }


    var isChai = false;

    //关闭红包层
    function close_hongbao() {
        isChai = false;
        $('#hongbao_result').find('.w2').html('恭喜发财，大吉大利!');
        $('#login').hide();
        $('#hongbao_result').hide();
        $('#back').hide();
        $("#login").removeClass("out");
        $("#hongbao_result").removeClass("in").hide();
    }

    //检查用户帐号
    function checkUser() {
        var _username = $("#username").val();
        if (_username == "") {
            layer.msg("会员帐号不能为空!");
            return false;
        }
        $.ajax({
            url: '/login',
            dataType: 'json',
            cache: false,
            type: 'POST',
            data: {
                gid: $("#gid").val(),
                account: _username
            },
            success: function (obj) {
                switch (obj.code) {
                    case 0:
                        localStorage.clear();
                        layer.msg(obj.msg);
                        break;
                    case 1:
                        localStorage.username = _username;
                        $('#lotteryNums').text(obj.data.lotteryNums);
                        // $('#hongbao_open').show();
                        $('#login').show();
                        // $('#hongbao_back').show();
                        $('#back').show();
                        break;
                    default:
                        layer.msg('网络错误,请稍后再抽奖');
                        break;
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var x = 1;
                localStorage.clear();
            }
        });
    }

    var isClick = false;

    function startGame() {
        if (isClick) {
            return;
        }
        var _username = $("#username").val();
        if (_username == "") {
            layer.msg("会员帐号不能为空!");
            return false;
        }
        isClick = true;
        $.ajax({
            url: '/frontshare/lottery',
            dataType: 'json',
            cache: false,
            type: 'POST',
            data: {
                gid: $("#gid").val(),
                account: _username
            },
            success: function (obj) {
                switch (obj.code) {
                    case 0:
                        layer.msg(obj.msg);
                        bCode = "";
                        isClick = false;
                        break;
                    case 1:
                        $('#login').addClass("shake");
                        $('#lotteryNums').text($('#lotteryNums').text() - 1);
                        setTimeout(function () {
                            $('#login').removeClass("shake");
                            var phone = $("#phone").val();
                            if (phone === "phone" && obj.data.photo != "") {
                                $(".reward-b").css("margin-top", "1.4rem");
                                $('#hongbao_result').find('.w3').html("<img src=" + obj.data.photo + ">");
                                $('#hongbao_result').find('.w2').html(obj.data.gift);
                            } else if (obj.data.photo != "") {
                                console.log(obj);
                                $('.w1').css("display", "none");
                                $('.w4').css("display", "none");
                                $('#hongbao_result').find('.w3').html("<img src=" + obj.data.photo + ">");
                                $('#hongbao_result').find('.w2').html(obj.data.gift);
                            } else {
                                $('#hongbao_result').find('.w3').html(obj.data.gift);

                            }

                            $("#login").addClass("out").fadeOut();
                            $("#hongbao_result").fadeIn().addClass("in");

                            isClick = false;
                        }, 2000);
                        break;
                    case 2:
                        $('#login').addClass("shake");
                        $('#lotteryNums').text($('#lotteryNums').text() - 1);
                        setTimeout(function () {
                            $('#login').removeClass("shake");
                            $('#hongbao_result').find('.w2').html(obj.msg);
                            $('#hongbao_result').find('.w3').html('00.00<em>元</em>');
                            $('.w1').css("display", "block");
                            $('.w4').css("display", "block");


                            $("#login").addClass("out").fadeOut();
                            $("#hongbao_result").fadeIn().addClass("in");

                            isClick = false;
                        }, 2000);
                        break;
                    default:
                        layer.msg(obj.msg);
                        break;
                }
            },
            failure: function () {
                //api请求失败处理
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var x = 1;
                alert('网络故障,请联系管理员');
            }
        })

    }

    function queryBtn() {
        var _bonuscode = $("#querycode").val();
        if (_bonuscode == "") {
            layer.msg("会员帐号不能为空!");
            return false;
        }
        queryPage(1);
    }

    var pagesize = 5;

    function queryPage(page) {
        $.ajax({
            url: '/frontshare/lotteryquery',
            dataType: 'json',
            cache: false,
            data: {
                gid: $("#gid").val(),
                account: $("#querycode").val(),
                page: page,
                pagesize: pagesize
            },
            type: 'POST',
            success: function (res) {
                if (res.code == 1) {
                    var sHtml1 = "";
                    var x = "";
                    if (res.data.total > 0) {
                        $.each(res.data.list, function (i, award) {
                            x = (award.delivered == 1) ? "<font color=yellow>已派彩</font>" : "<font color=white>未派彩</font>";
                            sHtml1 += "<tr><td>" + award.gift + "</td><td>" + award.createDate + "</td><td>" + x + "</td></tr>";
                        })
                        var sPage = Paging(page, pagesize, res.data.total, 2, "queryPage", '', '', '上一页', '下一页');
                        $(".quotes").html(sPage);
                        $("#query_content").html(sHtml1);
                    } else {
                        $("#query_content").html("<tr><td colspan='3'>没有中奖记录</td></tr>");
                    }
                } else {
                    layer.msg(res.msg);
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var x = 1;
            }
        })
    }

    function Paging(pageNum, pageSize, totalCount, skipCount, fuctionName, currentStyleName, currentUseLink, preText, nextText, firstText, lastText) {

        var returnValue = "";

        var begin = 1;

        var end = 1;

        var totalpage = Math.floor(totalCount / pageSize);

        if (totalCount % pageSize > 0) {

            totalpage++;

        }

        if (preText == null) {

            firstText = "prev";

        }

        if (nextText == null) {

            nextText = "next";

        }


        begin = pageNum - skipCount;

        end = pageNum + skipCount;


        if (begin <= 0) {

            end = end - begin + 1;

            begin = 1;

        }


        if (end > totalpage) {

            end = totalpage;

        }

        for (count = begin; count <= end; count++) {

            if (currentUseLink) {

                if (count == pageNum) {

                    returnValue += "<a class=\"" + currentStyleName + "\" href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";

                } else {

                    returnValue += "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";

                }

            } else {

                if (count == pageNum) {

                    returnValue += "<span class=\"" + currentStyleName + "\">" + count.toString() + "</span> ";

                } else {

                    returnValue += "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";
                }

            }

        }

        if (pageNum - skipCount > 1) {

            returnValue = " ... " + returnValue;

        }

        if (pageNum + skipCount < totalpage) {

            returnValue = returnValue + " ... ";

        }


        if (pageNum > 1) {

            returnValue = "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + (pageNum - 1).toString() + ");\"> " + preText + "</a> " + returnValue;

        }

        if (pageNum < totalpage) {

            returnValue = returnValue + " <a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + (pageNum + 1).toString() + ");\">" + nextText + "</a>";

        }


        if (firstText != null) {

            if (pageNum > 1) {

                returnValue = "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(1);\">" + firstText + "</a> " + returnValue;
            }

        }

        if (lastText != null) {

            if (pageNum < totalpage) {

                returnValue = returnValue + " " + " <a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + totalpage.toString() + ");\">" + lastText + "</a>";
            }

        }

        return returnValue;


    }
</script>
</body>

</html>