<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link href="{{static_front}}/static/front/integral/v2/css/base.css" rel="stylesheet" type="text/css">
    <link href="{{static_front}}/static/front/integral/v2/css/swiper.min.css" rel="stylesheet" >
    <link href="{{static_front}}/static/front/integral/v2/css/style.css" rel="stylesheet" type="text/css">
    <link href="{{static_front}}/static/front/integral/v2/css/anim.css" rel="stylesheet" type="text/css">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <script src="{{static_front}}/static/front/js/jquery.min.js"></script>
    <script src="{{static_front}}/static/front/integral/v2/js/swiper.min.js"></script>
    <script src="{{static_front}}/static/front/integral/v2/js/common.min.js"></script>
    <script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
    <script type="text/javascript" src="{{static_front}}/static/front/integral/v2/js/index.js"></script>
</head>
<body>
<div class="banner js-goto1-offset">
    <input type="hidden" id="gid" value="{{.gameId}}">
    <div class="header">
        <div class="header_box">
            <div class="nav">
                <a href="{{.officialSite}}" target="_blank">网站首页</a>
            {{if .rechargeSite}}<a href="{{.rechargeSite}}" target="_blank">快速充值中心</a>{{end}}
            {{if .officialPartner}}<a href="{{.officialPartner}}" target="_blank">合作经营</a>{{end}}
            {{if .officialRegist}}<a href="{{.officialRegist}}" target="_blank">免费注册</a>{{end}}
            {{if .officialPromot}}<a href="{{.officialPromot}}" target="_blank">活动优惠</a>{{end}}
                <a href="{{.custServ}}" target="_blank">在线客服</a>
                <a href="javascript:;" onclick="listDiv()">兑换记录</a>
            </div>
            <div class="login">
                <a href="javascript:;" id="login_li" onclick="logDiv()" name="login"><img src="{{static_front}}/static/front/integral/v2/images/login_btn.png"></a>
                <div id="islogin" style="display:none;line-height:28px;font-size:13px;">
                    <span style="color:#f4eda1;"><b id="user"></b></span>
                    <span style="color:#f4eda1;margin-left:10px;">积分：<b id="draw">0</b></span>
                    <a href="javascript:;" style="margin-left:10px;color:#fff;" onclick="exit()" class="qdbtn">退出</a>
                </div>
            </div>
        </div>
    </div>
    <!-- Swiper -->
    <div class="swiper-container swiper-container-horizontal">
        <img src="{{static_front}}/static/front/integral/v2/images/hh.png" class="imgwb">
        <div class="swiper-wrapper" style="transform: translate3d(-5679px, 0px, 0px); transition-duration: 300ms;">
            <div class="swiper-slide swiper-slide-duplicate" data-swiper-slide-index="2" style="width: 1863px; margin-right: 30px;"><div style="background:url({{static_front}}/static/front/integral/v2/images/banner_3.jpg) no-repeat center center; width:100%; height:550px;"></div></div>
            <div class="swiper-slide" data-swiper-slide-index="0" style="width: 1863px; margin-right: 30px;"><div style="background:url({{static_front}}/static/front/integral/v2/images/banner_1.jpg) no-repeat center center; width:100%; height:550px;"></div></div>
            <div class="swiper-slide swiper-slide-prev" data-swiper-slide-index="1" style="width: 1863px; margin-right: 30px;"><div style="background:url({{static_front}}/static/front/integral/v2/images/banner_2.jpg) no-repeat center center; width:100%; height:550px;"></div></div>
            <div class="swiper-slide swiper-slide-active" data-swiper-slide-index="2" style="width: 1863px; margin-right: 30px;"><div style="background:url({{static_front}}/static/front/integral/v2/images/banner_3.jpg) no-repeat center center; width:100%; height:550px;"></div></div>
            <div class="swiper-slide swiper-slide-duplicate" data-swiper-slide-index="0" style="width: 1863px; margin-right: 30px;"><div style="background:url({{static_front}}/static/front/integral/v2/images/banner_1.jpg) no-repeat center center; width:100%; height:550px;"></div></div>
        </div>
        <!-- Add Pagination -->
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
    </div>
    <div class="ban_botm"></div>
