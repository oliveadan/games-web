<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="stylesheet" href="{{static_front}}/static/front/integral/v2/wap/css/bootstrap.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/integral/v2/wap/css/swiper.min.css">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/integral/v2/wap/css/index.css">
</head>

<body>
<div class="container pl-0 pr-0">
    <div class="tit row m-0">
        <input type="hidden" id="gid" value="{{.gameId}}">
        <div class="col-5 pl-0">
            <img class="titImg" src="{{static_front}}/static/img/logo240x80.png" alt="">
        </div>
        <div class="col-7 pt-0 pl-0  ml-0 text-right">
            <div class="btn-group mt-1 text-right" role="group" aria-label="...">
                <!-- <button type="button" class="userLogin btn btn-sm pr-0">会登录</button> -->
                <!-- <button type="button" class="btn btn-sm">
                    <a href="" class="text-white">在线客服</a>
                </button> -->
                <!-- 顶部折叠菜单按钮 -->
                <button id="menuBtn" type="button" class="btn btn-sm">
                    菜单
                </button>
            </div>
        </div>
    </div>
    <!-- 隐藏菜单 -->
    <div class="menu text-center p-0 mb-1">
        <a href="{{.officialSite}}" class="btn">
            官 网 首 页
        </a>
        <a href="{{.officialRegist}}" class="btn">
            免 费 注 册
        </a>
        <a href="{{.officialPromot}}" class="btn">
            优 惠 活 动
        </a>
        <a href="{{.officialPartner}}" class="btn">
            合 作 经 营
        </a>
        <a href="{{.custServ}}"
           class="btn">
            在 线 客 服
        </a>
        <a href="{{.rechargeSite}}" class="btn">
            快 速 充 值
        </a>
        <a href="#" class="btn" id="menuBtn1">
            收 起
        </a>
    </div>

    <!-- 隐藏登录框 -->
    <div class="login row pb-3">
        <div class="col-12 row login_tit m-0">
            <div class=" col-10 btn bg-warning text-left pl-4">会员登录</div>
            <div class="col-2 login_close">
                <button class="btn">关闭</button>
            </div>
        </div>
        <div class="col-12 p-0 text-center bg-light">
            <p class="bg-light"></p>
            <input id="uid" class="text-center" type="text" placeholder="请输入会员账号" autofocus></span>
        </div>
        <div class="col-12 p-0 text-center bg-light">
            <p class="login_tips bg-light"></p>
            <button class="login_btn btn btn-warning userLogin1">立 即 登 录</button>
            <button class="logout_btn btn btn-danger">退出当前账号</button>
        </div>
        <div class="col-12 pt-1 text-center bg-light">
            <span class="registTips">没有账号？<a href="{{.officialRegist}}">点我注册</a></span>
        </div>
    </div>
    <div class="black_overlay"></div>

    <!-- 轮播 -->
    <div class="swiper-container carousel text-center p-0 m-0">
        <div class="swiper-wrapper">
            <div class="swiper-slide"><img src="{{static_front}}/static/front/integral/v2/wap/img/b1.jpg" alt=""></div>
            <div class="swiper-slide"><img src="{{static_front}}/static/front/integral/v2/wap/img/b2.jpg" alt=""></div>
            <div class="swiper-slide"><img src="{{static_front}}/static/front/integral/v2/wap/img/b3.jpg" alt=""></div>
        </div>
        <!-- 如果需要分页器 -->
        <!-- <div class="swiper-pagination"></div> -->
        <!-- 如果需要导航按钮 -->
        <!-- <div class="swiper-button-prev"></div>
                    <div class="swiper-button-next"></div> -->
        <!-- 如果需要滚动条 -->
        <div class="swiper-scrollbar"></div>
    </div>
</div>

