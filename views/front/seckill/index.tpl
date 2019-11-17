<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/seckill/css/bootstrap.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/seckill/css/animate.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/seckill/css/style.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/seckill/css/timeTo.css">
    <script src="{{static_front}}/static/front/seckill/js/jquery-1.12.4.min.js" charset="utf-8"></script>
    <link href="{{static_front}}/static/front/seckill/css/jquery.mCustomScrollbar.css" rel="stylesheet">
</head>
<input type="hidden" id="gid" value="{{.gameId}}">
<input type="hidden" id="rushid" value="{{.rushId}}">
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
                <span class="right" style="margin-right:10px;"> <a href="{{.officialSite}}"
                                                                   target="_blank">{{.siteName}}</a></span>
            </div>
        </div>
    </div>
</div>


<div class="sidebar2 mnone">
    <div class="sidebarCon2">
        <br><br><br>
        <a href="{{.officialSite}}" target="_blank">官方网址</a>
        <a href="{{.officialRegist}}" target="_blank">免费注册</a>
        <a href="{{.custServ}}" target="_blank">在线客服</a>
        <a href="#top" class="top"></a>
    </div>
</div>

<div class="sidebar">
    <div class="sidebarCon">
        <br><br><br>
        <a href="{{.officialSite}}" target="_blank">官方网址</a>
        <a href="{{.officialRegist}}" target="_blank">免费注册</a>
        <a href="{{.custServ}}" target="_blank">在线客服</a>
        <a href="#top" class="top"></a>
    </div>
</div>
<div class="upper">

</div>
<div class="mid">
    <div class="boxhlder clearfix">
        <div class="clearfix">
            <div class="gd1 bd">
                <ul>
                {{range $i, $v := .rlList}}
                    <li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">获得 <em class="fc-red">{{$v.gift}}</em></span></li>
                {{end}}
                </ul>
            </div>
            <div class="gd2 bd1 bor-none">
                <ul>
                {{range $i, $v := .rlList1}}
                    <li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">获得 <em class="fc-red">{{$v.gift}}</em></span></li>
                {{end}}
                </ul>
            </div>
        </div>
    </div>
</div>
<div class="midsec">
    <img src="{{static_front}}/static/front/seckill/images/txtimg1.png" alt="" class="titleimg">
    <div class="clock2hlder">
        <div class="clocknav clearfix">
        {{range $i,$v := .periodList}}
            <div>
                <span>{{$v.StartTime}}-{{$v.EndTime}}</span>
                <span>{{if eq $v.StartTime  $.timeing}}进行中{{else}}已结束{{end}}</span>
            </div>
        {{end}}
        </div>
        <div class="clockContent">
        {{range $i,$v := .giftList}}
            <div class="cCon hide">
                <div class="imgHlder"><img src="{{$v.Photo}}" alt=""> <img
                        src="{{static_front}}/static/front/seckill/images/imgtag.png" alt="" class="tag"></div>
            <div class="clocktimerHlder">
                <p><b style="color:#f7cc4c;">{{$v.Name}}</b></p>
                <p class="time">
                    <span  class="miaotime0">00：00</span></br>
                    <span  class="count-down">00：00</span>
                </p>
                <a href="javascript:" onclick="seckill(1,{{$v.Id}},{{$i}})" class="gbtn cbtn">点击秒杀</a>.
            {{if eq $.ismobile 1}}
                <a href="{{urlfor "DoorController.Query" "gid" $.gameId}}" class="ybtn cbtn">我的秒杀</a></div>
            {{else}}
                <a href="javascript:;"
                   onClick="seckillquery()"class="ybtn cbtn">我的秒杀</a></div>
            {{end}}
            </div>
        {{end}}
    </div>
</div>

