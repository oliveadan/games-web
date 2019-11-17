<!DOCTYPE html><html lang="zh-CN"><head>    <meta charset="utf-8">    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">    <title>{{.siteName}}-{{.gameDesc}}</title>    <link rel="stylesheet" href="{{static_front}}/static/front/guagua/css/mainf835.css">    <link rel="stylesheet" href="{{static_front}}/static/front/guagua/css/animate.min.css">    <link rel="stylesheet" href="{{static_front}}/static/front/guagua/css/style.css"></head><body id="toTop"><!-- 头部 --><div class="header">    <div class="headercon w1000">        <a class="logo" href='{{urlfor "GuaGuaggApiController.Get"}}'></a>        <div class="menu">            <ul>                <li><a target="_blank" href="{{.officialSite}}"><i class="i1"></i>                    <p>官方首页</p></a></li>                <li><a href="javascript:;"                       onClick="document.getElementById('light').style.display='block'; document.getElementById('fade').style.display='block'"><i                        class="i8"></i>                    <p>中奖查询</p></a></li>                <li><a target="_blank" href="{{.officialRegist}}"><i class="i5"></i>                    <p>免费注册</p></a></li>                <li class="last"><a target="_blank" href="{{.custServ}}"><i class="i6"></i>                    <p>在线客服</p></a></li>            </ul>        </div>    </div></div><!-- 刮奖 --><div class="scratchCard">    <div class="wrapper">        <div class="name">            <p>剩余刮奖次数：<b id="guaCount">{{.lotteryNums}}</b><span>次</span></p>            <a href="javascript:void(0)" onclick="onceAgain()">再来一次</a>        </div>        <div class="kuangao box" id="demoCanvas">            <button id="begin" style="position: absolute;left: 34%;top: 45%;z-index:-1" class="btn-search" type="submit"                    name="button">点击开始            </button>            <div class="box1" id="guajiang" style="visibility: hidden">                <div class="content" id="lottery" style="height:250PX;">                    <div id="mask_img_bg">未登录</div>                    <img id="redux" src="{{static_front}}/static/front/guagua/wap/images/gao4.jpg"/>                </div>            </div>            <!--画图工具画笔功能-->        </div>        <!-- 活动倒计时 -->        <div style="position:absolute;left:180px;top:375px;">            <b style="color:#f00; font-size:20px; font-weight:bold;">                <span style="color:#f00; font-size:16px; font-weight:bold;">{{.gameMsg}}</span></b>        </div>        <div class="search" style="{{if .loginAccount}}display:none;{{end}}">            <input type="hidden" id="gid" value="{{.gameId}}">            <input type="hidden" id="check" value="{{.loginAccount}}">            <div class="ipt-search">                <input type="text" id="username1" value="" placeholder="请输入您的账号">            </div>            <button id="login" class="btn-search" type="submit" name="button">点击验证</button>        </div>        <!-- 登录成功后显示 -->        <div class="logined" style="{{if eq .loginAccount ""}}display:none;{{end}}">            <span>会员 <b>{{.loginAccount}}</b></span><a href="javascript:;" onclick="exit()" class="qdbtn">退出</a></div>        <!-- 查询中奖信息弹窗 -->        <a href="javascript:void(0)"           onclick="document.getElementById('light').style.display='block'; document.getElementById('fade').style.display='block'"           class="winningBtn">中奖记录</a>        <!--滚动消息-->        <div class="notice">            <span>              <marquee direction="left" scrollamount="3" onmouseover="this.stop()"                       onmouseout="this.start()">{{.announcement}}</marquee>            </span>        </div>    </div></div><div class="bg2"></div><!-- 中间内容 --><div class="content">    <div class="中奖名单">        <!--中奖名单 -->        <div class="block1">            <div class="wrapper">                <div class="hd">                    <img src="{{static_front}}/static/front/guagua/images/hd-0.png" alt="">                </div>                <div class="winlist">                    <div class="gd1 bd">                        <ul>                        {{range $i, $v := .rlList}}                            <li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">刮出 <em                                    class="fc-red">{{$v.gift}}</em></span></li>                        {{end}}                        </ul>                    </div>                    <div class="gd2 bd bor-none">                        <ul>                        {{range $i, $v := .rlList1}}                            <li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">刮出 <em                                    class="fc-red">{{$v.gift}}</em></span></li>                        {{end}}                        </ul>                    </div>                </div>            </div>        </div>    </div>    <div class="block1">        <!--活动内容 -->        <div class="wrapper">            <div class="hd">                <img src="{{static_front}}/static/front/guagua/images/hd-1.png" alt="">            </div>        {{str2html .gameRule}}        </div>    </div>    <div class="block2">        <!--活动细则 -->        <div class="wrapper">            <div class="hd">                <img src="{{static_front}}/static/front/guagua/images/hd-2.png" alt="">            </div>            <p>            {{str2html .gameStatement}}            </p>        </div>    </div></div><!--底部结束--><div class="footer">    <div class="copyright">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div></div><a class="totop" href="#toTop"></a><!--中奖信息查询--><div id="light" class="white_content">    <div class="cxbox">        <div class="cxbox_bt">            <p>输入会员账号查询</p>            <a href="javascript:void(0)" style="color:#ffe681;text-decoration:none;"               onclick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'"               class="gban">X</a>        </div>        <div class="cxbox_hy">            <p>会员账号：</p>            <input id="querycode1" type="text" value="" placeholder="输入帐号">            <a href="javascript:queryBtnn()">查 询</a>        </div>        <div class="cxbox_bd" style="color:#ffe681;">            <table width="480" border="0" cellpadding="0" cellspacing="0">                <tbody>                <tr class="ad">                    <td>中奖内容</td>                    <td>中奖时间</td>                    <td>是否派彩</td>                </tr>                </tbody>                <tbody id="query_content"></tbody>            </table>            <div class="quotes" style="padding:10px 0px;"></div>        </div>    </div></div><!--中奖查询结束 --><script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script><script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script><script type="text/javascript" src="{{static_front}}/static/front/guagua/wap/js/jquery.eraser.js"></script><script type="text/javascript" src="{{static_front}}/static/front/guagua/js/guagua.js"></script><script type="text/javascript" src="{{static_front}}/static/front/js/jquery.SuperSlide.2.1.1.js"></script><script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script><script type="text/javascript">    //再来一次    function onceAgain() {        if ($("#check").val() == "") {            layer.msg("请登录后再开始抽奖！~~~");            return        } else if ($('#guaCount').text() == "0") {            layer.msg("您没有活动参与资格或者已经参与过了哦！")            return        }        var gid = $("#gid").val();        var account = $("#account").val()        location.href = "{{urlfor "GuaGuaApiController.get"}}" + "?gid=" + gid;    }    /*登录*/    $("#login").click(function () {        if ($("#username1").val() == "") {            layer.msg("会员账号不能为空");            return        }        login();    });    //登录    function login() {        $.ajax({            url: '/login',            dataType: 'json',            cache: false,            type: 'POST',            data: {gid: $("#gid").val(), account: $("#username1").val()},            success: function (obj) {                switch (obj.code) {                    case 0:                        localStorage.clear();                        layer.msg(obj.msg);                        break;                    case 1:                        _username = $("#username1").val();                        localStorage.username = _username;                        $('.logined').fadeIn();                        setTimeout(function () {                            location.href = location.href;                        }, 100);                        break;                    default:                        break;                }            },            error: function (XMLHttpRequest, textStatus, errorThrown) {                var x = 1;                localStorage.clear();            }        });    };    /*点击开始*/    $("#begin").click(function () {        if ($("#check").val() == "") {            layer.msg("请登录后再开始抽奖！~~~");            return        }        scratchoff()    });    function scratchoff() {        $.post('{{urlfor "LotteryController.Lottery"}}', {                    gid: $("#gid").val(),                    account: $("#check").val()                },                function (obj) {                    switch (obj.code) {                        case 0:                            localStorage.clear();                            layer.msg(obj.msg);                            break;                        case 1:                            $("#lottery").css("visibility","visible");                            $("#begin").hide();                            $("#mask_img_bg").text(obj.data.gift);                            $('#guaCount').html($('#guaCount').text() - 1)                            break;                        case 2:                            $("#lottery").css("visibility","visible");                            $("#begin").hide();                            $('#guaCount').html($('#guaCount').text() - 1)                            $("#mask_img_bg").text(obj.msg);                        default:                            break;                    }                });    }</script><script>    jQuery(".gd1").slide({        mainCell: "ul",        autoPlay: true,        effect: "topMarquee",        vis: 6,        interTime: 40,        trigger: "click"    });    jQuery(".gd2").slide({        mainCell: "ul",        autoPlay: true,        effect: "topMarquee",        vis: 6,        interTime: 40,        trigger: "click"    });</script></body></html>