<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="csrf-token" content="Cxk0RGyJYkDNB8oGWPZRzvVGckKlzKGmFDy3yIc4">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/box/css/sweetalert2.min.css">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/box/css/css.css">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <audio autoplay="autoplay" controls loop>
        <!-- <source src="style/music.mp3" type="audio/mpeg"> -->
    </audio>

</head>

<body>
<div class="qdtop">
    <input type="hidden" id="gid" value="{{.gameId}}">
    <div class="qdtop_center">
        <img src="{{static_front}}/static/front/box/images/lfimg.gif" class="lfimg">
        <img src="{{static_front}}/static/img/logo.png" class="mylogo">
        <img src="{{static_front}}/static/front/box/images/rtimg.png" class="rtimg">
        <ul>
            <li><a href="{{.officialSite}}" target="_blank">官网首页</a></li>
            <li><a href="{{.officialRegist}}" target="_blank">免费注册</a></li>
            <li><a href="{{.custServ}}" target="_blank">在线客服</a></li>
            <li><a href="{{.officialPromot}}" target="_blank">优惠活动</a></li>
            <li><a href="{{.officialPartner}}" target="_blank">合作经营</a></li>
            <li><a href="{{.officialFqa}}" target="_blank">博彩责任</a></li>
            <li><a href="{{.rechargeSite}}" target="_blank">快速充值中心</a></li>
        </ul>
    </div>
</div>

<div class="qdban">
    <div class="inputout" style="display:none;">
        <a href="#" id="loginInBtn">
            <li>点击登入开宝箱</li>
        </a>
        <a href="#" id="searchInBtn" style="display: none;">
            <li class="username">会员帐号</li>
            <li class="frequency">
                <img src="{{static_front}}/static/front/box/images/bronzebox.png"/><span class="num">{{.bronzeboxNums}}</span>次
                <img src="{{static_front}}/static/front/box/images/silverbox.png"/><span class="num">{{.silverboxNums}}</span>次
                <img src="{{static_front}}/static/front/box/images/goldbox.png"/><span class="num">{{.goldboxNums}}</span>次
                <img src="{{static_front}}/static/front/box/images/extremebox.png"/><span class="num">{{.extremeboxNums}}</span>次
            </li>
            <li class="record">开宝箱纪录</li>
            <li class="signout">登出</li>
        </a>
    </div>
    <div class="time">
        <p class="hdTime"></p>
    </div>

    <div class="allboxs">
        <img src="{{static_front}}/static/front/box/images/xy.png" class="box_xy" onclick="lottery({{.bronzeboxId}})">
        <img src="{{static_front}}/static/front/box/images/by.png" class="box_by" onclick="lottery({{.silverboxId}})">
        <img src="{{static_front}}/static/front/box/images/hj.png" class="box_hj" onclick="lottery({{.goldboxId}})">
        <img src="{{static_front}}/static/front/box/images/zz.png" class="box_zz" onclick="lottery({{.extremeboxId}})">
    </div>
</div>

<div class="dqmain">
    <div class="dqmain_center">
        <img class="prize-title" src="{{static_front}}/static/front/box/images/prize.png" alt="">
        <a href="javascript:;" class="lfarr" id="goR"></a>
        <a href="javascript:;" class="rtarr" id="goL"></a>
        <div class="allstyles" id="marquee1">
            <ul>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l1.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l2.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l3.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l4.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l6.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l13.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l14.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l15.png"/></a>
                </li>
                <li>
                    <a href="#"><img width="184" height="172" src="{{static_front}}/static/front/box/images/l16.png"/></a>
                </li>
            </ul>
        </div>
        <div class="winner">
            <div class="panel">
                <div class="activity" id="list">
                    <img class="reward-title" src="{{static_front}}/static/front/box/images/reward-title.png" alt="">
                    <div id="marquee2">
                        <ul>
                        {{range $i, $v := .rlList}}
                            <li>恭喜<span>{{$v.account}}</span> 开出<span>{{$v.gift}}</span></li>
                        {{end}}
                        </ul>
                    </div>
                </div>
                <img class="reward" src="{{static_front}}/static/front/box/images/reward.png" alt="">
            </div>
        </div>
        <div id="abgne-block">
            <div class="nav actbtns clearfix">
                <ul>
                    <li>
                        <a class="btn_xq btns"></a>
                    </li>

                    <li>
                        <a class="btn_rule btns"></a>
                    </li>
                </ul>
            </div>
            <div class="content">
                <div class="tab_container">
                    <ul class="tab_content">
                        <li class="tab">
                            <div class="detail">
                                <br>
                                {{str2html .gameRule}}
                            </div>
                        </li>
                        <li class="tab" style="left: 0px; opacity: 1;">
                            <div class="gift">
                             <br>
                             {{str2html .gameStatement}}
                            </div>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>

    <div class="qdfoot">

        <a href="{{.officialPartner}}" target="_blank">代理合作</a>|
        <a href="{{.officialSite}}" target="_blank">关于我们</a>|
        <a href="{{.custServ}}" target="_blank">客服中心</a>
    </div>
