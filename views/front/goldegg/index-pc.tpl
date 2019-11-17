<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="{{static_front}}/static/front/goldegg/css/reset.css">
<link rel="stylesheet" href="{{static_front}}/static/front/goldegg/css/animate.min.css">
<link rel="stylesheet" href="{{static_front}}/static/front/css/common-pc.css" />
<link rel="stylesheet" href="{{static_front}}/static/front/goldegg/css/style.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header">
	<div class="headercon w1000">
		<a class="logo" href='{{urlfor "GoldeggApiController.Get"}}'></a>
		<div class="menu">
    			<ul>    				
    				<li><a target="_blank" href="{{.officialSite}}"><i class="i1"></i><p>官方首页</p></a></li>
    				<li><a  href="javascript:;" onClick="document.getElementById('light').style.display='block'; document.getElementById('fade').style.display='block'"><i class="i8"></i><p>中奖查询</p></a></li>
    				<li><a target="_blank" href="{{.officialRegist}}"><i class="i5"></i><p>免费注册</p></a></li>
    				<li class="last"><a target="_blank" href="{{.custServ}}"><i class="i6"></i><p>在线客服</p></a></li>
    			</ul>
		</div>
	</div>
</div>
<div class="main">
	<div class="logined"><span>会员 <b id="username">user</b></span><span>还有<b id="draw">0</b>次机会</span><a  href="javascript:;" onclick="exit()" class="qdbtn">退出</a></div>
    <div class="daojishi">
        <span class="tips" id="tips"></span>
        <span class="count-down" id="count-down"></span>
    </div>
	<div class="w1000">
		<div class="egg">
			<ul class="eggList">
				<p class="hammer" id="hammer">锤子</p>					
				<li><span></span><sup></sup></li>
				<li><span></span><sup></sup></li>
				<li><span></span><sup></sup></li>
			</ul>
			
		</div>		
		<div class="con con1">
         	   <div class="w1000">
         	   	<div class="winlist">
         	   	<ul>
					{{range $i, $v := .rlList}}
						<li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span>砸中<em>{{$v.gift}}</em></li>
					{{end}}               
			 </ul>
			 </div>
         	   </div>
         </div>
           <div class="con con2">
         	   <div class="w1000">
             	 <div class="title">活动详情</div>
                	{{str2html .gameRule}}
			</div>
          </div>
  <div class="con con3">
		<div class="w1000">
     		<div class="title">活动细则</div>
				<p>
				{{str2html .gameStatement}}
				</p>
     		</div>
           </div>
	</div>
</div>

<div class="footer"><div class="copyright">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div></div>

<div class="tclogin">
	<input type="text" value="" class="user_name" id="user_name" placeholder="请输入平台会员账号">
    <input type="submit" value="登陆" class="tcsub">
</div>
<div class="tcwin">
	<div class="picture">
	</div>
	<div class="wintext"></div>
    <button class="layui-layer-close makesure">确定</button>
</div>

<!--底部 结束-->
<div id="light" class="white_content">
	<div class="cxbox">
        <div class="cxbox_bt">
            <p>输入会员账号查询</p>  
            <a href="javascript:void(0)" style="color:#ffe681;text-decoration:none;" onClick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'" class="gban">
			X</a>
        </div>
    <div class="cxbox_hy">
            <p>会员账号：</p>  <input name="querycode" id="querycode" type="text" value="" placeholder="输入帐号"> <a href="javascript:;" onClick="queryBtn()">
			查 询</a>
        </div>
        <div class="cxbox_bd"  style="color:#ffe681;" >
            <table width="480" border="0" cellpadding="0" cellspacing="0">
              <tr class="ad">
                <td>中奖金额</td>
                <td>中奖时间</td>
                <td>是否派彩</td>
              </tr>
			  <tbody id="query_content"></tbody>
            </table>
			<div class="quotes" style="padding:10px 0px;"></div>
        </div>
    </div>
</div>
<div id="fade" class="black_overlay"></div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.SuperSlide.2.1.1.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/goldegg/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
function autoScroll(obj){  
	$(obj).find("ul").animate({  
		marginTop : "-50px"  
	},500,function(){  
		$(this).css({marginTop : "0px"}).find("li:lt(2)").appendTo(this);  
	})  
}  
$(function(){  
setInterval('autoScroll(".winlist")',3000);
})
</script>
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
				if(_state==0){
					layer.open({type: 1, zIndex: 100, title: false,area: ['438px'],skin: 'layui-layer-nobg',shade: 0.7,closeBtn :true,shadeClose: true,content: $('.tcwin')});
					isture = false;
				}
			}, 2000);

		});
}
$(".eggList li").click(function() {
	var _this = $(this);
	if(_this.parent().find("li").hasClass("curr")){
		layer.msg("已经砸过了，再来一次吧！",{icon:2,time:1800},function(){window.location.reload()});
		return false;
	}
	checklogin(_this);
});
$(".eggList li").hover(function() {
	var posL = $(this).position().left+100;
	$("#hammer").show().stop().animate({'left':posL},150);
	$("#hammer").css({'top':-65});
})
</script>
<script type="text/javascript">
    var t = {{.countDown}};
    var int;
    var gameMsg = "";
	{{if eq .gameStatus 1}}
    gameMsg = "砸金蛋即将开始";
	{{else if eq .gameStatus 2}}
    gameMsg = "本期砸金蛋已结束，敬请期待下期！";
	{{else if eq .gameStatus 3}}
    gameMsg = "砸金蛋进行中";
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