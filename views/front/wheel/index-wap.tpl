<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes" />
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
<link rel="apple-touch-icon" href="app.png">
<script src="{{static_front}}/static/front/wheel/wap/js/respond.min.js"></script>
<link rel="stylesheet" href="{{static_front}}/static/front/wheel/css/reset.css">
<link rel="stylesheet" href="{{static_front}}/static/front/wheel/wap/css/style.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div id="page">
	<div class="headerseat"></div>
    <div class="header" id="header">
        <a href="{{urlfor "WheelApiController.Get"}}" class="logo"></a>	
        <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="search"></a>	
    </div>
    <div id="content">
        <div class="dzpmain">
            <div class="turntablebg">
                <div class="turntable" style='background: url({{or .wheelphoto "/static/front/wheel/images/turntable.png"}}) no-repeat;background-size:cover; position:absolute; left:0.37rem;  top:0.37rem;width:5.5rem; height:5.5rem;'></div>
                <a class="playbtn" href="javascript:;"  onClick="checklogin()" title="开始抽奖"></a>
            </div>
            <div class="logined">
				<span>会员<b id="username"></b></span>
				<span>还有<b id="draw">0</b>次机会</span>
				<a  href="javascript:;" onclick="exit()" class="btn">退出</a>
			</div>   
            <div class="wininfobg">
            	<div class="wininfo">
	            	<ul>
					{{range $i, $v := .rlList}}
						<li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span><span>获得奖品<i>{{$v.gift}}</i></span></li>
					{{end}}
					</ul>
				</div>
            </div> 
        </div>
    </div>
    <div class="maincon" style="">
        <div class="title">活动规则</div>
        <div class="con con1 clearfix">
		{{str2html .gameRule}}
        </div>
        <div class="con con2">
            <div class="title">活动细则</div>
            <p>
			{{str2html .gameStatement}}
            </p>
        </div>
    </div>
</div>
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
<script type="text/javascript" src="{{static_front}}/static/front/wheel/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){
    _username=localStorage.getItem("username");
    checkUser();
}
function query(){
    var _username = localStorage.getItem("username");
    if(_username ==""){
        alert("信息有误，请退出后重试!");
        return false;
    }
	$("#querycode").val(_username);
    queryBtn();
}
var isture = 0;	
var $btn = $('.playbtn');
var $turntable = $('.turntable');
function rotateFunc(awards, angle, text) {	
		isture = true;
		$turntable.stopRotate();
		$turntable.rotate({
			angle: 0,
			duration: 4000,
			animateTo: angle + 1440,
			callback: function() {
				isture = false;
				$(".wintext").html(text);
				layer.open({type: 1, zIndex: 100, title: false,area: ['5.65rem'],skin: 'layui-layer-nobg',shade: 0.7,closeBtn :true,shadeClose: true,content: $('.tcwin')});
		}
	});	
};
function autoScroll(obj){  
	$(obj).find("ul").animate({  
		marginTop : "-0.6rem"  
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