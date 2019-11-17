<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes"/>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" href="app.png">
    <script src="{{static_front}}/static/front/poker/wap/js/respond.min.js"></script>
    <link rel="stylesheet" href="{{static_front}}/static/front/poker/css/reset.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/poker/wap/css/style.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/poker/css/animate.css">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/poker/wap/css/index.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="headerseat"></div>
<div class="header" id="header">
    <a href="{{urlfor "PokerApiController.Get"}}" class="logo"></a>
    <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="search"></a>
</div>
<div class="zjdmain">
    <div id="projects">
        <div class="grid">
            <div class="projects">
                <div class="project ">
                    <img class="front flip show">
                </div>
                <div class="project ">
                    <img class="front flip show">
                </div>
                <div class="project ">
                    <img class="front flip show">
                </div>
                <div class="project ">
                    <img class="front flip show">
                </div>
                <div class="project ">
                    <img class="front flip show">
                </div>
                <div class="project">
                    <img class="front flip show">
                </div>
            </div>
        </div>
    </div>
    <div class="logined"><span>会员<b id="username">user</b></span><span>还有<b id="draw">0</b>次</span>机会<a
                href="javascript:;" onclick="exit()" class="btn">退出</a></div>
    <div class="wininfobg">
        <div class="wininfo">
            <ul>
                {{range $i, $v := .rlList}}
                    <li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span><span>获得<i>{{$v.gift}}</i></span></li>
                {{end}}
            </ul>
        </div>
    </div>
</div>
<div class="content">
    <div class="title">活动详情</div>
    {{str2html .gameRule}}
</div>
<div class="content">
    <div class="title">活动细则</div>
    {{str2html .gameStatement}}
</div>
<div class="tclogin">
    <input type="text" value="" class="user_name" id="user_name" placeholder="请输入平台会员账号">
    <input type="submit" value="登陆" class="tcsub">
</div>
<div class="tcwin">
    <div class="wintext"></div>
    <button class="layui-layer-close makesure">确定</button>
</div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/poker/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
    function autoScroll(obj) {
        $(obj).find("ul").animate({
            marginTop: "-0.5rem"
        }, 500, function () {
            $(this).css({marginTop: "0rem"}).find("li:first").appendTo(this);
        })
    }

    $(function () {
        setInterval('autoScroll(".wininfo")', 3000);
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
    });

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

