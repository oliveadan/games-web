<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="{{static_front}}/static/front/wheel/css/reset.css">
<link rel="stylesheet" href="{{static_front}}/static/front/wheel/css/style.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header">
	<div class="headercon w1000">
		<a class="logo" href='{{urlfor "WheelApiController.Get"}}'></a>
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
	<div class="w1000">
		<div class="mainwin">
			<div class="winlist">
				<div class="wininfo">
					<ul>
					{{range $i, $v := .rlList}}
						<li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span><span>获得奖品<i>{{$v.gift}}</i></span></li>
					{{end}}
					</ul>
				</div> 
			</div>
			<div class="logined">
				<span>会员 <b id="username">user</b></span>
				<span>还有<b id="draw">0</b>次机会</span>
				<a  href="javascript:;" onclick="exit()" class="qdbtn">退出</a>
			</div>
			<div class="turntablebg">
				<div class="turntable" style='background: url({{or .wheelphoto  "/static/front/wheel/images/turntable.png"}}) no-repeat;background-size: cover;-webkit-background-size: cover;-moz-background-size: cover;-o-background-size: cover;'></div>
				<div class="playbtn"><a href="javascript:;"  onClick="checklogin()" title="开始抽奖"></a></div>
			</div>
		</div>
		<div class="maincon">
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

<div class="footer">
	<div class="copyright">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div>
</div>

<div class="tclogin">
	<input type="text" value="" class="user_name" id="user_name" placeholder="输入平台会员账号">
    <input type="submit" value="登陆" class="tcsub">
</div>
<div class="tcwin">
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
            <p>会员账号：</p>  <input name="querycode" id="querycode" type="text" value="" placeholder="输入帐号"> <a href="javascript:;" onClick="queryBtn()">查 询</a>
        </div>
        <div class="cxbox_bd"  style="color:#ffe681;" >
            <table width="480" border="0" cellpadding="0" cellspacing="0">
              <tr class="ad">
                <td>中奖内容</td>
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
<script type="text/javascript" src="{{static_front}}/static/front/wheel/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.rotate.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
	if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){
		_username=localStorage.getItem("username");
		checkUser();
	}
	var isture = 0;	
	var $btn = $('.playbtn');
	var $turntable = $('.turntable');
	function rotateFunc(awards, angle, text) {	
		isture = true;
		$turntable.stopRotate();
		$turntable.rotate({
			angle: 0,
			duration: 10000,
			animateTo: angle + 1440,
			callback: function() {
				isture = false;
				$(".wintext").html(text);
				layer.open({
					type: 1, 
					zIndex: 100, 
					title: false,
					area: ['438px'],
					skin: 'layui-layer-nobg',
					shade: 0.7,
					closeBtn :true,
					shadeClose: true,
					content: $('.tcwin')
				});	
			}
		});
	};
	jQuery(".wininfo").slide({mainCell:"ul",autoPlay:true,effect:"topMarquee",vis:6,interTime:50,trigger:"click"});
</script>
</body>
</html>