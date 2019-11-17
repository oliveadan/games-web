<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="shortcut icon" href="/static/img/favicon.ico" type="image/x-icon">
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="stylesheet" href="/static/front/vote/fifa/css/style.css">
<script src="/static/front/vote/fifa/js/jquery.js" type="text/javascript"></script>
<script src="/static/front/vote/fifa/js/animateBackground-plugin.js" type="text/javascript"></script>
<script src="/static/front/vote/fifa/js/common.js" type="text/javascript"></script>
<script src="/static/front/vote/fifa/js/index.js" type="text/javascript"></script>
</head>
<body class="debbg">
<div class="">
	<div class="header">
		<div class="fl">
			<a href='{{urlfor "Fifa2018ApiController.Get"}}'>世界杯首页</a><a href="http://www.fifa.com/worldcup/" target="_blank">俄罗斯官网</a><a href='{{urlfor "Fifa2018ApiController.Teams"}}'>球队汇总</a>
		</div>
		<div class="fr">
			<a href="javascript:;" onclick="fn.showLoginPop()"></a><a class="t-green" href='{{.officialSite}}' target="_blank">{{.siteName}}首页</a>
		</div>
	</div>
	<div class="cup">
		<img src="/static/front/vote/fifa/images/cup.png" alt="">
	</div>
	<div class="mainnav_holder" style="display:none">
	</div>
	<div class="main_nav js_nav_scrollfixed">
		<ul>
			<li><a href='{{urlfor "Fifa2018ApiController.Get" "gid" .gameId}}'>世界杯首页</a></li>
			<li><a href='{{urlfor "Fifa2018ApiController.Teams" "gid" .gameId}}'>球队总汇</a></li>
			<li><a href='{{urlfor "Fifa2018ApiController.Vote" "gid" .gameId}}' style="color:red; font-size:20px; font-weight:700;">立即投票</a></li>
			<li><a href='{{.officialSite}}' target="_blank">{{.siteName}}</a></li>
			<li><a href="http://www.24zbw.com/live/zuqiu/shijiebei/" target="_blank">世界杯直播</a></li>
		</ul>
	</div>
	<div class="bg_focus js_bg_focus">
		<div class="focus_body">
			<ul class="tutu">
				<video autoplay loop id="bgvideo" style="width:100%; position:absolute; top:-50px;">
					<source src="https://www.dzlxcm.com/%E4%B8%96%E7%95%8C%E6%9D%AF/FIFA%20Rusia%202018.mp4" type="video/mp4">
				</video>
				<script>
					var video = document.getElementById("bgvideo");
					video.addEventListener('touchstart', function(e) {
						e.preventDefault();
						video.play();
					});
				</script>
			</ul>
		</div>
	</div>
	<div class="w">
		<div class="comTitle" id="comTitle">
		</div>
		<div class="datetime">
			<span class="J_date"></span>
		</div>
		<div class="wc_foot_link">
			 <div class="count">
				<div class="conitm">
					<a href='{{or .officialRegist .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon2.png" alt="" /></a>
					<a href='{{or .rechargeSite .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon1.png" alt="" /></a>
					<a href='{{or .custServ .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon3.png" alt="" /></a>
				</div>
             </div>
		</div>
	</div>
</div>
<div class=""></div>
<script>
	if(fn.countDay('2018/06/15') <= 0) {
		$("#comTitle").html("距离2018俄罗斯世界杯闭幕");
		fn.showNum(fn.countDay('2018/07/15'));
	} else {
		$("#comTitle").html("距离2018俄罗斯世界杯开幕");
		fn.showNum(fn.countDay('2018/06/15'));
	}
</script>
</body>
</html>