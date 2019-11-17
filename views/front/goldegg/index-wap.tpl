<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes" />
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
<link rel="apple-touch-icon" href="app.png">
<script src="{{static_front}}/static/front/goldegg/wap/js/respond.min.js"></script>
<link rel="stylesheet" href="{{static_front}}/static/front/goldegg/css/animate.min.css">
<link rel="stylesheet" href="{{static_front}}/static/front/goldegg/css/reset.css">
<link rel="stylesheet" href="{{static_front}}/static/front/css/common-wap.css" />
<link rel="stylesheet" href="{{static_front}}/static/front/goldegg/wap/css/style.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="headerseat"></div>
<div class="header" id="header">
    <a href="{{urlfor "GoldeggApiController.Get"}}" class="logo"></a>	
    <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="search"></a>	
</div>
<div class="zjdmain">
	<div class="egg">
		<ul class="eggList">
			<p class="hammer" id="hammer"></p>					
			<li><span></span><sup></sup></li>
			<li><span></span><sup></sup></li>
			<li><span></span><sup></sup></li>
		</ul>
	</div>	
	<div class="logined"><span>会员<b id="username">user</b></span><span>还有<b id="draw">0</b>次</span>机会<a  href="javascript:;" onclick="exit()" class="btn">退出</a></div>   
	<div class="wininfobg">
		<div class="wininfo">
			<ul>
			{{range $i, $v := .rlList}}
				<li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span><span>砸中<i>{{$v.gift}}</i></span></li>
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
    <div class="picture"></div>
	<div class="wintext"></div>
    <button class="layui-layer-close makesure">确定</button>
</div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/goldegg/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.rotate.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){
	_username=localStorage.getItem("username");
	checkUser();
}
var isture = 0;
function eggClick(obj,state) {
	isture = true;
	var _this = obj;
	var _state = state;
		$(".hammer").css({"top":_this.position().top-65,"left":_this.position().left+125});
		$(".hammer").animate({
			"top":_this.position().top-25,
			"left":_this.position().left+80
			},100,function(){
			_this.find("span").addClass("animated wobble");
			setTimeout(function(){_this.find("span").removeClass("wobble");_this.fadeIn().addClass("animated tada");_this.addClass("curr");},1000)
			setTimeout(function(){_this.find("sup").fadeIn().addClass("animated bounceIn"); },500)
			$(".hammer").addClass("animated rollOut");
			setTimeout(function() {
				if(_state==10){layer.msg("很遗憾，没有中奖，再来一次吧！",{icon:5,time:1800});isture = false;}
				if(_state==0){layer.open({type: 1, zIndex: 100, title: false,area: ['5.64rem'],skin: 'layui-layer-nobg',shade: 0.7,closeBtn :true,shadeClose: true,content: $('.tcwin')});isture = false;}}, 2000);

		});
}
$(".eggList li").click(function() {
	var _this = $(this);
	if(_this.parent().find("li").hasClass("curr")){
		layer.msg("已经砸过了，再来一次吧！",{icon:2,time:1800},function(){window.location.reload()});
		return false;
	}
	var posL = $(this).position().left+100;
	$("#hammer").show().stop().animate({'left':posL},150);
	checklogin(_this);
});

function autoScroll(obj){  
	$(obj).find("ul").animate({  
		marginTop : "-0.5rem"  
	},500,function(){  
		$(this).css({marginTop : "0rem"}).find("li:first").appendTo(this);  
	})  
}  
$(function(){  
setInterval('autoScroll(".wininfo")',3000);
})
</script>
</body>
</html>

