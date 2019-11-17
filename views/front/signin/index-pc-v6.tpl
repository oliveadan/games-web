<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v6/css/bootstrap.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v6/css/sign.css">
</head>

<body>
<div class="container">
    <div class="title row p-2 justify-content-between mb-4">
        <div class="col-4 font-weight-bold"></div>
        <div class="col-4 text-right text-white font-weight-bold">
            <a href="{{urlfor "DoorController.Query" "gid" .gameId}}">
                <svg id="%E5%88%97%E8%A1%A8%20alt" width="16" height="16" style="width:28px;height:25px;" version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024" enable-background="new 0 0 1024 1024" xml:space="preserve"><path fill="#666" d="M219.43 603.43 l0 36.57 q0 7.84 -5.23 12.19 q-5.22 6.1 -13.06 6.1 l-36.57 0 q-7.84 0 -12.19 -6.1 q-6.09 -4.35 -6.09 -12.19 l0 -36.57 q0 -7.84 6.09 -13.06 q4.35 -5.23 12.19 -5.23 l36.57 0 q7.84 0 13.06 5.23 q5.23 5.22 5.23 13.06 l0 0 ZM219.43 457.14 l0 36.57 q0 7.84 -5.23 12.19 q-5.22 6.1 -13.06 6.1 l-36.57 0 q-7.84 0 -12.19 -6.1 q-6.09 -4.35 -6.09 -12.19 l0 -36.57 q0 -7.83 6.09 -13.06 q4.35 -5.22 12.19 -5.22 l36.57 0 q7.84 0 13.06 5.22 q5.23 5.23 5.23 13.06 l0 0 ZM219.43 310.86 l0 36.57 q0 7.84 -5.23 12.19 q-5.22 6.09 -13.06 6.09 l-36.57 0 q-7.84 0 -12.19 -6.09 q-6.09 -4.35 -6.09 -12.19 l0 -36.57 q0 -7.84 6.09 -13.06 q4.35 -5.23 12.19 -5.23 l36.57 0 q7.84 0 13.06 5.23 q5.23 5.22 5.23 13.06 l0 0 ZM877.71 603.43 l0 36.57 q0 7.84 -5.22 12.19 q-5.22 6.1 -13.06 6.1 l-548.57 0 q-7.84 0 -12.19 -6.1 q-6.1 -4.35 -6.1 -12.19 l0 -36.57 q0 -7.84 6.1 -13.06 q4.35 -5.23 12.19 -5.23 l548.57 0 q7.84 0 13.06 5.23 q5.22 5.22 5.22 13.06 l0 0 ZM877.71 457.14 l0 36.57 q0 7.84 -5.22 12.19 q-5.22 6.1 -13.06 6.1 l-548.57 0 q-7.84 0 -12.19 -6.1 q-6.1 -4.35 -6.1 -12.19 l0 -36.57 q0 -7.83 6.1 -13.06 q4.35 -5.22 12.19 -5.22 l548.57 0 q7.84 0 13.06 5.22 q5.22 5.23 5.22 13.06 l0 0 ZM877.71 310.86 l0 36.57 q0 7.84 -5.22 12.19 q-5.22 6.09 -13.06 6.09 l-548.57 0 q-7.84 0 -12.19 -6.09 q-6.1 -4.35 -6.1 -12.19 l0 -36.57 q0 -7.84 6.1 -13.06 q4.35 -5.23 12.19 -5.23 l548.57 0 q7.84 0 13.06 5.23 q5.22 5.22 5.22 13.06 l0 0 ZM950.86 713.14 l0 -475.43 q0 -7.83 -5.23 -13.06 q-5.22 -5.22 -13.06 -5.22 l-841.14 0 q-7.84 0 -12.19 5.22 q-6.1 5.23 -6.1 13.06 l0 475.43 q0 7.84 6.1 12.19 q4.35 6.1 12.19 6.1 l841.14 0 q7.84 0 13.06 -6.1 q5.23 -4.35 5.23 -12.19 l0 0 ZM1024 91.43 l0 621.71 q0 37.45 -26.99 64.44 q-27 26.99 -64.44 26.99 l-841.14 0 q-37.44 0 -64.44 -26.99 q-26.99 -26.99 -26.99 -64.44 l0 -621.71 q0 -37.44 26.99 -64.44 q27 -26.99 64.44 -26.99 l841.14 0 q37.44 0 64.44 26.99 q26.99 27 26.99 64.44 l0 0 Z"/></svg>
            </a>
        </div>
        <div class="col-12 text-center">
            <div class="col-4"></div>
            <div class="mt-5 col-12" id="userInput">
                <div class="input-group">
                    <input type="hidden" id="gid" value="{{.gameId}}">
                    <input id="uname" type="text" class="form-control" placeholder="请输入账号">
                    <span class="input-group-btn">
                            <button id="sub" class="btn btn-warning btn-lg" type="button">签到</button>
                        </span>
                </div>
            </div>
            <div class="pt-4 text-center" id="res">
                <div class="pt-5">恭喜您获得</div>
                <div class="money">
                    <span class="glyphicon glyphicon-yen" aria-hidden="true" id="gift"></span>
                </div>
                <div id="conf" class="btn btn-warning text-light">确 定</div>
            </div>
            <a class="col-4 text-center btn" id="signBtn">签到</a>
            <div class="col-4"></div>
        </div>
    </div>
    <div class="row justify-content-center">
        <div class="bor mt-4"></div>
        <a class="btn1 float-left">签到规则</a>
        <div class="bor mt-4"></div>
    </div>
    <div class="mt-4">
        <div class="roleBox mb-4 ml-3 row justify-content-around">
            <div class="roleNum ">
                01
            </div>
            <div class="roleText">
                北京时间每天可签到一次
            </div>
        </div>
        <div class="roleBox mb-4 ml-3 row justify-content-around">
            <div class="roleNum ">
                02
            </div>
            <div class="roleText">
                最低VIP1才可以获得奖励
            </div>
        </div>
        <div class="roleBox mb-4 ml-3 row justify-content-around">
            <div class="roleNum ">
                03
            </div>
            <div class="roleText" style="line-height: 30px">
                VIP等级按照前一天达到<br>的最高等级计算
            </div>
        </div>
    </div>
    <div class="text-center mt-5">
        <a href="http://yl8553.vip" class="btn1 goVIP">去VIP等级中心 >></a>
    </div>
