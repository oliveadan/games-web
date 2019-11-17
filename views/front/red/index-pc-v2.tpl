<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
<link href="{{static_front}}/static/front/red/v2/css/reset.css" rel="stylesheet" type="text/css" />
<link href="{{static_front}}/static/front/red/v2/css/style.css" rel="stylesheet" type="text/css" />
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header">
	<div class="headercon w1000">
		<a class="logo" href='{{urlfor "RedApiController.Get"}}'></a>
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
<div class="banner">
	<div class="bannercon w1000">
	
        <div class="qiang">
            <input type="text" name="mobilenum" id="mobilenum"  placeholder="请输入手机号码">
            <input type="text" name="commentNameField" id="username" placeholder="请输入会员账号">
			<a href="javascript:;" onClick="checkUser()" class="dianjibtn"></a>
        </div>
	</div>
</div>
<div class="maincon">
		<div class="con con1">
         	   <div class="w1000">
               <div class="title">中奖名单</div>
         	   	<div class="winlist">  
                    	<div class="gd1 bd">                    
                        <ul>
						{{range $i, $v := .rlList}}
						{{if eq $v.gift "8.8"}}
						{{else}}
							<li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">获得 <em class="fc-red">{{$v.gift}}</em></span></li>
						{{end}}
						{{end}}
						</ul>
                        </div>
                        <div class="gd2 bd bor-none">
                        <ul>
                        {{range $i, $v := .rlList1}}
						{{if eq $v.gift "8.8"}}
						{{else}}
							<li><span class="spa1">恭喜会员 <em class="fc-red">{{$v.account}}</em></span><span class="spa2">获得 <em class="fc-red">{{$v.gift}}</em></span></li>
						{{end}}
						{{end}}
						</ul>
                        </div>
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
     		<div class="title">活动规则</div>
        		{{str2html .gameStatement}}
     		</div>
           </div>
</div>

<div class="footer"><div class="copyright">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div></div>

<div id="hongbao_back" class="hide" style="display:none;"></div>
<div  id="hongbao_open" class="popup flip" style="display:none;">
  <div class="popup-t"> <a href="javascript:;" onclick="close_hongbao()" class="b1"><img src="{{static_front}}/static/front/red/v2/images/x.png"></a>
    <!--<p class="b2"><img src="{{static_front}}/static/front/red/v2/images/tu06.png"></p>
    <p class="b3">{{.siteName}}</p> -->
	 <br><br><br>
    <p class="b4">&nbsp;&nbsp;</p>
    <p class="b4">&nbsp;&nbsp;</p>
    <p class="b4">&nbsp;&nbsp;</p>
    <p class="b4">&nbsp;&nbsp;</p>
    <p class="b5" id="b5">您还有<span id="lotteryNums">0</span>次机会</p>
    <a href="javascript:;" onclick="startGame()" class="b6">拼手气</a> </div>
  <div class="popup-b">{{.siteName}}</div>
</div>
<div id="hongbao_result"  class="reward flip" style="display:none;">
  <div class="reward-t"> <a href="javascript:;" onclick="close_hongbao()" style="text-decoration:none;" class="b1"><img src="{{static_front}}/static/front/red/v2/images/x.png"></a>
    <p class="b2"><img src=""></p>
  </div>
  <div class="reward-b">
    <p class="w1">&nbsp;&nbsp;</p>
    <p class="w2"></p>
    <p class="w3">00.00<em>元</em></p>
    <p class="w4">{{.siteName}}</p>
  </div>
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
                <td>红包金额</td>
                <td>领取时间</td>
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
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.SuperSlide.2.1.1.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/red/v2/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
jQuery(".gd1").slide({mainCell:"ul",autoPlay:true,effect:"topMarquee",vis:6,interTime:40,trigger:"click"});
jQuery(".gd2").slide({mainCell:"ul",autoPlay:true,effect:"topMarquee",vis:6,interTime:40,trigger:"click"});
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