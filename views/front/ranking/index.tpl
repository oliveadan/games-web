<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/ranking/css/style.css">
    <!-- my -->
    <link rel="stylesheet" href="{{static_front}}/static/front/ranking/css/my.css">
    <link type="text/css" rel="stylesheet" media="all" href="{{static_front}}/static/front/ranking/css/style1.css">
</head>
<body>
<!-- header s -->
<header class="header">
    <div class="head container">
        <div class="logo fl"><a href="{{.officialSite}}"><img src="{{static_front}}/static/img/logo240x80.png" alt=""></a></div>
        <div class="phonenavli fr tc"><img src="{{static_front}}/static/front/ranking/images/phonenav.png"></div>
        <div class="nav fr">
            <ul>
                <li class="on"><a href="#"></a></li>
                <li><a href="{{.officialSite}}" target="_blank">官方首页</a></li>
                <li><a href="{{.officialRegist}}" target="_blank">免费注册</a></li>
                <li><a href="{{.custServ}}" target="_blank">在线客服</a></li>
            </ul>
        </div>
    </div>
</header>
<!-- header e -->
<!-- main s -->
<div class="banner ht_over">
    <div class="phoneimg"><img src="{{static_front}}/static/front/ranking/images/banner.jpg" class="bannerimg" alt="">
        <div class="searchbox">
            <input id="gameid" value="{{.gameid}}" type="hidden">
            <div class="searchimg tc"><img src="{{static_front}}/static/front/ranking/images/searchbox.png" alt="">
                <input type="text" class="fl" id="checkaccount" placeholder="请输入会员账号">
                <button class="block tc fl" onclick="showDetail()"></button>
            </div>
        </div>
    </div>
</div>
<div class="bigbox ht_over">
    <div class="noticebox">
        <div class="notice container"><span><img src="{{static_front}}/static/front/ranking/images/video.png" align="absmiddle" alt="">&nbsp;&nbsp;最新公告：</span>
            <div class="margue">
                <marquee direction="left" scrollamount="2" onmouseover="this.stop()" onmouseout="this.start()">
                {{.announcement}}
                </marquee>
            </div>
        </div>
    </div>
    <div class="mainbox ht_over">
        <div class="main container" id="main">
            <div class="mainnav  ht_over clearfix" id="mainnav">
                <ul>
                    <li><a href="javascript:;"><img src="{{static_front}}/static/front/ranking/images/titlegz.png" alt=""></a></li>
                    <li><a href="javascript:;"><img src="{{static_front}}/static/front/ranking/images/titlezp.png" alt=""></a></li>
                    <li><a href="javascript:;"><img src="{{static_front}}/static/front/ranking/images/titleyp.png" alt=""></a></li>
                    <li><a href="javascript:;"><img src="{{static_front}}/static/front/ranking/images/titlexy.png" alt=""></a></li>
                    <li><a href="javascript:;"><img src="{{static_front}}/static/front/ranking/images/titlettozp.png" alt=""></a></li>
                </ul>
            </div>
            <div class="tabbox" style="display:block;">
                <div class="title tc navPage">活动详情</div>
            {{str2html .gameRule}}
                <div class="title tc">活动细则</div>
                <p class="maintext2">
                {{str2html .gameStatement}}
                </p>
            </div>
            <div class="tabbox">
                <div class="title tc navPage">周排行</div>
                <div class="selectbox">
                    <label>请选择期数:</label>
                    <div class="fm-select">
                        <div class="fm-select">
                            <select  id="Weekperiod" name="cate_id">
                            {{range $i, $m := .weekperiods}}
                                <option value="{{index $m 0}}">{{index $m 1}}</option>
                            {{end}}
                            </select>
                        </div>
                    </div>
                    <input id="WeekQuery" onclick="WeekQuery()" type="button" value="查询" class="button1"/>
                </div>
                <div class="tbl2-box">
                    <table class="tbl2">
                        <tr>
                            <th style="width:33%">会员帐号</th>
                            <th style="width:33%">有效投注</th>
                            <th style="width:33%">排名</th>
                        </tr></table>
                    <table class="tbl2" id="Weektr">
                    </table>
                    <div id="barcon1" name="barcon"></div>
                </div>
            </div>
            <div class="tabbox">
                <div class="title tc navPage">月排行</div>
                <div class="selectbox">
                    <label>请选择月份:</label>
                    <div class="fm-select">
                        <select id="Monthperiod" name="cate_id">
                        {{range $i, $m := .mothperiods}}
                            <option value="{{index $m 0}}">{{index $m 1}}</option>
                        {{end}}
                        </select>
                    </div>
                    <input id="MonthQuery" onclick="MonthQuery()" type="button" value="查询" class="button1"/>
                </div>
                <div class="tbl2-box">
                    <table class="tbl2">
                        <tr>
                            <th style="width:33%">会员帐号</th>
                            <th style="width:33%">有效投注</th>
                            <th style="width:33%">排名</th>
                        </tr></table>
                    <table class="tbl2" id="Monthtr">
                    </table>
                    <div id="barcon2" name="barcon"></div>
                </div>
            </div>
            <div class="tabbox">
                <div class="title tc navPage">幸运榜</div>
                <div class="selectbox">
                    <label>请选择期数:</label>
                    <div class="fm-select">
                        <select id="luckyperiod" name="cate_id">
                        {{range $i, $m := .weekperiods}}
                            <option value="{{index $m 0}}">{{index $m 1}}</option>
                        {{end}}
                        </select>
                    </div>
                    <input onclick="luckyQuery()" type="button" value="查询" class="button1"/>
                </div>
                <div class="tbl2-box">
                    <table class="tbl2">
                        <tr>
                            <th style="width:33%">会员帐号</th>
                            <th style="width:33%">有效投注</th>
                            <th style="width:33%">排名</th>
                        </tr></table>
                    <table class="tbl2" id="luckytr">
                    </table>
                    <div id="barcon3" name="barcon"></div>
                </div>
            </div>
            <div class="tabbox">
                <div class="title tc navPage">总排行</div>
                <div class="tbl2-box">
                    <table class="tbl2">
                        <tbody>
                        <tr>
                            <th style="width:33%">会员帐号</th>
                            <th style="width:33%">有效投注</th>
                            <th style="width:33%">排名</th>
                        </tr>
                        {{range $i, $m := .total}}
                        <tr>
                            <td>{{$m.Account}}</td>
                            <td>{{$m.Amount}}</td>
                            <td>{{$m.Seq}}</td>
                        </tr>
                        {{end}}

                    </table>
                </div>
            </div>
            <!-- footer s -->
            <footer class="footer tc">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</footer>
            <!-- footer e -->
        </div>
    </div>
    <!-- main e -->

    <div class="fixedrt">
        <div class="fixrtimg"><img src="{{static_front}}/static/front/ranking/images/fixedright.png" alt=""></div>
        <a class="hourimg" href="{{.custServ}}"
           target="_blank"></a> <a class="goTop" id="goTop" href="#"></a></div>
