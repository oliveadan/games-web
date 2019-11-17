<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/sec/css/bootstrap.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/sec/css/style.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/sec/css/timeTo.css">
    <script src="{{static_front}}/static/front/sec/js/jquery-1.12.4.min.js" charset="utf-8"></script>
</head>
<input type="hidden" id="gid" value="{{.gameId}}">
<div id="top"></div>
<div class="pis"></div>
<div class="headFixdClick">
    <div class="topHeadLogin">
        <div class="fnameCenter">
            <div class="left">
                <span style="float:left; width:460px;margin-left:10px;font-size: 14px"
                      class="mnone">盛世狂欢节，聚在{{.siteName}}引领行业潮流 ，非凡游戏体验！
                </span>
                <a id="login" href="javascript:;" onclick="Ulit.showCeng('.login_pop,.bgCeng')" target="_blank">登录</a>
                <a id="logout" href="" onclick="logout()" target="_blank">退出</a>
                <span class="right" style="margin-right:10px;">
                <a href="{{.officialSite}}" target="_blank">{{.siteName}}</a></span>
            </div>
        </div>
    </div>
</div>


<div class="sidebar2 mnone">
    <div class="sidebarCon2">
        <br><br><br><br>
        <a href="{{.officialSite}}" target="_blank">官方网址</a>
        <br>
        <a href="{{.officialRegist}}" target="_blank">免费注册</a>
        <br>
        <a href="{{.custServ}}" target="_blank">在线客服</a>
        <br>
        <a href="#top" class="top"></a>
    </div>
</div>

<div class="sidebar">
    <div class="sidebarCon">
        <br><br><br><br>
        <a href="{{.officialSite}}" target="_blank">官方网址</a>
        <br>
        <a href="{{.officialRegist}}" target="_blank">免费注册</a>
        <br>
        <a href="{{.custServ}}" target="_blank">在线客服</a>
        <br>
        <a href="#top" class="top"></a>
    </div>
</div>
<div class="upper">
    <img src="{{static_front}}/static/img/logo.png" class="mylogo">
</div>

<div class="midsec">
    <img src="{{static_front}}/static/front/sec/images/txtimg1.png" alt="" class="titleimg">
    <div class="clock2hlder">
        <div class="clocknav clearfix">
        {{range $i,$v := .periodList}}
            <div>
                <span>{{$v.StartTime}}-{{$v.EndTime}}</span>
                <span>
                {{if eq $.gameStatus 2}}
                    已结束
                    <input type="hidden" id="seckill{{$i}}" value="2">
                {{else if lt $v.EndTime $.curTime}}
                    已结束
                    <input type="hidden" id="seckill{{$i}}" value="2">
                {{else if gt $v.StartTime  $.curTime}}
                    未开始
                    <input type="hidden" id="seckill{{$i}}" value="0">
                {{else if eq $.gameStatus 3}}
                    秒杀进行中
                    <input type="hidden" id="seckill{{$i}}" value="1">
                {{else}}
                    已结束
                    <input type="hidden" id="seckill{{$i}}" value="3">
                {{end}}
                </span>
            </div>
        {{end}}
        </div>
        <div class="clockContent">
        {{range $i,$v := .giftList}}
            <div class="cCon hide">
                <div class="imgHlder"><img style="width: 100%;height: 100%;" src="{{or $v.Photo "/static/front/sec/images/miao010.jpg"}}" alt="">
                    <img src="{{static_front}}/static/front/sec/images/imgtag.png" alt="" class="tag">
                </div>
                <div class="clocktimerHlder">
                    <p><b style="color:#f7cc4c;">{{$v.Name}}</b></p>
                    <p class="time">
                        <span class="miaotime0"></span></br>
                        <span class="count-down">00：00</span>
                    </p>
                    <a href="javascript:" onclick="seckill({{$i}})" class="gbtn cbtn">点击秒杀</a>
                    <a href="javascript:;" onClick="secquery()" class="ybtn cbtn">我的秒杀</a>
                </div>
            </div>
        {{else}}
            <div>
                <a href="javascript:;" onClick="secquery()" class="ybtn cbtn">我的秒杀</a>
            </div>
        {{end}}
        </div>
    </div>
</div>

