<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="stylesheet" href="{{static_front}}/static/front/box/wap/css/bootstrap.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/box/wap/css/treasureBox.css">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
</head>

<body>
<div class="container">
    <div class="title row justify-content-end pt-2 pl-2 mb-2">
        <input type="hidden" id="gid" value="{{.gameId}}">
        <div class="col-2 text-center">
        </div>
        <div class="col-8  text-center">
            <img src="{{static_front}}/static/img/logo240x80.png" alt="">
        </div>
        <div class="col-2 mt-3">
            <!-- 顶部折叠菜单按钮 -->
            <button id="menuBtn" type="button" class="btn" aria-label="Left Align">
                <svg id="%E5%88%97%E8%A1%A8%20alt" width="16" height="16" style="width:28px;height:25px;" version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" enable-background="new 0 0 1024 1024" xml:space="preserve"><path fill="#666" d="M219.43 603.43 l0 36.57 q0 7.84 -5.23 12.19 q-5.22 6.1 -13.06 6.1 l-36.57 0 q-7.84 0 -12.19 -6.1 q-6.09 -4.35 -6.09 -12.19 l0 -36.57 q0 -7.84 6.09 -13.06 q4.35 -5.23 12.19 -5.23 l36.57 0 q7.84 0 13.06 5.23 q5.23 5.22 5.23 13.06 l0 0 ZM219.43 457.14 l0 36.57 q0 7.84 -5.23 12.19 q-5.22 6.1 -13.06 6.1 l-36.57 0 q-7.84 0 -12.19 -6.1 q-6.09 -4.35 -6.09 -12.19 l0 -36.57 q0 -7.83 6.09 -13.06 q4.35 -5.22 12.19 -5.22 l36.57 0 q7.84 0 13.06 5.22 q5.23 5.23 5.23 13.06 l0 0 ZM219.43 310.86 l0 36.57 q0 7.84 -5.23 12.19 q-5.22 6.09 -13.06 6.09 l-36.57 0 q-7.84 0 -12.19 -6.09 q-6.09 -4.35 -6.09 -12.19 l0 -36.57 q0 -7.84 6.09 -13.06 q4.35 -5.23 12.19 -5.23 l36.57 0 q7.84 0 13.06 5.23 q5.23 5.22 5.23 13.06 l0 0 ZM877.71 603.43 l0 36.57 q0 7.84 -5.22 12.19 q-5.22 6.1 -13.06 6.1 l-548.57 0 q-7.84 0 -12.19 -6.1 q-6.1 -4.35 -6.1 -12.19 l0 -36.57 q0 -7.84 6.1 -13.06 q4.35 -5.23 12.19 -5.23 l548.57 0 q7.84 0 13.06 5.23 q5.22 5.22 5.22 13.06 l0 0 ZM877.71 457.14 l0 36.57 q0 7.84 -5.22 12.19 q-5.22 6.1 -13.06 6.1 l-548.57 0 q-7.84 0 -12.19 -6.1 q-6.1 -4.35 -6.1 -12.19 l0 -36.57 q0 -7.83 6.1 -13.06 q4.35 -5.22 12.19 -5.22 l548.57 0 q7.84 0 13.06 5.22 q5.22 5.23 5.22 13.06 l0 0 ZM877.71 310.86 l0 36.57 q0 7.84 -5.22 12.19 q-5.22 6.09 -13.06 6.09 l-548.57 0 q-7.84 0 -12.19 -6.09 q-6.1 -4.35 -6.1 -12.19 l0 -36.57 q0 -7.84 6.1 -13.06 q4.35 -5.23 12.19 -5.23 l548.57 0 q7.84 0 13.06 5.23 q5.22 5.22 5.22 13.06 l0 0 ZM950.86 713.14 l0 -475.43 q0 -7.83 -5.23 -13.06 q-5.22 -5.22 -13.06 -5.22 l-841.14 0 q-7.84 0 -12.19 5.22 q-6.1 5.23 -6.1 13.06 l0 475.43 q0 7.84 6.1 12.19 q4.35 6.1 12.19 6.1 l841.14 0 q7.84 0 13.06 -6.1 q5.23 -4.35 5.23 -12.19 l0 0 ZM1024 91.43 l0 621.71 q0 37.45 -26.99 64.44 q-27 26.99 -64.44 26.99 l-841.14 0 q-37.44 0 -64.44 -26.99 q-26.99 -26.99 -26.99 -64.44 l0 -621.71 q0 -37.44 26.99 -64.44 q27 -26.99 64.44 -26.99 l841.14 0 q37.44 0 64.44 26.99 q26.99 27 26.99 64.44 l0 0 Z"/></svg>
            </button>
        </div>
    </div>
    <!-- 隐藏菜单栏 -->
    <div class="menu list-group text-center" id="menu">
        <a href="{{.officialSite}}" class="list-group-item p-2">官 网 首 页</a>
        <a href="{{.officialRegist}}" class="list-group-item p-2">免 费 注 册</a>
        <a href="{{.custServ}}" class="list-group-item p-2">在 线 客 服</a>
        <a href="{{.officialPromot}}" class="list-group-item p-2">优 惠 活 动</a>
        <a href="#" class="list-group-item btn" id="menuBtn1">
            收起
            <span class="glyphicon glyphicon-triangle-top" aria-hidden="true"></span>
        </a>
    </div>

    <div class="boxs">
        <div class=" pt-5 pb-2"></div>
        <div class=" pt-5 pb-2"></div>
        <div class=" pt-5"></div>
        <div class=" mb-3">
            <div class="input-group text-center" id="userInput">
                <input id="uname" type="text" class="form-control text-center border-0 font-weight-bold "
                       placeholder="请输入账号">
                <span class="input-group-btn">
                        <button id="sub" class="btn btn-warning btn font-weight-bold" type="button"> 登 录 </button>
                    </span>
            </div>
            <!-- 登录后用户的钥匙信息 -->
            <div class="text-center" id="res">
                <div class="pt-1">您好, <span class="text-warning font-weight-bold" id="logname">123123</span>
                    <div class="btn-group ml-3" role="group" aria-label="...">
                        <button id="logOut" type="button" class="btn btn-sm btn-warning  text-danger" onclick="exit()">
                            退出
                        </button>
                        <button id="listBtn" type="button" class="btn btn-sm btn-warning">中奖记录</button>
                    </div>
                </div>
                <hr class="m-0">
                <div class="row keysImg m-0 font-weight-bold">
                    <div class="col-3 p-0">
                        <p class="text-info mb-0">幸运</p>
                        <img src="{{static_front}}/static/front/box/wap/img/xykey.png" alt="">
                        x
                        <span class="font-weight-bold">{{.bronzeboxNums}}</span>
                    </div>
                    <div class="col-3 p-0">
                        <p class="text-light m-0">白银</p>
                        <img src="{{static_front}}/static/front/box/wap/img/bykey.png" alt="">
                        x
                        <span class="font-weight-bold">{{.silverboxNums}}</span>
                    </div>
                    <div class="col-3 p-0">
                        <p class="text-warning m-0">黄金</p>
                        <img src="{{static_front}}/static/front/box/wap/img/hjkey.png" alt="">
                        x
                        <span class="font-weight-bold">{{.goldboxNums}}</span>
                    </div>
                    <div class="col-3 p-0">
                        <p class="m-0 text-danger">至尊</p>
                        <img src="{{static_front}}/static/front/box/wap/img/zzkey.png" alt="">
                        x
                        <span class="font-weight-bold">{{.extremeboxNums}}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- 4个宝箱 -->
        <div id="4box">
            <!-- 前两个宝箱 -->
            <div class="row">
                <div class="col-1"></div>
                <div class="col-5 p-0 m-0">
                    <div class="text-center">
                        <img id="myModal" class="" src="{{static_front}}/static/front/box/wap/img/xy.png" alt="幸运宝箱"
                             onclick="lottery({{.bronzeboxId}})">
                        <div class="tx text-center pr-2"></div>
                    </div>
                    <div class="p-0 text-">
                        <div class="boxName text-center">幸运宝箱</div>
                    </div>
                </div>
                <div class="col-5 p-0 m-0 ">
                    <div class="text-center">
                        <img src="{{static_front}}/static/front/box/wap/img/by.png" alt="白银宝箱"
                             onclick="lottery({{.silverboxId}})">
                        <div class="tx text-center pr-2"></div>
                    </div>
                    <div class="p-0 text-">
                        <div class="boxName text-center">白银宝箱</div>
                    </div>
                </div>
                <div class="col-1"></div>
            </div>
            <div class="pt-3"></div>

            <!-- 后两个宝箱 -->
            <div class="row">
                <div class="col-1"></div>
                <div class="col-5 p-0 m-0 ">
                    <div class="text-center">
                        <img src="{{static_front}}/static/front/box/wap/img/hj.png" alt="黄金宝箱"
                             onclick="lottery({{.goldboxId}})">
                        <div class="tx text-center pr-2"></div>
                    </div>
                    <div class="p-0 text-">
                        <div class="boxName text-center">黄金宝箱</div>
                    </div>
                </div>
                <div class="col-5 p-0 m-0 ">
                    <div class="text-center">
                        <img src="{{static_front}}/static/front/box/wap/img/zz.png" alt="至尊宝箱"
                             onclick="lottery({{.extremeboxId}})">
                        <div class="tx text-center pr-2"></div>
                    </div>
                    <div class="p-0 text-">
                        <div class="boxName text-center">至尊宝箱</div>
                    </div>
                </div>
                <div class="col-1"></div>
            </div>

            <div class="pt-5 text-center pb-5" id="dialogs1">
                <div class="mt-2 pt-5"></div>
                <div class="jImg mt-5 text-center">
                    <img id="gift" class="mt-5 border-0" src="{{static_front}}/static/front/box/wap/img/wzj.png" alt="">
                </div>
                <div class="pt-2"></div>
                <div id="msg" class="text-center">
                    <div></div>
                    <span id="gift1" class="text-red"></span>
                </div>
                <div class="pt-5"></div>
                <div>
                    <span id="close" class="glyphicon glyphicon-remove-circle" aria-hidden="true"></span>
                </div>
            </div>
        </div>
        <!-- 中奖名单 -->
        <div class="tit mt-3">
            <div class="text-center pb-1">
                <div class="text-warning font-weight-bold font-italic">中 奖 名 单</div>
                <img class="border-0" src="{{static_front}}/static/front/box/wap/img/标题11.png" alt="">
            </div>
            <div id="scrollBox" class="mt-5 text-center">
                <ul id="con1" class=" p-0 m-0">
                    {{range $i, $v := .rlList}}
                        <li>
                            恭喜：<span class="text-danger">{{$v.account}} </span>开启宝箱获得<span
                                    class="text-danger font-weight-bold">
                                {{$v.gift}}</span>
                        </li>
                        <li>
                        </li>
                    {{end}}
                </ul>
                <ul id="con2" class=" p-0 m-0">
                </ul>
            </div>
        </div>
        <div class="tit1 mt-3">
            <div class="text-center pb-1">
                <div class="text-warning font-weight-bold font-italic">活 动 规 则</div>
                <img class="border-0" src="{{static_front}}/static/front/box/wap/img/标题11.png" alt="">
            </div>
            <div id="scrollBox1" class="mt-5 p-3">
                {{str2html .gameRule}}
            </div>
        </div>
    </div>
    <div class="foot text-center mt-5 pt-2 border-top border-warning">
        <img src="{{static_front}}/static/img/logo240x80.png" alt="">
        <p class="text-secondary">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p>
    </div>
    <!-- 中奖记录 -->
    <div class="list text-center">
        <div class="" id="dialogs">
            <div class="text-center font-weight-bold">
                <table class="table">
                    <thead class="text-danger">
                    <td>奖品名称</td>
                    <td>中奖时间</td>
                    <td>是否派奖</td>
                    </thead>
                    <tbody id="reward" class="text-dark">

                    </tbody>
                </table>
            </div>
        </div>
        <div id="listClose" class="bg-white text-danger font-weight-bold pt-2 pb-2">
            关 闭
        </div>
    </div>
    <!-- 中奖记录-->