</div>
</div>
<script src="{{static_front}}/static/front/signin/v6/js/jquery-3.3.1.min.js"></script>
<script src="{{static_front}}/static/front/signin/v6/js/popper.min.js"></script>
<script src="{{static_front}}/static/front/signin/v6/js/bootstrap.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script>
    var res = 1;
    $('#signBtn').on('click', function () {
        if (res) {
            $('#signBtn').css("display", "none");
            $("#userInput").css("display", "block");
        } else {
            $("#res").css("display", "none");
            $('#signBtn').css("display", "block");
            $('#signBtn').text("已签");
            $('#signBtn').css("background-color", "#eee");
            $('#signBtn').css("animation", "none");
            res = 0;
        }
    });
    $("#sub").on("click", function () {
        if ($("#uname").val()) {
            $.ajax({
                url: '{{urlfor "SigninApiController.Post"}}',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {"gid": $("#gid").val(), "account": $("#uname").val()},
                success: function (obj) {
                    console.log(obj)
                    if (obj.code === 1) {
                        $("#userInput").css("display", "none");
                        $("#res").css("display", "block");
                        $("#gift").text(obj.data.giftContent);
                    } else {
                        layer.msg(obj.msg);
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    layer.msg("请求异常，请稍后再试", {icon: 2});
                }
            });
            $("#conf").on("click", function () {
                $("#res").css("display", "none");
                $('#signBtn').css("display", "block");
                $('#signBtn').text("已签");
                $('#signBtn').css("background-color", "#eee");
                $('#signBtn').css("animation", "none");
                res = 0;
                $('#signBtn').click('click', function (event) {
                    event.preventDefault();
                });
            });
        } else {
            $("#sub").text("！！账 号 不 能 为 空！！");
            $("#sub").css("color", "red");
            setTimeout(() => {
                $("#sub").text("签到");
                $("#sub").css("color", "#fff");
            }, 1000);
            clearTimeout(1000);
        }
    });
</script>
</body>
</html>