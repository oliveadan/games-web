<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes"/>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" href="app.png">
    <script src="{{static_front}}/static/front/tiger/wap/js/respond.min.js"></script>
    <link rel="stylesheet" href="{{static_front}}/static/front/tiger/css/animate.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/tiger/css/reset.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/tiger/wap/css/style.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="headerseat"></div>
<div class="header" id="header">
    <a href="{{urlfor "GoldeggApiController.Get"}}" class="logo"></a>
    <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="search"></a>
</div>
<div class="zjdmain">
    <div class="main-num-box">
        <div class="num_mask"></div>
        <div class="num_box">
            <div class="num"></div>
            <div class="num"></div>
            <div class="num"></div>
            <div class="slot-btn"></div>
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
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.rotate.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/tiger/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/tiger/js/animateBackground-plugin.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/tiger/js/easing.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
    if (localStorage.getItem("username") && localStorage.getItem("username") != "null") {
        _username = localStorage.getItem("username");
        checkUser();
    }
    var u = 2.65;
    $(function () {
        $('.slot-btn').click(function () {
            checklogin();
        });
    });
    var isture = 0;

    function numsShow(result, state) {
        isture = true;
        $(".num").css('background-position', '0rem 0rem');
        if (result.length == 1) {
            result = '00' + result;
        } else if (result.length == 2) {
            result = '0' + result;
        }
        var num_arr = result.split('');
        $(".num").each(function (index) {
            var _num = $(this);
            var yPos = (u * 60) - (u * num_arr[index]);
            setTimeout(function () {
                _num.animate({
                    backgroundPosition: '0rem ' + yPos + 'rem'
                }, {
                    duration: 3000 + index * 3000,
                    easing: "easeInOutCirc",
                    complete: function () {
                        if (index == 2) {
                            if (state == 2) {
                                layer.msg("很遗憾，没有中奖，再来一次吧！", {icon: 5, time: 1800});
                                isture = false;
                            }
                            if (state == 1) {
                                layer.open({
                                    type: 1,
                                    zIndex: 100,
                                    title: false,
                                    area: ['5.64rem'],
                                    skin: 'layui-layer-nobg',
                                    shade: 0.7,
                                    closeBtn: true,
                                    shadeClose: true,
                                    content: $('.tcwin')
                                });
                                isture = false;
                            }
                        }
                    }
                });
            }, index * 300);
        });
    }

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
</body>
</html>