<div class="mid">
    <div class="boxhlder clearfix">
        <div class="clearfix">
            <div class="gd1 bd">
                <ul>
                {{range $i, $v := .rlList}}
                    <li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">获得 <em
                            class="fc-red">{{$v.gift}}</em></span></li>
                {{end}}
                </ul>
            </div>
            <div class="gd2 bd1 bor-none">
                <ul>
                {{range $i, $v := .rlList1}}
                    <li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">获得 <em
                            class="fc-red">{{$v.gift}}</em></span></li>
                {{end}}
                </ul>
            </div>
        </div>
    </div>
</div>

<div class="midrule">
    <div class="boxhlder2 clearfix">
        <div class="clearfix">
        {{if .gameRule}}
            <div class="midruletitle">活动规则</div>
        {{str2html .gameRule}}
        {{end}}
        {{if .gameStatement}}
                <br><br>
            <div class="midruletitle">免责声明</div>
        {{str2html .gameStatement}}
        {{end}}
        </div>
    </div>
</div>
<div class="modal-content login_pop">
    <div class="login_close cclose" onclick="javascript:Ulit.hideCeng('.login_pop,.bgCeng')"></div>
    <form class="login-form" method="post" onsubmit="return Ulit.userLogin()">
        <input type="text" placeholder="请输入用户名" name="username">
    {{if ne .ismobile 1}}
        <input type="text" name="dd">
    {{end}}
        <button type="submit"></button>
    </form>
</div>
<!--查询-->
<div id="light" class="white_content">
    <div class="cxbox">
        <div class="cxbox_bt">
            <p>输入会员账号查询</p>
            <a href="javascript:void(0)" style="color:#ffe681;text-decoration:none;" onClick="document.getElementById('light').style.display='none';" class="gban">X</a>
        </div>
        <div class="cxbox_hy">
            <p>会员账号：</p>  <input name="querycode" id="querycode" type="text" value="" placeholder="输入帐号"> <a
                href="javascript:;" onClick="queryBtn()">
            查 询</a>
        </div>
        <div class="cxbox_bd" style="color:#ffe681;">
            <table width="480" border="0" cellpadding="0" cellspacing="0">
                <tr class="ad">
                    <td>奖品内容</td>
                    <td>领取时间</td>
                    <td>是否派彩</td>
                </tr>
                <tbody id="query_content"></tbody>
            </table>
            <div class="quotes" style="padding:10px 0px;"></div>
        </div>
    </div>
</div>

<footer>
    <div class="navHlder">
        <div class="fnameCenter"><a href="{{.officialSite}}">关于{{.siteName}}</a> | <a
                href="{{.custServ}}">在线客服</a> | <a href="{{.officialRegist}}">注册</a>
            <p>©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p>
        </div>
    </div>
    <p></p>
</footer>
<div class="bgCeng"></div>
</div>
<script src="{{static_front}}/static/front/sec/js/jquery.time-to.min.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script src="{{static_front}}/static/front/sec/js/jquery.rotate.min.js"></script>
<script src="{{static_front}}/static/front/sec/js/scrollText.js"></script>
<script src="{{static_front}}/static/front/sec/js/animatedModal.min.js"></script>
<script src="{{static_front}}/static/front/sec/js/common.js" charset="utf-8"></script>
<script src="{{static_front}}/static/front/sec/js/jquery.cookie.js"></script>
<script src="{{static_front}}/static/front/sec/js/query.js"></script>
<script src="{{static_front}}/static/front/js/jquery.SuperSlide.2.1.1.js"></script>

<script>
    jQuery(".gd1").slide({
        mainCell: "ul",
        autoPlay: true,
        effect: "topMarquee",
        vis: 6,
        interTime: 40,
        trigger: "click"
    });
    jQuery(".gd2").slide({
        mainCell: "ul",
        autoPlay: true,
        effect: "topMarquee",
        vis: 6,
        interTime: 40,
        trigger: "click"
    });
</script>
<script type="text/javascript">
    $(function () {
        username3 = localStorage.getItem("username");
        if (username3 != null) {
            $("#login").text(username3);
            $("#logout").show()
        } else {
            $("#logout").hide()
        }
    });
    $(document)
            .ajaxStart(function () {
                $("button:submit").addClass("log-in").attr("disabled", true);
            })
            .ajaxStop(function () {
                $("button:submit").removeClass("log-in").attr("disabled", false);
            });
    $("form").submit(function () {
        var self = $(this);
        $.post(self.attr("action"), self.serialize(), success, "json");
        return false;

        function success(data) {
            if (data.status) {
                window.location.href = data.url;
            } else {
                self.find(".Validform_checktip").text(data.info);
            }
        }
    });

