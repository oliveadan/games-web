<!DOCTYPE html>
<html lang="zh-CN">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="Cache-Control" content="no-cache" />
    <meta content="telephone=no" name="format-detection" />
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=2.0" />
    <meta name="viewport"
        content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="#">
    <link rel="apple-touch-icon-precomposed" sizes="57x57" href="#">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link href="{{static_front}}/static/front/wish/css/index.css" rel="stylesheet" type="text/css">
    <link href="{{static_front}}/static/front/wish/css/csshake.min.css" rel="stylesheet" type="text/css">
    <link href="{{static_front}}/static/front/wish/css/timeTo.css" rel="stylesheet" type="text/css">
    <link href="{{static_front}}/static/front/wish/css/global.css" rel="stylesheet" type="text/css">
    <link href="{{static_front}}/static/front/wish/css/jquery.mCustomScrollbar.css" rel="stylesheet" type="text/css">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/png">
</head>

<body>
    <div class="content">
        <input type="hidden" id="gameId" value="{{.gameId}}" />
        <div class="pis"></div>

        <section class="panel Christmas" data-section-name="Christmas">
            <div class="Christmas-Content relative">
                <div class="bg">
                    <div class="top">　　
                        <a class="topA" href="javascript:Util.showCeng('.WishingMoreList');">
                        <img class="iconVip" src="{{static_front}}/static/front/wish/images/77vip.png">许愿榜</a>
                    </div>

                    <div class="WishingText">
                        <img src="{{static_front}}/static/front/wish/images/77text.png">
                    </div>
                    <div class="WishingStar">
                        <img src="{{static_front}}/static/front/wish/images/77star.png">
                        <!--{{.wishList}}-->
                    </div>
                    <div class="WishingBtn">
                        <a href="javascript:Util.showCeng('.Wishing-ceng');">
                            <img src="{{static_front}}/static/front/wish/images/77btn2.png" onmousedown="old=this.src;this.src='{{static_front}}/static/front/wish/images/77btn1.png';" onmouseup="this.src=old;">
                        </a>
                    </div>
                    <div class="btmtxt">
                        <a class="txtf" href="javascript:;">
                            —— 永利集团祝贺您七夕节快乐 ——
                        </a><br>
                        <a href="javascript:;">
                            星语心愿【公司祝福】&nbsp;
                        </a>
                        <a href="javascript:Util.showCeng('.WishingRule');">
                            活动规则&nbsp;
                        </a>
                        <a href="https://ca88.chatazure.com/chat/Hotline/channel.jsp?cid=5009397&cnfid=7845&j=1665910878&lan=zh&s=1">
                            |&nbsp;在线客服
                        </a>
                    </div>
                </div>

                <div class="Wishing-ceng">
                    <input type="hidden" id="gameId" value="{{.gameId}}" />
                    <a href="javascript:Util.hideCeng('.Wishing-ceng');" class="Wishing-ceng-close">
                        <img src="{{static_front}}/static/front/wish/images/77close.png"></a>
                    <input name="username" class="Wishing-ceng-input" id="username" type="text" placeholder="请填写会员账号"
                        datatype="*1-26" nullmsg="请填写会员账号" errormsg="请填写1-26位用户名" value="" />
                    <input name="mobile" class="Wishing-ceng-input1" id="mobile" type="text" placeholder="非会员请填写您的手机号"
                        datatype="*1-16" nullmsg="请填写您的手机号" errormsg="请填写11位您的手机号" value="" />
                    <textarea name="WishingTextarea" class="Wishing-ceng-template" placeholder="请填写您的愿望"></textarea>
                    <a href="javascript:Util.WishingSm();" class="Wishing-ceng-btn">
                        <img src="{{static_front}}/static/front/wish/images/77heart.png"></a>
                </div>

                <div class="WishingRule">
                    <div class="dtls1">
                        <a class="ruleclose" href="javascript:Util.hideCeng('.WishingRule');" class="Wishing-ceng-close">
                        <img src="{{static_front}}/static/front/wish/images/77close.png"></a>
                  {{str2html .gameRule}}
                    </div>
                </div>
            </div>
            <div class="WishingMoreList">
                <input type="hidden" name="WishingPage" value="1">
                <div class="loginHeadStyle">
                    <div class="shoppingcartBg">许愿榜</div>
                    <div class="shoppingcartClose">
                        <a href="javascript:Util.hideCeng('.WishingMoreList');">
                            <img src="{{static_front}}/static/front/wish/images/77close.png"></a>
                    </div>
                </div>
                <div class="shopListContent mCustomScrollbar _mCS_5 mCS_no_scrollbar" id="content-2">
                    <div id="mCSB_5" class="mCustomScrollBox mCS-light mCSB_vertical mCSB_inside" tabindex="0">
                        <div id="mCSB_5_container" class="mCSB_container mCS_y_hidden mCS_no_scrollbar_y"
                            style="position:relative; top:0px; left:0;" dir="ltr">
                            <table style="width:100%;text-align:center;" class="shopListContent" border="0"
                                cellpadding="0" cellspacing="0">
                                <tbody>
                                    <tr class="shoppingcartTr WishingMoreListAppend">
                                        <td class="td1">用户</td>
                                        <td class="td2" width="197.5px">愿望</td>
                                        <td class="td3">热度</td>
                                        <td class="td4">点赞</td>
                                    </tr>
                                    <tr>
                                        <td class="blue" colspan="4">
                                            <a href="javascript:Util.WishingPageList();"
                                                class="WishingPageList WishingPageListMore">查看更多</a></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div id="mCSB_5_scrollbar_vertical"
                            class="mCSB_scrollTools mCSB_5_scrollbar mCS-light mCSB_scrollTools_vertical"
                            style="display: none;">
                            <div class="mCSB_draggerContainer">
                                <div id="mCSB_5_dragger_vertical" class="mCSB_dragger"
                                    style="position: absolute; min-height: 30px; top: 0px;"
                                    oncontextmenu="return false;">
                                    <div class="mCSB_dragger_bar" style="line-height: 30px;"></div>
                                </div>
                                <div class="mCSB_draggerRail"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
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
                                        <img src="#" id="xiangziImg"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <input type="hidden" id="http" value="{{static_front}}">
    <script src="{{static_front}}/static/front/wish/js/jquery.js"></script>
    <script type="text/javascript">
        $(document).ajaxStart(function () {
            $("button:submit").addClass("log-in").attr("disabled", true);
        }).ajaxStop(function () {
            $("button:submit").removeClass("log-in").attr("disabled", false);
        });

        $("form").submit(function () {
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

        $(function () {
            var verifyimg = $(".verifyimg").attr("src");
            $(".reloadverify").click(function () {
                if (verifyimg.indexOf('?') > 0) {
                    $(".verifyimg").attr("src", verifyimg + '&random=' + Math.random());
                } else {
                    $(".verifyimg").attr("src", verifyimg.replace(/\?.*$/, '') + '?' + Math.random());
                }
            });
        });
    </script>
    <script src="{{static_front}}/static/front/wish/js/jquery.easing.1.3.js"></script>
    <script src="{{static_front}}/static/front/wish/js/jquery.timeTo.js"></script>
    <script src="{{static_front}}/static/front/wish/js/Util.js"></script>
    <script src="{{static_front}}/static/front/wish/js/jquery.mCustomScrollbar.concat.min.js"></script>
</body>
</html>