<div class="midsecThree">
    <div class="promobox_hlder clearfix">
        <img src="{{static_front}}/static/front/seckill/images/txtimg2.png" alt="" class="titleimg mnone">
        <div class="clearfix"></div>
        <br>
        <div>
        {{if eq $.ismobile 1}}
            <a href="{{urlfor "DoorController.Query" "gid" $.rushId}}" class="ybtn cbtn">我的抢购</a>
        {{else}}
            <a href="javascript:;" onClick="rushquery()" class="ybtn cbtn">我的抢购</a>
        {{end}}
            <input type="hidden" id="rush">
        </div>
        <div class="promobox">
            <div class="imghlder">
                <img src="{{static_front}}/static/front/seckill/images/zhenren.jpg" alt="">
                <a href="javascript:" onclick="seckill(2,{{.realpersong}})">
                    <img src="{{static_front}}/static/front/seckill/images/btntxtimg.png" alt="">
                </a>
            </div>
            <div class="txtcon">
                <div class="tHlder">真人每日存送 <span>10%</span></div>
                <p>
                <p>
                    1.最低存款<span>100，优惠上限888元</span><br>
                    2.该优惠为<span>10</span>倍流水，仅限在AB/AG真人视讯平台游戏
                </p> </p>
            </div>
        </div>
        <div class="promobox">
            <div class="imghlder"><img src="{{static_front}}/static/front/seckill/images/laohuji.jpg" alt="">
                <a href="javascript:;" onclick="seckill(2,{{.tiger}})">
                  <img src="{{static_front}}/static/front/seckill/images/btntxtimg.png" alt="">
                </a>
            </div>
            <div class="txtcon">
                <div class="tHlder">老虎机每日存送 <span>50%</span></div>
                <p>
                <p>
                    1.最低存款<span>50，优惠上限888元</span><br>
                    2.该优惠为<span>15</span>倍流水，仅限在PT/MG/PP老虎机平台游戏
                </p> </p>
            </div>
        </div>
        <div class="promobox">
            <div class="imghlder"><img src="{{static_front}}/static/front/seckill/images/tiyu.jpg" alt="">
                <a href="javascript:"  onclick="seckill(2,{{.sport}})">
                    <img src="{{static_front}}/static/front/seckill/images/btntxtimg.png" alt="">
                </a>
            </div>
            <div class="txtcon">
                <div class="tHlder">体育每日存送 <span>10%</span></div>
                <p>
                <p>
                    1.最低存款<span>300，优惠上限388元</span><br>
                    2.该优惠为<span>8</span>倍流水，仅限在T188，BBIN体育平台游戏
                </p> </p>
            </div>
        </div>
        <div class="promobox">
            <div class="imghlder"><img src="{{static_front}}/static/front/seckill/images/caipiao.jpg" alt="">
                <a href="javascript:" onclick="seckill(2,{{.lottery}})">
                    <img src="{{static_front}}/static/front/seckill/images/btntxtimg.png" alt="">
                </a>
            </div>
            <div class="txtcon">
                <div class="tHlder">彩票每日存送 <span>10%</span></div>
                <p>
                <p>
                    1.最低存款<span>200，优惠上限388元</span><br>
                    2.该优惠为<span>12</span>倍流水，仅限在KG/LBK/BBIN彩票平台游戏
                </p> </p>
            </div>
        </div>
        <div class="clearfix"></div>
        <div class="btmtxt">
        {{str2html .gameStatement}}
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
            <a href="javascript:void(0)" style="color:#ffe681;text-decoration:none;"
               onClick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'"
               class="gban">
                X</a>
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
<script src="{{static_front}}/static/front/seckill/js/jquery.time-to.min.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script src="{{static_front}}/static/front/seckill/js/jquery.rotate.min.js"></script>
<script src="{{static_front}}/static/front/seckill/js/scrollText.js"></script>
<script src="{{static_front}}/static/front/seckill/js/animatedModal.min.js"></script>
<script src="{{static_front}}/static/front/seckill/js/common.js" charset="utf-8"></script>
<script src="{{static_front}}/static/front/seckill/js/jquery.cookie.js"></script>
<script src="{{static_front}}/static/front/seckill/js/query.js"></script>
<script src="{{static_front}}/static/front/js/jquery.SuperSlide.2.1.1.js"></script>

<script>
    jQuery(".gd1").slide({mainCell:"ul",autoPlay:true,effect:"topMarquee",vis:6,interTime:40,trigger:"click"});
    jQuery(".gd2").slide({mainCell:"ul",autoPlay:true,effect:"topMarquee",vis:6,interTime:40,trigger:"click"});
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
                //刷新验证码
                $(".reloadverify").click();
            }
        }
    });

</script>
<!--倒计时 -->
<script>
    var t = {{.countDown}};
    var int;
    var gameMsg = "";
    {{if eq .gameStatus 1}}
    gameMsg = "秒杀即将开始";
    {{else if eq .gameStatus 2}}
    gameMsg = "秒杀已结束，敬请期待下期！";
    {{else if eq .gameStatus 3}}
    gameMsg = "秒杀中";
    {{else}}
    gameMsg = {{.gameMsg}};
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
        for (i=0; i<x.length; i++){
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
    function seckill(distinction,everydayid,index) {
        account = localStorage.getItem("username");
        if (account == null) {
            Ulit.showCeng('.login_pop,.bgCeng');
            return
        }
        $.ajax({
            type: 'POST',
            url: '/seckill',
            dataType: 'json',
            data: {
                account: account,
                gid: $("#gid").val(),
                rushid:$("#rushid").val(),
                status:{{.gameStatus}},
                distinction:distinction,
                everydayid:everydayid,
                index:index
            },
            success: function (data) {
                if (data.code == 0) {
                    layer.msg(data.msg);
                    return
                }
                var html = "";
                html = html + '<div><span style="color:red">恭喜您获得</span></div>';
                html = html + '<span style="font-size:20px;color: red">' + data.data.gift + '</span>';
                layer.alert(html, {title: data.msg, icon: 6})
            }
        });
    }

    function logout() {
        localStorage.removeItem("username");
    }

    var Ulit = {
        tiaozhuan: function () {
            window.location.reload();
        },
        /*登录新葡京官网*/
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
    //查询每日抢购
    function rushquery( ) {
        $("#rush").val(1);
        document.getElementById('light').style.display = 'block';
        document.getElementById('fade').style.display = 'block';
    }
    function seckillquery() {
        $("#rush").val("");
        document.getElementById('light').style.display = 'block';
        document.getElementById('fade').style.display = 'block';
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