</div>
<!-- 弹出 -->
<div id="show" style="display:none;">
    <div id="tangchuang">
        <div id="close"></div>
        <div id="stitle">查询中心</div>

        <div style=" overflow-y: scroll; overflow-x: hidden; height:500px; margin-bottom: 10px;">
            <div class="l6" style="width:96%;margin-left:15px;margin-right:15px">
                <div style="width:20%">会员帐号</div>
                <div style="width:20%">有效投注</div>
                <div class="last" style="width:20%">总排名</div>
                <div style="width:20%">奖品</div>
                <div style="width:20%">派奖状态</div>
            </div>
            <div id="total" class="l6 clearMargin white" style="width:96%;margin-left:15px;margin-right:15px">
                <div style="width:20%">无</div>
                <div style="width:20%">未计算</div>
                <div class="last" style="width:20%">未进入排名</div>
                <div  style="width:20%">无</div>
                <div  style="width:20%">无</div>
            </div>
            <div class="l6" style="width:96%;margin-left:15px;margin-right:15px">
                <div style="width:16%">会员帐号</div>
                <div style="width:16%">有效投注</div>
                <div style="width:16%">排名</div>
                <div style="width:20%">周排行</div>
                <div style="width:16%">奖品</div>
                <div style="width:16%">派奖状态</div>
            </div>
            <div id="week" class="l6 clearMargin white" style="width:96%;margin-left:15px;margin-right:15px">
                <div style="width:20%">无</div>
                <div style="width:20%">没有投注</div>
                <div style="width:20%">未进入排名</div>
                <div style="width:35%">无</div>
            </div>
            <div class="pages" style="width:96%;margin-left:15px;margin-right:15px">
                <div id="weekpages" class="total">共0条</div>
            </div>
            <div  class="l6" style="width:96%;margin-left:15px;margin-right:15px">
                <div style="width:16%">会员帐号</div>
                <div style="width:16%">有效投注</div>
                <div style="width:16%">排名</div>
                <div style="width:20%">月排行</div>
                <div style="width:16%">奖品</div>
                <div style="width:16%">派奖状态</div>
            </div>
            <div id="month" class="l6 clearMargin white" style="width:96%;margin-left:15px;margin-right:15px">
                <div style="width:20%">无</div>
                <div style="width:20%">没有投注</div>
                <div style="width:20%">未进入排名</div>
                <div style="width:35%">无</div>
            </div>
            <div  class="pages" style="width:96%;margin-left:15px;margin-right:15px">
                <div id="monthpages" class="total">共0条</div>
            </div>
        </div>
    </div>
</div>
<!-- 弹出 -->
<script src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script  type="text/javascript" src="{{static_front}}/static/front/ranking/js/Query.js"></script>

<script type="text/javascript">
    $('#close').click(function () {
        $(this).parent().parent().hide();
    });
</script>
<script type="text/javascript">
    document.createElement('header');
    document.createElement("footer");
    $(function () {

        $(".phonenavli").on('click', function (event) {
            event.preventDefault();
            $(".nav").slideToggle('slow');
        });
        //
        $("#mainnav").on('click', 'li', function (event) {
            event.preventDefault();
            var index = $(this).index();
            $("#main .tabbox").eq(index).show().siblings('.tabbox').hide();
        });
        //返回顶部
        $("#goTop").click(function () {
            $("html,body").animate({scrollTop: 0}, 500);
        });
    })
</script>
</body>
</html>