</div>
<script src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script src="{{static_front}}/static/front/box/wap/js/popper.min.js"></script>
<script src="{{static_front}}/static/front/box/wap/js/bootstrap.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<!-- 登陆---------------开箱-------------------退出 ------------------------------------------- -->
<script>
    var _username = "";
    if (localStorage.getItem("username") && localStorage.getItem("username") != "null") {
        _username = localStorage.getItem("username");
        checkUser();
    }

    function checkUser() {
        $.ajax({
            url: '{{urlfor "DoorController.Login"}}',
            dataType: 'json',
            cache: false,
            type: 'POST',
            data: {gid: $("#gid").val(), account: _username},
            success: function (obj) {
                switch (obj.code) {
                    case 0:
                        localStorage.clear();
                        layer.msg(obj.msg);
                        break;
                    case 1:
                        $("#logname").text(_username);
                        $("#userInput").css("display", "none");
                        $("#res").css("display", "block");
                        break;
                    default:
                        break;
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var x = 1;
                localStorage.clear();
            }
        })
    }
</script>
<script>
    $("#sub").on("click", function () {
        if ($("#uname").val()) {
            $.ajax({
                type: 'POST',
                url: '/login',
                dataType: 'json',
                data: {
                    account: $("#uname").val(),
                    gid: $("#gid").val(),
                },
                success: function (data) {
                    if (data.code != 1) {
                        layer.msg(data.msg);
                    } else {
                        localStorage.username = $("#uname").val();
                        $("#logname").text($("#uname").val());
                        $("#userInput").css("display", "none");
                        $("#res").css("display", "block");
                        window.location.reload();
                    }
                }
            });
        } else {
            $("#sub").text("账号不能为空！~~");
            $("#sub").css("color", "red");
            setTimeout(() => {
                $("#sub").text("登 录");
                $("#sub").css("color", "#fff");
            }, 1000);
            clearTimeout(1000);
        }
    });

    //抽奖
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
                        layer.msg(data.msg);
                    } else {
                        var src = data.data.photo;
                        var msg = data.msg;
                        if (data.code === 2) {
                            $("#gift").attr("src", "{{static_front}}/static/front/box/wap/img/wzj.png");
                            $("#gift1").text(data.msg);
                            $("#dialogs1").css("display", "block");
                        } else {
                            if (src === "") {
                                $("#gift").attr("src", "{{static_front}}/static/front/box/wap/img/zhong.png");
                                $("#gift1").text(data.data.gift);
                            } else {
                                $("#gift").attr("src", src);
                                $("#gift1").text(data.data.gift);
                            }
                            $("#dialogs1").css("display", "block");
                        }

                    }

                }
            });
        } else {
            layer.msg("请登录后再开启宝箱！~")
        }
    }
    $("#close").on("click", function () {
        $("#dialogs1").css("display", "none");
        window.location.reload();
    });
    $("#logOut").on("click", function () {
        location.reload();
    })
