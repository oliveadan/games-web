<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>{{.siteName}}{{.gameDesc}}</title>
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no"/>
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v8/css/xy.css"/>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v8/css/main.css"/>
    <script src="{{static_front}}/static/front/signin/v8/js/jquery.min.js"></script>
    <script src="{{static_front}}/static/front/signin/v8/js/css3-mediaqueries.js"></script>
</head>
<body>
<div class="stars"></div>
<div class="bgimg">
    <img src="{{static_front}}/static/front/signin/v8/img/bg.png">
</div>

<div id="wrapper">
    <input type="hidden" id="gid" value="{{.gameId}}">
    <!-- Header -->
    <header id="header">
        <div class="logo"></div>
        <div class="content">
            <div class="inner">
                <h1>{{.siteName}}{{.gameDesc}}</h1>
                <p>{{.announcement}}</p>
                <div class="iputzh">
                    <input type="text" id="account" placeholder="请输入会员账号"/>
                </div>
                {{if eq .gameStatus 2}}
                    <button onclick="carveup({{.gameId}})" class="button">点我瓜分</button>
                {{else}}
                    <button id="signin" class="button">点我签到</button>
                {{end}}
                <button id="query" class="button">点我查询</button>
                <button onclick="register()" class="button">点我注册</button>
            </div>
        </div>
        <nav>
            <ul>
                <li>
                    <a class="index" href="{{.officialSite}}" target="_blank">主页</a>
                </li>
                <li class="index">
                    <a href="{{.custServ}}" target="_blank">在线客服</a>
                </li>
            </ul>
        </nav>
        <div class="divbox">
            <marquee class="marqueebox" direction="up" scrollamount="1px" height="20px">
                <ul>
                    {{range $i, $v := .rrlList}}
                        <li>恭喜：<b>{{$v.account}}</b>
                            获得奖励 <span>{{$v.gift}}</span>
                        </li>
                    {{end}}
                </ul>
            </marquee>
        </div>
    </header>
    <div id="main">
        <!-- qiandao -->
        <article id="qiandao">
            <p text-align="center" style="color: yellow"><strong id="levelname"></strong></p>
            <h1 id="content" style="color: yellow"></h1>
            <p id="other" style="color: yellow"></p>
            <p><strong><!--感谢您对我们的长期支持！ --></strong></p>
        </article>
        <!-- chaxun -->
        <article id="chaxun">
            {{str2html .gameStatement}}
            <h2 class="major">尊敬的会员您好</h2>
            <p><strong>以下是您本次签到活动的签到所得</strong></p>
            <!-- <span class="image main"><img src="images/pic01.jpg" alt="" /></span> -->
            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                <tbody>
                <tr class="ad">
                    <td>签到奖励</td>
                    <td>签到时间</td>
                    <td>是否派彩</td>
                </tr>
                </tbody>
                <tbody id="rl_content">
                <tr>
                    <td>1.89 - XPJ-1</td>
                    <td>2019-04-25 13:49</td>
                    <td>
                        <font color="yellow">已派彩</font>
                    </td>
                </tr>
                <tr>
                    <td>1.30 - XPJ-1</td>
                    <td>2019-04-20 16:13</td>
                    <td>
                        <font color="yellow">已派彩</font>
                    </td>
                </tr>
                <tr>
                    <td>1.16 - XPJ-1</td>
                    <td>2019-04-18 18:27</td>
                    <td>
                        <font color="yellow">已派彩</font>
                    </td>
                </tr>
                </tbody>
            </table>
        </article>
    </div>
    <!-- Footer -->
    <footer id="footer">
        <p class="copyright">©2009-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p>
    </footer>
</div>
<script src="{{static_front}}/static/front/signin/v8/js/breakpoints.min.js"></script>
<script src="{{static_front}}/static/front/signin/v8/js/browser.min.js"></script>
<script src="{{static_front}}/static/front/signin/v8/js/css3-mediaqueries.js"></script>
<script src="{{static_front}}/static/front/signin/v8/js/jquery.min.js"></script>
<script src="{{static_front}}/static/front/signin/v8/js/main.js"></script>
<script src="{{static_front}}/static/front/signin/v8/js/particles.js"></script>
<script src="{{static_front}}/static/front/signin/v8/js/util.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script src="{{static_front}}/static/front/signin/v8/js/page.js"></script>
<script>
    $(document).ready(function () {
        var stars = 1000;
        var $stars = $(".stars");
        var r = 1000;
        for (var i = 0; i < stars; i++) {
            var $star = $("<div/>").addClass("star");
            $stars.append($star);
        }
        $(".star").each(function () {
            var cur = $(this);
            var s = 0.1 + (Math.random() * 1);
            var curR = r + (Math.random() * 300);
            cur.css({
                transformOrigin: "0 0 " + curR + "px",
                transform: " translate3d(0,0,-" + curR + "px) rotateY(" + (Math.random() * 360) + "deg) rotateX(" + (Math.random() *
                    -50) + "deg) scale(" + s + "," + s + ")"

            })
        })
    })
</script>
<script>
    function carveup(id) {
        var account = $("#account").val();
        var mobile = $("#mobile").val();
        var name = $("#name").val();
        if (account == "") {
            layer.msg("请输入会员账号");
            return;
        }
        if (mobile == "") {
            layer.msg("请输入手机号码");
            return;
        }
        if (name == "") {
            layer.msg("请输入真实姓名");
            return;
        }
        $.ajax({
            url: {{urlfor "SigninCarveUPApiController.Post"}},
            type: "post",
            data: {"id": id, "account": account, "mobile": mobile, "name": name},
            success: function (info) {
                if (info.code === 1) {
                    location.href = info.url;
                } else {
                    layer.msg(info.msg);
                }
            },
        });
    }
</script>
<script>
    function register() {
        var url = "{{.officialRegist}}";
        location.href = url
    }
</script>
</body>
</html>
