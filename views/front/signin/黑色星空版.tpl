<!DOCTYPE HTML>
<html>
<head>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no"/>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v8/assets/css/main.css"/>
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v8/assets/css/style.css">
    <noscript>
        <link rel="stylesheet" href="{{static_front}}/static/front/signin/v8/assets/css/noscript.css"/>
    </noscript>
</head>
<body class="is-preload">

<!-- Wrapper -->
<div id="rapper">
    <input type="hidden" id="gid" value="{{.gameId}}">


    <!-- Header -->
    <div style="height:60px">
        <!--光点 -->
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <div class="circle-container">
                <div class="circle"></div>
            </div>
            <!--光点 -->
    </div>
    <header id="header">
        <div class="logo"></div>
        <div class="content">
            <div class="inner">
                <h1>{{.siteName}}签到第七期</h1>
                <p>签到让你赚钱有道，而不仅仅只是因为坚持</p>
                <div class="iputzh">
                    <label for="name"></label>
                    <input type="text"  id="account" placeholder="请输入会员账号"/>
                </div>
                <button  id="signin" class="button">点我签到</button>
                <button  id="query" class="button">点我查询</button>
            </div>
        </div>
        <nav>
            <ul>
                <li><a href="{{.officialSite}}" target="_blank">主页</a></li>
                <li>
                    <a href="{{.custServ}}" target="_blank">在线客服</a>
                </li>

            </ul>
        </nav>
    </header>
    <div id="main">
        <!-- qiandao -->
        <article id="qiandao">
            <p text-align="center" style="color: yellow"><strong>您本次签到获得了</strong></p>
            <h1 id="content" style="color: yellow">88.88元</h1>
            <p id="other"   style="color: yellow"></p>
            <p><strong>感谢您对我们的长期支持！</strong></p>
        </article>
        <!-- chaxun -->
        <article id="chaxun">
            <h2 class="major">尊敬的会员您好</h2>
            <p><strong>以下是您本次签到活动的签到记录</strong></p>
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
                    <td><font color="yellow">已派彩</font></td>
                </tr>
                <tr>
                    <td>1.30 - XPJ-1</td>
                    <td>2019-04-20 16:13</td>
                    <td><font color="yellow">已派彩</font></td>
                </tr>
                <tr>
                    <td>1.16 - XPJ-1</td>
                    <td>2019-04-18 18:27</td>
                    <td><font color="yellow">已派彩</font></td>
                </tr>
                </tbody>
            </table>
            <div class="rl_pages"></div>
        </article>

        <!-- Intro -->
    </div>

    <!-- Footer -->
    <footer id="footer">
        <p>{{.siteName}}</p>
        <p class="copyright">©2009-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p>
    </footer>
</div>


<!-- Scripts -->
<script src="{{static_front}}/static/front/signin/v8/assets/js/jquery.min.js"></script>
<script src="{{static_front}}/static/front/signin/v8/assets/js/browser.min.js"></script>
<script src="{{static_front}}/static/front/signin/v8/assets/js/breakpoints.min.js"></script>
<script src="{{static_front}}/static/front/signin/v8/assets/js/util.js"></script>
<script src="{{static_front}}/static/front/signin/v8/assets/js/main.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script src="{{static_front}}/static/front/signin/v8/assets/js/page.js"></script>
</body>
</html>