<!-- 兑换结果 -->
<div class="res_box container row p-0 m-0">
    <div class=" row m-0">
        <div class=" res_tit col-10 btn bg-warning text-left pl-4">兑换结果</div>
        <div class="col-2 login_close">
            <button class="btn res_close">
                关闭
            </button>
        </div>
    </div>
    <div class="col-12 pt-3 text-center bg-light">
        <div class="res_success text-success">
            恭喜你！兑换成功，
            <p class="mb-0">
                请耐心等待工作人员派奖！
            </p>
        </div>
        <p class="res_err text-danger mb-0">
            对不起，兑换失败，您的积分不足！
        </p>
    </div>
    <div class="col-12 pt-3 text-center bg-light">
        <button class="btn btn-danger res_close">确定关闭</button>
    </div>
</div>
<div class="black_overlay1"></div>
<!-- 会员信息 -->
<div class="container">
    <div class="pt-2 please text-center">
        <a href="#" class="btn btn-warning userLogin userLogin2 mr-3">会员登录</a>
        <a href="{{urlfor "IntegralApiController.Explain"}}" class="jfsm">
            积分说明
        </a>
    </div>
    <div class="user_grade">
        <div class="uname text-left">您好，
            <span class="uid text-primary"></span>
            <a href="" class="logout_btn1 ml-2 text-danger">退出</a>
        </div>
        <div class="user_jf row">
            <div class="col-5">
                积分:
                <span id="fen" class="grade text-danger font-weight-bold"></span>
            </div>
            <div class="col-7 text-right">
                <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="jilu ">兑换记录</a>
                <a href="{{urlfor "IntegralApiController.Explain"}}">
                    积分说明
                </a>
            </div>
        </div>
    </div>
</div>
<!-- 礼品列表 -->
<div class="cont container p-0 pt-3">
    <div class=" m-0 text-left pl-lg-5 ">
        <div class="pr-0 ">
            <div class="list text-left pl-2 text-left mt-2 pr-2">
                <ul class="list-unstyled">
                    {{range $i, $v := .giftList}}
                        <li class="media xianjin pt-3 pb-3">
                            <div class="media-left">
                                <img class="media-object" src="{{$v.Photo}}" alt="...">
                            </div>
                            <div class="media-body pl-2">
                                <h5 class="media-heading">{{$v.Content}}
                                    {{if eq 1 $v.BroadcastFlag}}
                                        <img src="{{static_front}}/static/front/integral/v2/wap/img/new.gif" alt="新增">
                                    {{else if eq 2 $v.BroadcastFlag}}
                                        <img src="{{static_front}}/static/front/integral/v2/wap/img/hot.gif" alt="热销">
                                    {{else if eq 3 $v.BroadcastFlag}}
                                        <img src="{{static_front}}/static/front/integral/v2/wap/img/xl.gif" alt="限量">
                                    {{else if eq 4 $v.BroadcastFlag}}
                                        <img src="{{static_front}}/static/front/integral/v2/wap/img/th.gif" alt="特惠">
                                    {{end}}
                                </h5>
                                <span class="text-danger">{{$v.Seq}}</span> 积分
                            </div>
                            <div class="media-right">
                                <button onclick="excharge({{$v.Id}},{{$v.Seq}})" class="btn btn-sm btn-success">立即兑换
                                </button>
                            </div>
                        </li>
                    {{end}}
                </ul>
            </div>
        </div>
    </div>
</div>
<!-- 底部 -->
<div class="text-center pt-3 border-top border-success">
    <p class=" text-success">©2009-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p>
</div>
</body>
<script src="{{static_front}}/static/front/integral/v2/wap/js/jquery-3.3.1.min.js"></script>
<script src="{{static_front}}/static/front/integral/v2/wap/js/popper.min.js"></script>
<script src="{{static_front}}/static/front/integral/v2/wap/js/bootstrap.js"></script>
<script src="{{static_front}}/static/front/integral/v2/wap/js/swiper.min.js"></script>
<script src="{{static_front}}/static/front/integral/v2/wap/js/index.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
</html>