</div>
<div class="cent">
    <div class="box">
        <div class="tab_btn">
            <span><img src="{{static_front}}/static/front/integral/v2/images/ben.png"></span>
            <a href="javascript:;" onclick="ShowIntegral()"  class="btn_1" name="login">
                <img src="{{static_front}}/static/front/integral/v2/images/btn_1.png">
            </a>
            <a href="javascript:;" class="btn_2 btn-getflow">
                <img src="{{static_front}}/static/front/integral/v2/images/btn_2.png">
            </a>
        </div>
        <div class="content">
            <div class="top_text">
                会员在{{.siteName}}进行存款，每一笔存款金额都将永久累计，并转换为积分，只要您有积分，即可任意选择您要兑换的商品，积分越多，可兑换的商品也越多，掌握时代的节奏，赶快邀请您的好友加入{{.siteName}}抱回超级大奖！
            </div>
            <div class="lt js-goto2-offset">
                <div class="title"><img src="{{static_front}}/static/front/integral/v2/images/c_1.png"></div>
                <p>{{.announcement}}</p>
            </div>
            <div class="yt js-goto3-offset">
                <div class="title"><img src="{{static_front}}/static/front/integral/v2/images/c_2.png"></div>
                <p><span>兑换之前，建议您先行查询现有的会员积分数，再选择要您要兑换的现金券。</span>
                    <a href="javascript:;" onclick="listDiv()" name="login">查看兑换记录 &gt;&gt;</a></p>
            </div>
            <div class="list">
                <ul>
                {{range $i, $v := .giftList}}
                    <li >
                        <div class="pic" style="background: url({{$v.Photo}}) no-repeat;">
                            <div class="pu_1" style="font-size:30px;">{{$v.Name}}</div>
                            <div class="pu_2">{{$v.Content}}</div>
                            <div class="pu_3">{{$v.Seq}} 积分</div>
                        </div>
                        <div class="pu_btn">
                            <a href="javascript:;" onclick="change({{$v.Id}})" name="login">
                                <img src="{{static_front}}/static/front/integral/v2/images/btn_4.png"></a>
                        </div>
                    </li>
                {{end}}
                </ul>
            </div>
            <div class="yt">
                <div class="title"><img src="{{static_front}}/static/front/integral/v2/images/c_3.png"></div>
                <p><span>北京时间每周五为会员积分兑换日，当天24小时以内（00:00~23:59）均可进行兑换，所有现金券可重复兑换。</span></p>
            </div>
        </div>
        <div class="details_box de-flow">
            <div class="details_top"><a href="javascript:;">-点击收起活动流程</a></div>
            <div class="details">
                <div class="img_1"><img src="{{static_front}}/static/front/integral/v2/images/img_1.png"></div>
                <div class="de_cc"><a href="{{or .rechargeSite .custServ}}" target="_blank"><img src="{{static_front}}/static/front/integral/v2/images/btn_6.png"></a><p>还没有积分？存款可获积分换取现金券</p></div>
                <div class="img_2"><img src="{{static_front}}/static/front/integral/v2/images/img_2.png"></div>
            </div>
        </div>
        <div class="xz js-goto4-offset">
            <div class="top"><img src="{{static_front}}/static/front/integral/v2/images/bcn.png"></div>
            <div class="text_box">
            {{str2html .gameRule}}
            </div>
        </div>
    </div>
    <div class="footer">© {{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div>
</div>
<div class="pf">
    <div class="pf_box">
        <a href="" class="js-goto1">首页</a>
        <a href="javascript:;" class="js-goto2">积分说明</a>
        <a href="javascript:;" class="js-goto3">积分兑换</a>
        <a href="javascript:;" class="js-goto4">活动细则</a>
        <a href="{{.custServ}}" target="_blank">在线客服</a>
        <a href="javascript:;" target="_self" class="js-gototop cur"><img src="{{static_front}}/static/front/integral/v2/images/pf_img.png"></a>
    </div>
</div>
<!--登录弹窗-->

<div id="dialogBox" class="tc_box" style="display: none; top: 0px;">
    <div class="tc_top"><i>会员登录</i><span class="none"></span></div>
    <div class="tc_cent">
        <div class="tc_text">
            <i><img src="{{static_front}}/static/front/integral/v2/images/icon_1.png"></i>
            <input type="text" class="text" id="username" name="username"  placeholder="请输入登录账号">
        </div>
        <div class="tc_text">
            <i><img src="{{static_front}}/static/front/integral/v2/images/icon_2.png"></i>
            <input type="text" class="text_cc" id="verycode" name="captcha" placeholder="请输入验证码">
        {{create_captcha}}
        </div>
        <div class="tc_tt">
            <a href="{{.officialRegist}}" target="_blank">注册</a>
        </div>
        <div class="tc_btn">
            <input class="btn" id="login-btn"type="button" value="立即登录">
        </div>
    </div>
</div>

<div id="listBox" style="display:none;">
    <div class="dialog-box dialog-box3">
        <div class="title">
            <h3>兑换记录</h3>
            <a href="javascript:;" class="btn-close">&nbsp;</a>
        </div>
        <div class="tebaelbxin">
            <table border="1"cellpadding="1" cellspacing="1" class="dp-gift-record-box js-show">

            </table>
            <div class="quotes" style="padding:5px 5px;"></div>
        </div>
    </div>
    <div class="dialog-mask">
    </div>
</div>
<div class="dialog" style="display: none;"></div>
<script src="{{static_front}}/static/front/integral/v2/js/banner.js"></script>
<script>
    $(function(){
        $(".none").click(function(){
            $(".dialog").hide();
            $(".tc_box").hide().animate({"top":"0px"});
        })

        $(".btn-close").click(function(){
            $('.dialog-mask').hide();
            $(this).parents('.dialog-box').hide();
        })

        $('.js-goto1').click(function () {
            util.gotoTop({
                el: '.js-goto1-offset',
                time: 500
            });
        });
        $('.js-goto2').click(function () {
            util.gotoTop({
                el: '.js-goto2-offset',
                time: 500
            });
        });
        $('.js-goto3').click(function () {
            util.gotoTop({
                el: '.js-goto3-offset',
                time: 500
            });
        });
        $('.js-goto4').click(function () {
            util.gotoTop({
                el: '.js-goto4-offset',
                time: 500
            });
        });
        $('.js-goto8').click(function () {
            util.gotoTop({
                el: '.js-goto8-offset',
                time: 500
            });
        });
        $('.js-gototop').on('click', function () {
            util.gotoTop();
        });

        // 活动流程
        $('.btn-getflow').click(function () {
            util.gotoTop({
                el: '.de-flow',
                time: 500
            });
        });

        $(".details_top a").click(function(){
            if($(this).hasClass("o")){
                $(this).text("-点击收起活动流程");
                $(this).removeClass("o");
                $(".details").slideDown();
            }else{
                $(this).text("-点击展开活动流程");
                $(this).addClass("o");
                $(".details").slideUp();
            }
        })
    })
</script>
</body>
</html>