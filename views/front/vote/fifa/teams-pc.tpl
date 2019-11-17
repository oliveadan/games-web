<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="/static/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="/static/front/vote/fifa/css/style.css">
<script src="/static/front/vote/fifa/js/jquery.js" type="text/javascript"></script>
<script src="/static/front/vote/fifa/js/index.js" type="text/javascript"></script>
</head>
<body>
<div class="header">
	<div class="fl">
		<a href='{{urlfor "FifaApiController.Get"}}'>世界杯首页</a><a href="http://www.fifa.com/worldcup/" target="_blank">俄罗斯官网</a><a href='{{urlfor "FifaApiController.Teams"}}'>球队汇总</a>
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
			<li><a href='{{urlfor "FifaApiController.Get" "gid" .gameId}}'>世界杯首页</a></li>
		<li><a href='{{urlfor "FifaApiController.Teams" "gid" .gameId}}'>球队总汇</a></li>
		<li><a href='{{urlfor "FifaApiController.Vote" "gid" .gameId}}' style="color:red; font-size:20px; font-weight:700;">立即投票</a></li>
		<li><a href='{{.officialSite}}' target="_blank">{{.siteName}}</a></li>
		<li><a href="http://www.24zbw.com/live/zuqiu/shijiebei/" target="_blank">世界杯直播</a></li>
	</ul>
</div>
<div class="bg_focus js_bg_focus">
	<div class="focus_body">
		<ul class="tutu"> 
			<li class="bg_1 current"></li>
			<li class="bg_2"></li>
			<li class="bg_3"></li>
		</ul>
	</div>
</div>


