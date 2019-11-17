<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes"/>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" href="app.png">
    <script type="text/javascript" src="{{static_front}}/static/front/red/v3/wap/js/respond.min.js"></script>
    <link rel="stylesheet" href="{{static_front}}/static/front/red/v3/css/reset.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/red/v3/wap/css/style.css">
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
    <input type="text" name="commentNameField" id="username"
           onBlur="if (this.placeholder == '') this.placeholder = '请输入会员账号';"
           onFocus="if (this.placeholder == '请输入会员账号') this.placeholder = '';" value="" placeholder="请输入会员账号"
           class="userinput">
    <a href="javascript:;" onClick="checkUser()" class="subbtn">点击抢红包</a>
    		<!-- 倒计时 -->
		<div class="daojishi">
			<span class="tips" id="tips"></span>
			<span class="count-down" id="count-down"></span>
		</div>
    <div class="countdowntips"></div>
    <div class="wininfobg">
        <div class="wininfo">
            <ul>
            {{range $i, $v := .rlList}}
                <li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span><span>获得红包<i>{{$v.gift}}</i></span></li>
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
<div id="hongbao_open" class="popup" style="display:none;">
    <div class="popup-t">
        <a href="javascript:;" onclick="close_hongbao()" class="close"></a>
        <p class="b5" id="b5">恭喜发财，大吉大利!</p>
        <p class="b4" id="b4">您还有<span id="lotteryNums">0</span>次机会</p>
        <a href="javascript:;" onclick="startGame()" class="b6"></a>
    </div>
</div>
<div id="hongbao_result" class="reward" style="display:none;">
    <div class="reward-t">
        <a href="javascript:;" onclick="close_hongbao()" class="close"></a>
    </div>
    <div class="reward-b">
        <p class="w2">恭喜发财，大吉大利!</p>
        <p class="w3">00.00<em>元</em></p>
    </div>
</div>

<div  id="login_box" class="tantit3">
    <div class="tancontent tancontent3">
        <a href="#"onclick="this.parentNode.parentNode.style.display='none'" class="tantit-close"> </a>
        <div class="gdcon">
            <div class="content">
                <form>
                    <input type="text" class="hb-inp" name="commentNameField" id="username1">
                    <input type="button" onclick="startGame()" class="hb-button ljlllq fl" value="立即领取" />
                </form>
            </div>
        </div>

    </div>
</div>


<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/red/v3/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script type="text/javascript" src="{{static_front}}/static/js/snow.jquery.js"></script>
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
<script>
    //如果活动在进行中飘雪花，其他活动状态不飘
    var status = {{.gameStatus}};
    var bool = false;
    if(status == 3 ){
        bool = true
    }
    if(bool){
        $(document).snowfall('clear');
        $(document).snowfall({
            image: "{{static_front}}/static/front/red/v3/images/piao.png",
            flakeCount:9,
            minSize: 30,
            maxSize: 70,
            minSpeed: 1,
            maxSpeed: 2,
        });
        $('.snowfall-flakes').on('click',function(){
            close_hongbao();
            $('#login_box').show();
        })
    }
</script>
<script type="text/javascript"> 
	var t = {{.countDown}};
	var int;
	var gameMsg = "";
	{{if eq .gameStatus 1}}
		gameMsg = "抢红包即将开始";
	{{else if eq .gameStatus 2}}
		gameMsg = "本期抢红包已结束，敬请期待下期！";
	{{else if eq .gameStatus 3}}
		gameMsg = "抢红包进行中";
	{{else}}
		gameMsg = {{.gameMsg}}
	{{end}}
	document.getElementById("tips").innerHTML = gameMsg;
	
	function getRTime(){
		if(t<=0) {
			window.clearInterval(int);
			location.href = location.href;
		}
		var d=Math.floor(t/60/60/24); 
		var h=Math.floor(t/60/60%24); 
		var m=Math.floor(t/60%60); 
		var s=Math.floor(t%60);
		
		var countDownMsg = "";
		if(d>0) {
			countDownMsg += d + "天";
		}
		if(h>0) {
			countDownMsg += h + "时";
		}
		if(m>0) {
			countDownMsg += m + "分";
		}
		if(s>0) {
			countDownMsg += s + "秒";
		} else {
			countDownMsg += "00秒";
		}
		document.getElementById("count-down").innerHTML = "倒计时：" + countDownMsg;
		t = t-1;
	}
	if(t > 0) {
		int = setInterval(getRTime,1000);
	}
</script>
</body>
</html>