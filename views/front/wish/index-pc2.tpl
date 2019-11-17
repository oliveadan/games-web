<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link href="/static/front/wish/css/index.css" rel="stylesheet" type="text/css">
    <link href="/static/front/wish/css/csshake.min.css" rel="stylesheet" type="text/css">
    <link href="/static/front/wish/css/timeTo.css" rel="stylesheet" type="text/css">
    <link href="/static/front/wish/css/global.css" rel="stylesheet" type="text/css">
    <link href="/static/front/wish/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css">
	<link rel="shortcut icon" href="/static/img/favicon.ico" type="image/png">
</head>
  <body>
    <div class="pis"></div>
    <section class="panel header" data-section-name="header">
      <div class="headFixdClick">
        <div class="topHeadLogin" style="position: fixed;">
          <div class="fnameCenter">
			{{if .announcement}}
			<div class="ico-wrap">
				<img src="/static/front/wish/images/laba.png" width="18px" height="18px">
			</div>
			<div style="float:left;" id="wrap">
	            <div class="wrapIn">
					<div>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</div>
	                <div id="text1">{{.announcement}}</div>
	                <div id="text2"></div>
	            </div>
	        </div>
			{{end}}
            <div class="left">
              <span class="right">　　
                <a href="{{.officialSite}}" target="_blank">{{.siteName}}娱乐场</a> | 
                <a href="javascript:Util.showCeng('.EventDescription');">活动说明</a> | 
            	<a href="{{.custServ}}" target="_blank">在线客服</a>　
				</span>
            </div>
          </div>
        </div>
      </div>
    </section>
    <section class="panel Christmas" data-section-name="Christmas">
      <div class="Christmas-Content relative">
        <div class="snowflakeList">
          <img src="/static/front/wish/images/xh_03.png" style="left: 0px; top: -70px; animation: xuehua 12s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 30px; top: -285px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 60px; top: -436px; animation: xuehua 4s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 90px; top: -484px; animation: xuehua 7s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 120px; top: -309px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 150px; top: -269px; animation: xuehua 10s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 180px; top: -28px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 210px; top: -185px; animation: xuehua 4s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 240px; top: -186px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 270px; top: -459px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 300px; top: -136px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 330px; top: -174px; animation: xuehua 7s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 360px; top: -351px; animation: xuehua 12s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 390px; top: -300px; animation: xuehua 4s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 420px; top: -29px; animation: xuehua 4s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 450px; top: -259px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 480px; top: -320px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 510px; top: -354px; animation: xuehua 7s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 540px; top: -368px; animation: xuehua 10s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 570px; top: -184px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 600px; top: -66px; animation: xuehua 11s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 630px; top: -327px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 660px; top: -389px; animation: xuehua 3s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 690px; top: -228px; animation: xuehua 3s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 720px; top: -10px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 750px; top: -445px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 780px; top: -310px; animation: xuehua 11s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 810px; top: -338px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 840px; top: -222px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 870px; top: -401px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 900px; top: -480px; animation: xuehua 10s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 930px; top: -338px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 960px; top: -357px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 990px; top: -235px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1020px; top: -447px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1050px; top: -377px; animation: xuehua 12s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 1080px; top: -144px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 1110px; top: -184px; animation: xuehua 12s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1140px; top: -475px; animation: xuehua 11s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1170px; top: -332px; animation: xuehua 4s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 1200px; top: -411px; animation: xuehua 11s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 1230px; top: -192px; animation: xuehua 4s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1260px; top: -369px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1290px; top: -313px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 1320px; top: -280px; animation: xuehua 3s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 1350px; top: -359px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1380px; top: -153px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1410px; top: -249px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 1440px; top: -406px; animation: xuehua 12s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 1470px; top: -395px; animation: xuehua 7s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1500px; top: -51px; animation: xuehua 11s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1530px; top: -423px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 1560px; top: -104px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 1590px; top: -415px; animation: xuehua 4s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1620px; top: -381px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1650px; top: -113px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 1680px; top: -490px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 1710px; top: -67px; animation: xuehua 8s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1740px; top: -42px; animation: xuehua 9s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1770px; top: -25px; animation: xuehua 10s infinite;">
          <img src="/static/front/wish/images/xh_03.png" style="left: 1800px; top: -301px; animation: xuehua 6s infinite;">
          <img src="/static/front/wish/images/xh_07.png" style="left: 1830px; top: -73px; animation: xuehua 12s infinite;">
          <img src="/static/front/wish/images/xh_09.png" style="left: 1860px; top: -436px; animation: xuehua 5s infinite;">
          <img src="/static/front/wish/images/xh_13.png" style="left: 1890px; top: -6px; animation: xuehua 9s infinite;"></div>
        <div class="Christmas-bg-0"></div>
        <div class="Christmas-bg-1"></div>
        <div class="Christmas-ContentCenter">
          <div class="Christmas-Head">
            <img src="/static/front/wish/images/hb_06.png" class="Christmas-Head-title">
            <div class="Christmas-Head-center">
              <div class="Christmas-Head-center-pis">{{.siteName}}祝您家人幸福快乐！许愿祝好运！</div>
              <div class="Christmas-Head-center-time">
                <div class="Christmas-Head-center-timeText">活动倒计时:</div>
                <div id="countdown">
                  <span class="bai">{{.gameMsg}}</span></div>
                <div class="clear"></div>
              </div>
            </div>
            <!--<a href="javascript:Util.redDraw();" class="Christmas-Head-center-btn">
              <img src="/static/front/wish/images/hb_03.png"></a>-->
          </div>
          {{/*<div class="Christmas-gift-pis">
            <img src="/static/front/wish/images/pis-inco_03.png" class="leftImgInco">
            <img src="/static/front/wish/images/pis-inco_03.png" class="rightImgInco">许愿抽大奖
            <br>更有礼金188元，礼包388元</div>*/}}
          <div class="Christmas-inco-style">
            <img src="/static/front/wish/images/pic-2-inco_07.png"></div>
          <div class="Christmas-anctinty">
            <img src="/static/front/wish/images/hover1.png" style="display: none;"></div>
         {{/*  <div class="giftList">
            <a href="javascript:Util.ChristmasGift();" title="恭喜发财" class="giftList-img-1 shake shake-rotate shake-constant">
              <img src="/static/front/wish/images/liwu_03.png"></a>
            <a href="javascript:Util.ChristmasGift();" title="恭喜发财" class="giftList-img-2 shake shake-rotate shake-constant">
              <img src="/static/front/wish/images/liwu_06.png"></a>
            <a href="javascript:Util.ChristmasGift();" title="恭喜发财" class="giftList-img-3 shake shake-rotate shake-constant">
              <img src="/static/front/wish/images/liwu_10.png"></a>
            <a href="javascript:Util.ChristmasGift();" title="恭喜发财" class="giftList-img-4 shake shake-rotate shake-constant">
              <img src="/static/front/wish/images/liwu_14.png"></a>
          </div>*/}}
          <div class="Wishing relative">
            <ul>
				{{range $index, $vo := .wishList}}
				<li class="WishingList-{{$index}} shake">
                	<span><img src="/static/img/logo.png"></span>
                	<h5>{{$vo.Account}}</h5>
                	<p>{{$vo.Content}}</p>
					{{if lt $index 5}}
                	<img src="/static/front/wish/images/inco-sdw.png" class="WishingList-incoRight">
					{{else}}
                	<img src="/static/front/wish/images/inco-sdw1.png" class="WishingList-incoLeft">
					{{end}}
                	<a href="javascript:Util.ThumbsUp({{$vo.Id}});" id="zan-{{$vo.Id}}" title="赞一下" class="WishingList-zan">{{$vo.Thumbs}}</a>
				</li>
				{{end}}
            </ul>
          </div>
          <div class="WishingBtn">
            <a href="javascript:Util.showCeng('.Wishing-ceng');" class="shake" title="我要许愿">
              <img src="/static/front/wish/images/Wishing_03.png"></a>
          </div>
          <div class="WishingMore">
            <a href="javascript:Util.showCeng('.WishingMoreList');">查看全部愿望</a></div>
        </div>
        <div class="Wishing-ceng">
			<input type="hidden" id="gameId" value="{{.gameId}}" />
          <a href="javascript:Util.hideCeng('.Wishing-ceng');" class="Wishing-ceng-close">
            <img src="/static/front/wish/images/xy_06.png"></a>
          <input name="username" class="Wishing-ceng-input" id="username"
			type="text" placeholder="会员请填写会员账号" datatype="*1-26" nullmsg="会员请填写会员账号" 
			errormsg="请填写1-26位用户名" value="" />
          <input name="mobile" class="Wishing-ceng-input1" id="mobile" type="text" placeholder="非会员请填写您的手机号" datatype="*1-16" nullmsg="请填写您的手机号" errormsg="请填写11位您的手机号" value=""/>
			<textarea name="WishingTextarea" class="Wishing-ceng-template" placeholder="每位会员都可以送出你的祝福话语和说出你想申请的优惠，每天随机满足50名会员的愿望。"></textarea>
          <a href="javascript:Util.WishingSm();" class="Wishing-ceng-btn">
            <img src="/static/front/wish/images/xy_10.png"></a>
        </div>
      </div>
      <div class="WishingMoreList">
        <input type="hidden" name="WishingPage" value="1">
        <div class="loginHeadStyle">
          <div class="shoppingcartBg">全部愿望</div>
          <div class="shoppingcartClose">
            <a href="javascript:Util.hideCeng('.WishingMoreList');">
              <img src="/static/front/wish/images/xy_06.png"></a>
          </div>
        </div>
        <div class="shopListContent mCustomScrollbar _mCS_5 mCS_no_scrollbar" id="content-2">
          <div id="mCSB_5" class="mCustomScrollBox mCS-light mCSB_vertical mCSB_inside" tabindex="0">
            <div id="mCSB_5_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y" style="position:relative; top:0px; left:0;" dir="ltr">
              <table style="width:100%;text-align:center;" class="shopListContent" border="0" cellpadding="0" cellspacing="0">
                <tbody>
                  	<tr class="shoppingcartTr WishingMoreListAppend">
	                    <td>用户</td>
	                    <td width="400">愿望</td>
	                    <td>热度</td>
	                    <td>点赞</td>
					</tr>
                  <tr>
                    <td class="blue" colspan="4">
                      <a href="javascript:Util.WishingPageList();" class="WishingPageList WishingPageListMore">查看更多</a></td>
                  </tr>
                </tbody>
              </table>
            </div>
            <div id="mCSB_5_scrollbar_vertical" class="mCSB_scrollTools mCSB_5_scrollbar mCS-light mCSB_scrollTools_vertical" style="display: none;">
              <div class="mCSB_draggerContainer">
                <div id="mCSB_5_dragger_vertical" class="mCSB_dragger" style="position: absolute; min-height: 30px; top: 0px;" oncontextmenu="return false;">
                  <div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
                </div>
                <div class="mCSB_draggerRail"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <div class="bottomPisText" style="display: block;margin-bottom: 50px;"></div>
    <div class="wrapper" onclick="Util.hideCeng('.wrapper')">
      <div class="bg rotate"></div>
      <div class="open-has ">
        <div class="mod-chest">
          <div class="chest-close show ">
            <div class="gift"></div>
          </div>
          <div class="chest-open ">
            <div class="mod-chest-cont open-cont">
              <div class="content">
                <h3 class="title-open"></h3>
                <div class="gift">
                  <div class="icon">
                    <img src="" id="xiangziImg"></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <section class="panel footer" data-section-name="footer">
      <div class="footerContent">
        <div class="fnameCenter">
			<div class="fnameCenter"> 
				<a href="{{.officialSite}}">关于{{.siteName}}</a> 
				{{if .officialRegist}}| <a href="{{.officialRegist}}">开户与存提款</a>{{end}}
 				{{if .officialPartner}}| <a href="{{.officialPartner}}">合作经营条款与规则</a>{{end}}
 				{{if .officialPromot}}| <a href="{{.officialPromot}}">优惠活动规则</a>{{end}}
  				{{if .officialFqa}}| <a href="{{.officialFqa}}">博彩责任</a>{{end}}
          <p>本网站属于{{.siteName}}授权和监管，所有版权归{{.siteName}}，违者必究。
            <br>©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p></div>
      </div>
      </div>
    </section>

    <div class="bgCeng" onclick="Util.hideCeng('bgCeng')"></div>
    <div class="EventDescription">
      <a href="javascript:Util.hideCeng('.EventDescription');" class="EventDescriptionClose">
        <img src="/static/front/wish/images/xy_06.png"></a>
      <h3>{{.siteName}}活动规则及条款</h3>
      <div id="content-3" class="h422">
        {{str2html .gameRule}}
      </div>
    </div>
    <script data-cfasync="false" src="/static/front/wish/js/email-decode.min.js"></script>
    <script src="/static/front/wish/js/jquery.js"></script>
    <script type="text/javascript">
		$(document).ajaxStart(function() {
        	$("button:submit").addClass("log-in").attr("disabled", true);
	    }).ajaxStop(function() {
	        $("button:submit").removeClass("log-in").attr("disabled", false);
	    });

      $("form").submit(function() {
        var self = $(this);
        $.post(self.attr("action"), self.serialize(), success, "json");
        return false;

        function success(data) {
          if (data.status) {
            window.location.href = data.url;
          } else {
            self.find(".Validform_checktip").text(data.info);
            //刷新验证码
            $(".reloadverify").click();
          }
        }
      });

      $(function() {
        var verifyimg = $(".verifyimg").attr("src");
        $(".reloadverify").click(function() {
          if (verifyimg.indexOf('?') > 0) {
            $(".verifyimg").attr("src", verifyimg + '&random=' + Math.random());
          } else {
            $(".verifyimg").attr("src", verifyimg.replace(/\?.*$/, '') + '?' + Math.random());
          }
        });
      });
	{{if .announcement}}
		var wrap = document.getElementById("wrap");
        var text1 = document.getElementById("text1");
        var text2 = document.getElementById("text2");
        text2.innerHTML = document.getElementById("text1").innerHTML;

        setInterval(function() {
            if (wrap.scrollLeft - text2.offsetWidth >= 0) {
                wrap.scrollLeft -= text1.offsetWidth;
            } else {
                wrap.scrollLeft++;
            }
        }, 25);
	{{end}}
	</script>
    <script src="/static/front/wish/js/jquery.easing.1.3.js"></script>
    <script src="/static/front/wish/js/jquery.timeTo.js"></script>
    <script src="/static/front/wish/js/Util.js"></script>
    <script src="/static/front/wish/js/jquery.mCustomScrollbar.concat.min.js"></script>
  </body>

</html>