</div>
<div class='barrier'>

</div>
</body>

<script src="{{static_front}}/static/front/box/js/jquery-1.4.2.min.js"></script>
<script src="{{static_front}}/static/front/box/js/jquery-3.3.1.js"></script>
<script src="{{static_front}}/static/front/box/js/Marquee.js"></script>
<script src="{{static_front}}/static/front/box/js/box.js"></script>
<script src="{{static_front}}/static/front/box/js/sweetalert2.min.js"></script>
<script src="{{static_front}}/static/front/box/js/jquery.countdown.min.js"></script>
<script src="{{static_front}}/static/front/box/js/promise.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script src="{{static_front}}/static/front/js/broadcast.js"></script>


<script type="text/javascript">
    $(function () {
        //一次横向滚动一个
        $('#marquee1').kxbdSuperMarquee({
            distance: 198,
            time: 3,
            btnGo: {
                left: '#goL',
                right: '#goR'
            },
            direction: 'left'
        });

        username2 = localStorage.getItem("username");
        if (username2 != null) {
            $('.username').text(username2);
            $('#searchInBtn').show();
            $('#loginInBtn').hide();
        } else {
            $('#loginInBtn').show();
            $('.username').text('');
            $('#searchInBtn').hide();
        }
        //活动倒计时
        var status = {{.gameStatus}};
        if (status === 3) {
            $('.inputout').css("display", "block");
            $('.time').css("display", "none");
        } else if (status === 2) {
            $('.hdTime').html("活动已结束");
        }
    });

    $.ajaxSetup({
        headers: {
            'X-CSRF-TOKEN': $('meta[name="csrf-token"]').attr('content')
        }
    });


    // countdown
    $(".hdTime").countdown({{.starttime}}).on('update.countdown', function (event) {
        //活動倒數
        var $this = $(this).html(event.strftime(
                '<p>距离活动开始</p>'
                + '<span>%D</span><b>天</b>'
                + '<span>%H</span><b>时</b>'
                + '<span>%M</span><b>分</b>'
                + '<span>%S</span><b>秒</b>'
                )
        );
    });
    $(".signout").on('click', function () {
        localStorage.removeItem("username");
    });

    $("#searchInBtn .record").on('click', function () {
        username3 = localStorage.getItem("username");
        $.ajax({
            type: 'POST',
            url: '/box/lotteryquery',
            dataType: 'json',
            data: {
                account: username3,
                gid: $("#gid").val()
            },
            success: function (res) {
                if (res.status == false) {
                    swal('', '查无相关帐号纪录', 'error');
                    return false;
                } else {
                    var html = '<table><tr><td>奖品名称</td>'
                            + '<td>中奖时间</td>'
                            + '<td>是否派彩</td>'
                            + '</tr>';
                    $.each(res.data.list, function (i, award) {
                        html += '<tr>';
                        html += '<td>' + award.gift + '</td>';
                        html += '<td>' + award.createDate + '</td>';
                        html += '<td>' + (award.delivered == 1 ? "是" : "否") + '</td>';
                        html += '</tr>';
                    });
                    html += '</table>';
                    swal({
                        width: 830,
                        html: html,
                    });
                }
            }
        });
    });


    $("#searchInBtn .signout").on('click', function () {
        var all_cookie = listCookies();
        var username = all_cookie['hb_username'];
        var date = new Date();
        date.setTime(date.getTime() - 1000);
        document.cookie = "hb_username=" + username + ";expires=" + date.toGMTString() + ";";
        $('#loginInBtn').show();
        $('#searchInBtn').hide();
    });


    $("#loginInBtn").on('click', function () {
        var all_cookie = listCookies();
        var username = all_cookie['box_username'];

        if (!username) {
            swal({
                title: {{.siteName}},
                text: '请输入会员帐号',
                input: 'text',
                showCancelButton: true,
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                showLoaderOnConfirm: true,
                allowOutsideClick: false
            }).then(function (username) {
                // data: {gid:$("#gid").val(),account: _username},
                if (!username) {
                    swal('', '请输入会员帐号', 'error');
                } else {
                    $.ajax({
                        type: 'POST',
                        url: '/login',
                        dataType: 'json',
                        data: {
                            account: username,
                            gid: $("#gid").val()
                        },
                        success: function (data) {
                            if (data.code != 1) {
                                swal('', data.msg, 'error');
                            } else {
                                localStorage.username = username;
                                var str = '';

                                var total_count = 0;
                                for (var i in data.text) {
                                    str += data.text[i].name + ':' + data.text[i].count + '<BR>';
                                    total_count += data.text[i].count;
                                }
                                swal(username, str, 'success');
                                // console.log(username);
                                setTimeout(function () {
                                    location.href = "/box";
                                }, 2000);
                            }
                        }
                    });
                }
            })
        }
    });

    function lottery(id) {
        username1 = localStorage.getItem("username");
        if (username1 != null) {
            $.ajax({
                type: 'POST',
                url: '/frontshare/lottery',
                dataType: 'json',
                data: {
                    account: username1,
                    gid: id,
                },
                success: function (data) {
                    if (data.code === 0) {
                        swal('', data.msg, 'error');
                    } else {
                        var src = data.data.photo;
                        var msg = data.msg;
                        var photo = data.data.photo;
                        if (data.code === 2) {
                            $('.barrier').css("display", "block").append('<div class="board"><div class="board-top"><img src="{{static_front}}/static/front/box/images/board-title.png"></div><div class="board-cont-type1"><p>尊敬的会员</p><span class="c1"> ' + msg + '</span></div><div class="close-btn"></div></div>');

                        } else {
                            if (src == "") {
                                //没有上传图片的情况下
                                $('.barrier').css("display", "block").append('<div class="board"><div class="board-top"><img src="{{static_front}}/static/front/box/images/board-title.png"></div><div class="board-cont-type1"><p>恭喜您获得以下礼品</p><span class="c1"> ' + data.data.gift + '</span></div><div class="close-btn"></div></div>');
                            } else {
                                $('.barrier').css("display", "block").append('<div class="board"><div class="board-top"><img src="{{static_front}}/static/front/box/images/board-title.png"></div><div class="board-cont"><p>恭喜您获得以下礼品<br>' + data.data.gift + '</p><img src="' + data.data.photo + '"></div><div class="close-btn"></div></div>');
                            }
                        }

                        setTimeout(function () {
                            $('.board').addClass('open');
                        }, 800);
                        setTimeout(function () {
                            $('.box' + "箱子名称").attr('src', "");
                        }, 2000);
                    }

                }
            });
        } else {
            swal('', '请登录后再开启宝箱', 'error');
        }
    }


    function listCookies() {
        var theCookies = document.cookie.split('; ');
        var aString = [];
        var a = '';
        for (var i = 1; i <= theCookies.length; i++) {

            a = theCookies[i - 1].split('=');

            aString[a[0]] = a[1];
        }
        return aString;
    }

    $("#iqModal").on("hidden.bs.modal", function () {
        $(".iqtable").html('');
    });
    $(".id-check").on('click', function () {
        $(".iqtable").html('');
        username = $("#id_check_username").val();
        if (!username) {
            swal('', '请输入会员帐号', 'error');
            return false;
        }
        $.ajax({
            type: 'POST',
            url: '/get_record',
            dataType: 'json',
            data: {
                username: username,
                treasure_id: '4',
            },
            success: function (res) {
                if (res.status == false) {
                    swal('', '查无相关帐号纪录', 'error');
                    return false;
                } else if (res.status == true) {
                    $(".record_content").html('');
                    var html = '<tr><td>奖品名称</td>'
                            + '<td>中奖时间</td>'
                            + '<td>是否派彩</td>'
                            + '</tr>';
                    for (i in res.data) {

                        html += '<tr>';
                        html += '<td>' + res.award[res.data[i].award_id] + (res.data[i].win > 0 ? " " + res.data[i].win + "元" : "") + '</td>';
                        html += '<td>' + res.data[i].win_time + '</td>';
                        html += '<td>' + (res.data[i].trans == 1 ? "是" : "否") + '</td>';
                        html += '</tr>';
                    }
                    $(".iqtable").html(html);
                    $("#iqModal").show();
                }
            }
        });
    });
</script>
</html>