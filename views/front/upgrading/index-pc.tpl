<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="lt-ie9 lt-ie8 lt-ie7 no-js" lang="en"> <![endif]-->
<!--[if IE 7]>         <html class="lt-ie9 lt-ie8 no-js" lang="en"> <![endif]-->
<!--[if IE 8]>         <html class="lt-ie9 no-js" lang="en"> <![endif]-->
<!--[if gt IE 8]><!-->
<html class="no-js" lang="en">
<!--<![endif]-->
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <meta name="description" content="太阳城集团">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico"/>
    <link rel="stylesheet" href="{{static_front}}/static/front/upgrading/css/active.all.min.css?V=1.0">
    <link rel="stylesheet" href="{{static_front}}/static/front/upgrading/css/animate.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/upgrading/css/style.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/upgrading/css/my.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/upgrading/css/style1.css">
</head>

<body id="toTop" class="vip">
<div class="header">
    <div class="wrapper">
        <img class="logo" src="{{static_front}}/static/img/logo240x80.png" alt="">
        <ul class="nav">
            <li><a href="{{.officialSite}}" target="_blank">官网首页</a></li>
            <li><a href="{{.officialRegist}}" target="_blank">会员注册</a></li>
            <li><a href="{{.custServ}}" target="_blank">在线客服</a></li>
        </ul>
    </div>
</div>
<div class="search">
    <div class="wrapper">
        <div class="inner2">
            <input type="text" id="search1" name="search1" value="" placeholder="请输入会员账号">
            <button onClick="showDetail()" class="btn-search" type="button" name="button"></button>
        </div>
    </div>
</div>
<div class="content wrapper">
    <div class="hd">
        <img src="{{static_front}}/static/front/upgrading/images/info1.png" alt="">
    </div>
    <div class="box box_1">
    {{str2html .gameRule}}
        <h2 class="hd"><img src="{{static_front}}/static/front/upgrading/images/info2.png" alt=""></h2>
        <div class="box box_3">
        {{str2html .gameStatement}}
        </div>
    </div>

    <div class="footer tc">
        ©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.
    </div>
    <!-- 弹出 -->
    <div id="show">
        <div id="tangchuang">
            <div id="close"></div>
            <div id="stitle">查询中心</div>
            <div style=" overflow-y: scroll; overflow-x: hidden; height: 500px; margin-bottom: 10px;">
            <div class="l8" style="width:100%;margin-left:15px;margin-right:15px">
                <div>会员帐号</div>
                <div>当前等级</div>
                <div style="width:20%">累计总投注金额</div>
                <div style="width:10%">累计晋级彩金</div>
                <div style="width:10%">周俸禄</div>
                <div style="width:10%">月俸禄</div>
                <div class="last" style="width:25%">距离晋级需总投注金额</div>
            </div>
            <div id="totalup" class="l8 clearMargin white" style="width:100%;margin-left:15px;margin-right:15px">
                <div>无</div>
                <div>无等级</div>
                <div style="width:20%">无</div>
                <div style="width:10%">无</div>
                <div style="width:10%">无</div>
                <div style="width:10%">无</div>
                <div class="last" style="width:25%">无</div>
            </div>
            <div class="l8" style="width:100%;margin-left:15px;margin-right:15px">
                <div style="width:20%">会员帐号</div>
                <div style="width:20%">当周投注金额</div>
                <div style="width:20%">晋级彩金</div>
                <div style="width:35%">投注周期</div>
            </div>
            <div id="weekup" class="l8 clearMargin white" style="width:100%;margin-left:15px;margin-right:15px">
                <div style="width:20%">无</div>
                <div style="width:20%">无</div>
                <div style="width:20%">无</div>
                <div style="width:35%">无</div>
            </div>
            <div class="pages" style="width:100%;margin-left:15px;margin-right:15px">
                <div id="countweek" class="total">共0条</div>
            </div>
            </div>
        </div>
    </div>
</div>
</body>
<script src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script src="{{static_front}}/static/front/upgrading/js/Query.js"></script>
</body>
</html>