<div class="container">
     <div class="Field_num">
           <div class="main_bg">
             <link rel="stylesheet" rev="stylesheet" href="/static/front/vote/fifa/css/comm.css" type="text/css" />
             <!-- tab切换开始-->
             <script>
                $(document).ready(function() {
                    $('#wrapper_tab a').click(function() {
                        if ($(this).attr('class') != $('#wrapper_tab').attr('class') ) {
                            $('#wrapper_tab').attr('class',$(this).attr('class'));
                        }
                        return false;
                    });
                });
             </script>
             <div class="detail_box clearfix">
                <div id="wrapper_tab" class="tab1 tab_link">
	<div class="tab_tit">
		<a href="javascript:void(0)" class="tab1 tab_link">按组排列</a>
		<a href="javascript:void(0)" class="tab2 tab_link">按大洲排列</a>
		<a href="javascript:void(0)" class="tab3 tab_link">按挡位排列</a>
	</div>
	<style>
					.clearfix li img{
						width:140px;height:90px
					}
	</style>
	<div class="tab1 tab_body">
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>A</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/5a1682bbae85c.png" style="">
					<p>
						俄罗斯
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df9b6adee1.jpg" style="">
					<p>
						埃及
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c54956212f.jpg" style="">
					<p>
						乌拉圭
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/5978bba7c9345.jpg" style="">
					<p>
						沙特阿拉伯
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>B</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/594d0b5a3d338.jpg" style="">
					<p>
						西班牙
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b4754972.jpg" style="">
					<p>
						葡萄牙
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd31395824.jpg" style="">
					<p>
						摩洛哥
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df94da824b.jpg" style="">
					<p>
						伊朗
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>C</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/59a81f391b343.jpg" style="">
					<p>
						丹麦
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5684a65c3.jpg" style="">
					<p>
						秘鲁
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df8f82d760.jpg" style="">
					<p>
						澳大利亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0ae6bbf30.jpg" style="">
					<p>
						法国
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>D</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/595cd355b0e3b.jpg" style="">
					<p>
						尼日利亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a912b40d3c6.jpg" style="">
					<p>
						冰岛
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d08f5a1ad9.jpg" style="">
					<p>
						阿根廷
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a91c7e97216.jpg" style="">
					<p>
						克罗地亚
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>E</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/59a919dd629a9.jpg" style="">
					<p>
						塞尔维亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a90f9ce1137.jpg" style="">
					<p>
						哥斯达黎加
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b3539d61.jpg" style="">
					<p>
						巴西
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5435493d2.jpg" style="">
					<p>
						瑞士
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>F</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/594d09d68b393.jpg" style="">
					<p>
						德国
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c51b34364e.jpg" style="">
					<p>
						瑞典
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b0412874.jpg" style="">
					<p>
						墨西哥
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df93cc5bbc.jpg" style="">
					<p>
						韩国
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>G</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/59a820b268bae.jpg" style="">
					<p>
						英格兰
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd3fbaec14.jpg" style="">
					<p>
						突尼斯
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c512fcf801.jpg" style="">
					<p>
						比利时
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a911be0b6e2.jpg" style="">
					<p>
						巴拿马
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_yel">
				<strong>H</strong>组
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/594d0bd737295.jpg" style="">
					<p>
						日本
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5482dc806.jpg" style="">
					<p>
						哥伦比亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd3ce1c8a5.jpg" style="">
					<p>
						塞内加尔
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a81f72ac1ae.jpg" style="">
					<p>
						波兰
					</p>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- .tab1 .tab_body -->
	<div class="tab2 tab_body">
		<div class="row clearfix">
			<div class="fl sort_green">
				<strong>南美区</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/599c5684a65c3.jpg" style="">
					<p>
						秘鲁
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b3539d61.jpg" style="">
					<p>
						巴西
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d08f5a1ad9.jpg" style="">
					<p>
						阿根廷
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5482dc806.jpg" style="">
					<p>
						哥伦比亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c54956212f.jpg" style="">
					<p>
						乌拉圭
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_green">
				<strong>亚洲区</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/597df8f82d760.jpg" style="">
					<p>
						澳大利亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0bd737295.jpg" style="">
					<p>
						日本
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df93cc5bbc.jpg" style="">
					<p>
						韩国
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/5978bba7c9345.jpg" style="">
					<p>
						沙特阿拉伯
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df94da824b.jpg" style="">
					<p>
						伊朗
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_green" style="line-height:30px;">
				<strong style="margin:5px 12px;display:inline-block">中北美及加勒比海</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/59a90f9ce1137.jpg" style="">
					<p>
						哥斯达黎加
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b0412874.jpg" style="">
					<p>
						墨西哥
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a911be0b6e2.jpg" style="">
					<p>
						巴拿马
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_green">
				<strong>非洲区</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/595cd355b0e3b.jpg" style="">
					<p>
						尼日利亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd31395824.jpg" style="">
					<p>
						摩洛哥
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd3fbaec14.jpg" style="">
					<p>
						突尼斯
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df9b6adee1.jpg" style="">
					<p>
						埃及
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd3ce1c8a5.jpg" style="">
					<p>
						塞内加尔
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_green">
				<strong>欧洲区</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/5a1682bbae85c.png" style="">
					<p>
						俄罗斯
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a919dd629a9.jpg" style="">
					<p>
						塞尔维亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b5a3d338.jpg" style="">
					<p>
						西班牙
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a81f391b343.jpg" style="">
					<p>
						丹麦
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d09d68b393.jpg" style="">
					<p>
						德国
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a912b40d3c6.jpg" style="">
					<p>
						冰岛
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5435493d2.jpg" style="">
					<p>
						瑞士
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c51b34364e.jpg" style="">
					<p>
						瑞典
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a820b268bae.jpg" style="">
					<p>
						英格兰
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b4754972.jpg" style="">
					<p>
						葡萄牙
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c512fcf801.jpg" style="">
					<p>
						比利时
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a81f72ac1ae.jpg" style="">
					<p>
						波兰
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0ae6bbf30.jpg" style="">
					<p>
						法国
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a91c7e97216.jpg" style="">
					<p>
						克罗地亚
					</p>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- .tab2 .tab_body -->
	<div class="tab3 tab_body">
		<div class="row clearfix">
			<div class="fl sort_green">
				<strong>第一档位</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/5a1682bbae85c.png" style="">
					<p>
						俄罗斯
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d09d68b393.jpg" style="">
					<p>
						德国
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b3539d61.jpg" style="">
					<p>
						巴西
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b4754972.jpg" style="">
					<p>
						葡萄牙
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d08f5a1ad9.jpg" style="">
					<p>
						阿根廷
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c512fcf801.jpg" style="">
					<p>
						比利时
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a81f72ac1ae.jpg" style="">
					<p>
						波兰
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0ae6bbf30.jpg" style="">
					<p>
						法国
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_green" style="line-height:30px;">
				<strong style="margin:5px 12px;display:inline-block">第二档位</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/594d0b5a3d338.jpg" style="">
					<p>
						西班牙
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5684a65c3.jpg" style="">
					<p>
						秘鲁
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5435493d2.jpg" style="">
					<p>
						瑞士
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a820b268bae.jpg" style="">
					<p>
						英格兰
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c5482dc806.jpg" style="">
					<p>
						哥伦比亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0b0412874.jpg" style="">
					<p>
						墨西哥
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c54956212f.jpg" style="">
					<p>
						乌拉圭
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a91c7e97216.jpg" style="">
					<p>
						克罗地亚
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_green">
				<strong>第三档位</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/59a81f391b343.jpg" style="">
					<p>
						丹麦
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a90f9ce1137.jpg" style="">
					<p>
						哥斯达黎加
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a912b40d3c6.jpg" style="">
					<p>
						冰岛
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/599c51b34364e.jpg" style="">
					<p>
						瑞典
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd3fbaec14.jpg" style="">
					<p>
						突尼斯
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df9b6adee1.jpg" style="">
					<p>
						埃及
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd3ce1c8a5.jpg" style="">
					<p>
						塞内加尔
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df94da824b.jpg" style="">
					<p>
						伊朗
					</p>
					</li>
				</ul>
			</div>
		</div>
		<div class="row clearfix">
			<div class="fl sort_green">
				<strong>第四档位</strong>
			</div>
			<div class="fr each">
				<ul class="clearfix">
					<li><img src="/static/front/vote/fifa/images/59a919dd629a9.jpg" style="">
					<p>
						塞尔维亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd355b0e3b.jpg" style="">
					<p>
						尼日利亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df8f82d760.jpg" style="">
					<p>
						澳大利亚
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/594d0bd737295.jpg" style="">
					<p>
						日本
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/595cd31395824.jpg" style="">
					<p>
						摩洛哥
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/59a911be0b6e2.jpg" style="">
					<p>
						巴拿马
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/597df93cc5bbc.jpg" style="">
					<p>
						韩国
					</p>
					</li>
					<li><img src="/static/front/vote/fifa/images/5978bba7c9345.jpg" style="">
					<p>
						沙特阿拉伯
					</p>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<!-- .tab3 .tab_body -->
	<div class="clear">
	</div>
</div><!-- #wrapper_tab -->
    
             </div>
             <!--切换结束-->
             <div class="count">
				<div class="conitm">
					<a href='{{or .officialRegist .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon2.png" alt="" /></a>
					<a href='{{or .rechargeSite .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon1.png" alt="" /></a>
					<a href='{{or .custServ .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon3.png" alt="" /></a>
				</div>
             </div>
             <!--统计结束-->
           </div>
     </div>
     
   </div>

<style>
.bianhua{margin-top:-48px!important}
</style>

<div class="J_mask">
</div>
</body>
</html>