</script>
<!-- 中奖名单----------------------------------------------------------------------------- -->
<script type="text/javascript">
    var area = document.getElementById('scrollBox');
    con2.innerHTML = con1.innerHTML;

    function scrollUp() {
        if (area.scrollTop >= con1.offsetHeight) {
            area.scrollTop = 0;
        } else {
            area.scrollTop++
        }
    }

    var time = 60;
    var mytimer = setInterval(scrollUp, time);
    area.onmouseover = function () {
        clearInterval(mytimer);
    };
    area.onmouseout = function () {
        mytimer = setInterval(scrollUp, time);
    }
</script>
<!-- 菜单---------------------------------------------------------------------------- -->
<script>
    var open = 1;
    $("#menuBtn").on("click", function () {
        if (open) {
            $("#menu").css("display", "block");
            open = 0;
        } else {
            $("#menu").css("display", "none");
            open = 1;
        }
    })
    $("#menuBtn1").on("click", function () {
        if (open) {
            $("#menu").css("display", "block");
            open = 0;
        } else {
            $("#menu").css("display", "none");
            open = 1;
        }
    })
</script>
<!--退出 -->
<script type="text/javascript">
    function exit() {
        $.ajax({
            url: '/logout',
            dataType: 'json',
            cache: false,
            type: 'GET',
            success: function (obj) {
                localStorage.clear();
                window.location.reload();
            },
        })
    }
</script>
<script>
    // 记录
    $("#listBtn").on("click", function () {
        var name = localStorage.getItem("username");
        var id   =$("#gid").val();
        console.log(name,id);
        $.ajax({
            type: 'POST',
            url: '/box/lotteryquery',
            dataType: 'json',
            data: {
                account: name,
                gid: id
            },
            success: function (res) {
                console.log(res);
                if (res.code === 0) {
                    layer.msg(res.msg);
                    return false;
                } else {
                      var html = '';
                      $.each(res.data.list, function (i, award) {
                          html += '<tr>';
                          html += '<td>' + award.gift + '</td>';
                          html += '<td>' + award.createDate + '</td>';
                          html += '<td>' + (award.delivered == 1 ? "是" : "否") + '</td>';
                          html += '</tr>';
                      });
                      $("#reward").html(html);
                    $(".list").css("display", "block");
                }
            }
        });
    });
    $("#listClose").on("click", function () {
        $(".list").css("display", "none")
    })
</script>
</body>
</html>