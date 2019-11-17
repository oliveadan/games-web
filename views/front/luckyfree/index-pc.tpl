<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="renderer" content="webkit">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" rev="stylesheet" href="{{static_front}}/static/front/luckyfree/css/reset.css" type="text/css" />
    <link rel="stylesheet" rev="stylesheet" href="{{static_front}}/static/front/luckyfree/css/global.css" type="text/css" />
    <link rel="stylesheet" rev="stylesheet" href="{{static_front}}/static/front/luckyfree/css/animation.css" type="text/css" />
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header">
    <div class="inner">
        <div class="cl h7"></div>
        <div class="cl"></div>
        <div class="logo"><h1><a href="#" class="" ><img src="{{static_front}}/static/img/logo240x80.png" alt="" /></a></h1></div>
        <div class="cl h16"></div>
        <div class="nav fl">
            <ul>
                <li class="cur"><a href="{{.officialSite}}" target="_blank">首页        </a></li>
                <li><a href="{{.officialRegist}}" target="_blank" id="LINK_REG_PC">免费注册    </a></li>
                <li><a href="{{.rechargeSite}}" target="_blank" id="LINK_PAY_PC">极速入款    </a></li>
            </ul>
        </div>

        <div class="nav fr">
            <ul>
                <li><a href="{{.officialPromot}}" target="_blank" id="LINK_LINE_PC">优惠活动 </a></li>
                <li><a href="javascript:;" onclick="showQuery();">中奖查询 </a></li>
                <li><a href="{{.custServ}}" target="_blank" id="LINK_KF_PC">在线客服 </a></li>
            </ul>
        </div>
        <div class="cl"></div>
    </div>
</div>

<div class="inner">
    <div class="cshooci" id="login-status">
        <span onclick="showLogin();">点击登录</span>
    </div>

    <div class="jiangbx">
        <div class="jiangbxin" id="lottery">
      <!--  <a class="lottery-unit lottery-unit-0 jiam jiam1"><img src="/static/front/luckyfree/images/10.png" alt=""></a>
            <a class="lottery-unit lottery-unit-1 jiam jiam2"><img src="/static/front/luckyfree/images/1.png" alt=""></a>
            <a class="lottery-unit lottery-unit-2 jiam jiam3"><img src="/static/front/luckyfree/images/2.png" alt=""></a>
            <a class="lottery-unit lottery-unit-3 jiam jiam4"><img src="/static/front/luckyfree/images/3.png" alt=""></a>
            <a class="lottery-unit lottery-unit-9 jiam jiam5"><img src="/static/front/luckyfree/images/4.png" alt=""></a>
            <a href="#" class="jiam jiam6"><span class="csinx btn-choujiang">点击登录</span></a>
            <a class="lottery-unit lottery-unit-4 jiam jiam7"><img src="/static/front/luckyfree/images/5.png" alt=""></a>
            <a class="lottery-unit lottery-unit-8 jiam jiam8"><img src="/static/front/luckyfree/images/6.png" alt=""></a>
            <a class="lottery-unit lottery-unit-7 jiam jiam9"><img src="/static/front/luckyfree/images/7.png" alt=""></a>
            <a class="lottery-unit lottery-unit-6 jiam jiam10"><img src="/static/front/luckyfree/images/8.png" alt=""></a>
            <a class="lottery-unit lottery-unit-5 jiam jiam11"><img src="/static/front/luckyfree/images/9.png" alt=""></a> -->
            {{range $i, $v := .gifts1}}
                <a class="lottery-unit lottery-unit-{{if eq $v.Seq 1 }}0{{else if eq $v.Seq 2}}1 {{else if eq $v.Seq 3}}2{{else if eq $v.Seq 4}}3{{else if eq $v.Seq 5}}9{{end}}
                jiam jiam{{$v.Seq}}"><img src="{{$v.Photo}}" alt=""></a>
            {{end}}
                <a href="#" class="jiam jiam6"><span class="csinx btn-choujiang">点击登录</span></a>
            {{range $i, $v := .gifts2}}
              <a class="lottery-unit lottery-unit-{{if eq $v.Seq 7 }}4{{else if eq $v.Seq 8}}8 {{else if eq $v.Seq 9}}7{{else if eq $v.Seq 10}}6{{else if eq $v.Seq 6}}5{{end}}
               jiam jiam{{if eq $v.Seq 6 }}11{{else}}{{$v.Seq}}{{end}}"><img src="{{$v.Photo}}" alt=""></a>
            {{end}}
        </div>
    </div>
    <div class="cl"></div>
    <div class="houbx">
        <div class="cl h60"></div>
        <div class="gd1">
            <ul>
            {{range $i, $v := .rlList}}
                <li><span class="fl w85">{{$v.account}}</span><span class="fl w171">抽中 {{$v.gift}}</span></li>
            {{end}}
            </ul>
        </div>
        <div class="cl"></div>
    </div>
    <div class="cl"></div>
    <div class="contin">
        <div id="yhwa" class="rules">
          {{str2html .gameRule}}
        </div>
        <div id="yhwa" class="rules">
           {{str2html .gameStatement}}
        </div>
    </div>
    <div class="cl"></div>
    <div class="cop">
        <br>Copyright ©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.
    </div>
    <div class="cl"></div>
</div>


<div class="tanbx" style="display:none" id="window-query">
    <div class="tawinbx">
        <div class="tanentou">输入会员账号查询</div>
        <a href="javasript:;" class="closex" ></a>
        <div class="lells">会员账号：  <input id="query-username" type="text" class="sahsibopt" value="" />
            <a href="#" class="pl8" onclick="query();" ><img src="{{static_front}}/static/front/luckyfree/images/chabtn.png" class="vm" alt="" /></a>
        </div>
        <table class="chast">
            <tr class="tashhtou">
                <td>奖品 </td>
                <td>时间 </td>
                <td>是否派彩 </td>
            </tr>
            <tbody id="query-result">
            </tbody>
        </table>
        <div class="quotes" style="padding: 10px 0px;"></div>
    </div>
</div>

<div class="tanbx" style="display:none" id="window-login">
    <div class="tawinbx1">
        <div class="tanentou">请先登陆</div>
        <a href="javasript:;" class="closex" ></a>

        <div class="lells">
            会员账号：  <input id="username" type="text" class="sahsibopt" value="" />
            <a href="javascript:;" onclick="login();" class="pl8" >
                <img src="{{static_front}}/static/front/luckyfree/images/login.png" class="vm" alt="" />
            </a>
        </div>
    </div>
</div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/luckyfree/js/demo.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/luckyfree/js/index.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/luckyfree/js/lucky.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.SuperSlide.2.1.1.js"></script>
<script>
    $(function () {
        var username2 = localStorage.getItem("username");
        if (username2 != null){
            var str = '您还有' + '<span class="huang">'+'{{.lotteryNums}}'+'</span>'+'次抽奖机会'+'</br>';
            var exit = '<a href="javascript:(0);" onclick="exit()">'+'退出'+'</a>';
            $('.btn-choujiang').html('-1抽奖次数');
            $("#login-status").html(str+exit);
        }
    });
</script>
<script type="text/javascript">
    jQuery(".gd1").slide({mainCell:"ul",autoPlay:true,effect:"topMarquee",vis:6,interTime:40,trigger:"click"});
</script>
</body>
</html>
