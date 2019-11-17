<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes"/>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" href="app.png">
    <script type="text/javascript" src="{{static_front}}/static/front/red/v2/wap/js/respond.min.js"></script>
    <link rel="stylesheet" href="{{static_front}}/static/front/red/v2/css/reset.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/red/v2/wap/css/style.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<input type="hidden" id="phone" value="{{.phone}}">
<!--[if lt IE 8]>
<p class="browserupgrade">当前浏览器版本太低,建议升级道最新版本</p>
<![endif]-->
<div class="header">
    <a href='{{urlfor "RedApiController.Get"}}' class="logo"></a>
    <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="search"></a>
</div>

<div class="main">
    <div class="mammon"></div>
    <input type="text" name="commentNameField" id="username" class="userinput1" placeholder="请输入会员账号">
    <input type="text" name="mobilenum" id="mobilenum" class="userinput" placeholder="请输入手机号码">
    <a href="javascript:;" onClick="checkUser()" class="subbtn">领取年终奖</a>
    <div class="countdowntips"></div>
    <div class="wininfobg">
        <div class="wininfo">
            <ul>
            {{range $i, $v := .rlList}}
           {{if eq $v.gift "8.8"}}
						{{else}}
							<li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">获得 <em class="fc-red">{{$v.gift}}</em></span></li>
						{{end}}
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
<div id="hongbao_back" class="hide" style="display:none;"></div>
<div id="hongbao_open" class="popup flip" style="display:none;">
    <div class="popup-t">
        <a href="javascript:;" onclick="close_hongbao()" class="close"></a>
        <p class="b5" id="b5">恭喜发财，大吉大利!</p>
        <p class="b4" id="b4">您还有<span id="lotteryNums">0</span>次机会</p>
        <a href="javascript:;" onclick="startGame()" class="b6"></a>
    </div>
</div>
<div id="hongbao_result" class="reward flip" style="display:none;">
    <div class="reward-t">
        <a href="javascript:;" onclick="close_hongbao()" class="close"></a>
    </div>
    <div class="reward-b">
        <p class="w2">恭喜发财，大吉大利!</p>
        <p class="w3">00.00<em>元</em></p>
    </div>
</div>

<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/red/v2/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script type="text/javascript">
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