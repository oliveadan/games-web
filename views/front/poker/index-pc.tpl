<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/poker/css/reset.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/poker/css/style.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/poker/css/animate.css">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/poker/css/index.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header">
    <div class="headercon w1000">
        <a class="logo" href='{{urlfor "PokerApiController.Get"}}'></a>
        <div class="menu">
            <ul>
                <li><a target="_blank" href="{{.officialSite}}"><i class="i1"></i>
                        <p>官方首页</p></a></li>
                <li><a href="javascript:;"
                       onClick="document.getElementById('light').style.display='block'; document.getElementById('fade').style.display='block'"><i
                                class="i8"></i>
                        <p>中奖查询</p></a></li>
                <li><a target="_blank" href="{{.officialRegist}}"><i class="i5"></i>
                        <p>免费注册</p></a></li>
                <li class="last"><a target="_blank" href="{{.custServ}}"><i class="i6"></i>
                        <p>在线客服</p></a></li>
            </ul>
        </div>
    </div>
</div>
<div class="main">
    <div class="logined"><span>会员 <b id="username">user</b></span><span>还有<b id="draw">0</b>次机会</span><a
                href="javascript:;" onclick="exit()" class="qdbtn">退出</a></div>
    <div class="w1000"><!--
		<div class="poker-pannel">
			<ul class="pokerList">				
				<li><img class="poker flip show" src="{{static_front}}/static/front/poker/images/poker-back.png" /></li>
				<li><img class="poker flip show" src="{{static_front}}/static/front/poker/images/poker-back.png" /></li>
				<li><img class="poker flip show" src="{{static_front}}/static/front/poker/images/poker-back.png" /></li>
				<li><img class="poker flip show" src="{{static_front}}/static/front/poker/images/poker-back.png" /></li>
				<li><img class="poker flip show" src="{{static_front}}/static/front/poker/images/poker-back.png" /></li>
				<li><img class="poker flip show" src="{{static_front}}/static/front/poker/images/poker-back.png" /></li>
			</ul>
		</div>	-->
        <div id="projects">
            <div class="grid">
                <div class="projects">
                    <div class="project ">
                        <img class="front flip show" src="{{static_front}}/static/front/poker/images/project_front_bg.png"></img>
                    </div>
                    <div class="project ">
                        <img class="front flip show"></img>
                    </div>
                    <div class="project ">
                        <img class="front flip show"></img>
                    </div>
                    <div class="project ">
                        <img class="front flip show"></img>
                    </div>
                    <div class="project ">
                        <img class="front flip show"></img>
                    </div>
                    <div class="project">
                        <img class="front flip show"></img>
                    </div>
                </div>
            </div>
        </div>

        <div class="con con1">
            <div class="w1000">
                <div class="winlist">
                    <ul>
                        {{range $i, $v := .rlList}}
                            <li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span>获得<em>{{$v.gift}}</em></li>
                        {{end}}
                    </ul>
                </div>
            </div>
        </div>
        <div class="con con2">
            <div class="w1000">
                <div class="title">活动详情</div>
                {{str2html .gameRule}}
            </div>
        </div>
        <div class="con con3">
            <div class="w1000">
                <div class="title">活动细则</div>
                <p>
                    {{str2html .gameStatement}}
                </p>
            </div>
        </div>
    </div>
</div>

<div class="footer">
    <div class="copyright">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div>
</div>

<div class="tclogin">
    <input type="text" value="" class="user_name" id="user_name" placeholder="请输入平台会员账号">
    <input type="submit" value="登陆" class="tcsub">
</div>
<div class="tcwin">
    <div class="wintext"></div>
    <button class="layui-layer-close makesure">确定</button>
</div>

<!--底部 结束-->
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
                    <td>中奖金额</td>
                    <td>中奖时间</td>
                    <td>是否派彩</td>
                </tr>
                <tbody id="query_content"></tbody>
            </table>
            <div class="quotes" style="padding:10px 0px;"></div>
        </div>
    </div>
</div>
<div id="fade" class="black_overlay"></div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/poker/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
    function autoScroll(obj) {
        $(obj).find("ul").animate({
            marginTop: "-50px"
        }, 500, function () {
            $(this).css({marginTop: "0px"}).find("li:lt(2)").appendTo(this);
        })
    }

    $(function () {
        setInterval('autoScroll(".winlist")', 3000);
    })
</script>
<script>
    if (localStorage.getItem("username") && localStorage.getItem("username") != "null") {
        _username = localStorage.getItem("username");
        checkUser();
    }
    var isture = 0;
    $(".projects img").click(function () {
        var _this = $(this);
        if (!_this.parent().parent().find("img").hasClass("show")) {
            layer.msg("全部都翻过了，再来一次吧！", {icon: 2, time: 1800}, function () {
                window.location.reload()
            });
            return false;
        }
        if (_this.hasClass("in")) {
            layer.msg("已经翻过了，换一张吧！");
            return false;
        }
        checklogin(_this);
    });

    function pokerClick(obj, state, photo) {
        isture = true;
        var _this = obj;
        var _state = state;
        setTimeout(function () {
            _this.attr("src", photo);
            setTimeout(function () {
                _this.removeClass("out").addClass("in");
            }, 500);
            setTimeout(function () {
                if (_state == 2) {
                    layer.msg("很遗憾，没有中奖，再来一次吧！", {icon: 5, time: 1800});
                    isture = false;
                }
                if (_state == 1) {
                    layer.open({
                        type: 1,
                        zIndex: 100,
                        title: false,
                        area: ['438px'],
                        skin: 'layui-layer-nobg',
                        shade: 0.7,
                        closeBtn: true,
                        shadeClose: true,
                        content: $('.tcwin')
                    });
                    isture = false;
                }
            }, 1500);
        }, 1000);
    }
</script>
<script type="text/javascript">
    $(function () {
        $('.controls').ready(function () {
            addMove();
        })
    })

    function addMove() {
        $('.project').each(function (index, item) {
            setTimeout(function () {
                $(item).addClass('ani' + index);
            }, index * 300);
        })
    }

    function subMove() {
        $('.project').each(function (index, item) {
            $(item).removeClass('ani' + index);
        })
    }
</script>
</body>
</html>