</script>
<!--倒计时 -->
<script>
    var t = parseInt({{.countDown}});
    var int;
    var gameMsg = "";
    {{if eq .gameStatus 1}}
    gameMsg = "秒杀开始倒计时";
    {{else if eq .gameStatus 2}}
    gameMsg = "本轮秒杀已结束，敬请期待下一轮！";
    t = 0;
    {{else if eq .gameStatus 3}}
    gameMsg = "秒杀中";
    {{else}}
    gameMsg = '{{.gameMsg}}';
    {{end}}

    var x = document.getElementsByClassName("miaotime0");
    var i;
    for (i=0; i<x.length; i++){
        x[i].innerHTML = gameMsg
    }

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
        var x = document.getElementsByClassName("count-down");
        var i;
        for (i = 0; i < x.length; i++) {
            x[i].innerHTML = countDownMsg;
        }
        t = t - 1;
    }

    if (t > 0) {
        int = setInterval(getRTime, 1000);
    }
</script>
<script>
    //秒杀
    function seckill(index) {
        if(!$("#seckill"+index)||$("#seckill"+index).val()!='1') {
            layer.msg("请选择进行中的秒杀");
            return;
        }
        var account = localStorage.getItem("username");
        if (account == null || account == "") {
            Ulit.showCeng('.login_pop,.bgCeng');
            return
        }
        $.ajax({
            type: 'POST',
            url: '/sec',
            dataType: 'json',
            data: {
                account: account,
                gid: $("#gid").val()
            },
            success: function (data) {
                if (data.code == 0) {
                    layer.msg(data.msg);
                    return
                }
                var html = "";
                html = html + '<div><span style="color:red">恭喜您秒杀获得：</span></div>';
                html = html + '<span style="font-size:20px;color: red">' + data.data.gift + '</span>';
                layer.alert(html, {title: "秒杀成功！！！", icon: 6})
            }
        });
    }

    function logout() {
        $.ajax({
            type: 'GET',
            url: '/logout',
            success: function (data) {
                localStorage.removeItem("username");
            }
        });
    }

    var Ulit = {
        tiaozhuan: function () {
            window.location.reload();
        },
        userLogin: function () {
            var $userName = $("input[name=username]").val();
            if ($userName.length < 1) {
                layer.msg("请填写账号");
                return false;
            }
            /*登录验证*/
            $.ajax({
                type: 'POST',
                url: '/login',
                dataType: 'json',
                data: {
                    account: $userName,
                    gid: $("#gid").val()
                },
                success: function (data) {
                    if (data.code != 1) {
                        layer.msg(data.msg)
                    } else {
                        localStorage.username = $userName;
                        $("#login").text($userName);
                        $("#logout").show();
                        Ulit.hideCeng('.login_pop,.bgCeng');
                        window.location.reload();
                    }
                }
            });
        },


        //隐藏浮层
        hideCeng: function (className) {
            $(className).fadeOut();
        },
        /*延迟函数*/
        delay: function (t, callback) {
            return window.setTimeout(function () {
                callback();
            }, t);
        },
        //显示浮层
        showCeng: function (className) {
            $(className).fadeIn();
        },
        //删除元素
        emtypCenter: function (className) {
            $(className).empty();
        },
        //过滤HTML标签
        removeHTMLTag: function (str) {
            str = str.replace(/<\/?[^>]*>/g, ''); //去除HTML tag
            str = str.replace(/[ | ]*\n/g, '\n'); //去除行尾空白
            //str = str.replace(/\n[\s| | ]*\r/g,'\n'); //去除多余空行
            str = str.replace(/ /ig, '');//去掉
            return str;
        },

        //打开新窗口
        windowOpen: function (url, width, height) {
            window.open(url, 'newwindow', 'menubar=no,status=yes,scrollbars=yes,top=0,left=0,toolbar=no,width=' + width + ',height=' + height);
        },

    };

    function secquery() {
        if('{{.ismobile}}' == '1') {
            location.href = '{{urlfor "DoorController.Query" "gid" .gameId}}';
        } else {
            $("#rush").val("");
            document.getElementById('light').style.display = 'block';
        }
    }
</script>
<script>
    function delay(t, callback) {
        return window.setTimeout(function () {
            callback();
        }, t);
    };

    $(function () {

        $(".clockContent").children("div").eq(0).attr("class", "cCon show");
        var $hand = $('.hand'),
                me = this,
                closeTime = 5500,
                $userinfoPs = $(".pis");
    });
</script>
</body>
</html>
