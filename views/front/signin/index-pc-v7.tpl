<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v7/css/bootstrap.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/signin/v7/css/index.css">
</head>

<body>
    <div class="container">
        <input type="hidden" id="gid" value="{{.gameId}}">
        <div class="p-5 ppp"></div>
        <div class="tit text-center">签到第7期</div>
        <div class="res p-0 m-0 text-center pt-4 text-danger btn">
            &nbsp;请输入您的账号再进行签到哦！
        </div>
        <hr class="hr1 border-warning mb-5">
        <div class="row text-center mmm1 justify-content-center">
            <div class="mmpp col-lg-4 p-0 mb-3 pt-2 mr-lg-4 col-sm-12 mr-sm-5">
                <input id="uid" class="uname text-center mt-4" type="text" placeholder="请输入账号">
            </div>
            <div id="qd" class="col-lg-4 col-sm-4 p-0">
                <img src="{{static_front}}/static/front/signin/v7/img/signin.png" alt="">
            </div>
            <div  class="col-lg-3 col-sm-4 p-0">
                <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" target="_blank">
                    <img src="{{static_front}}/static/front/signin/v7/img/signinchaxun.png" alt="">
                </a>
            </div>
        </div>
        <div class="list text-center bg-light">
            <!-- <h5 class="h5 font-weight-bold p-2">会员签到记录查询</h5> -->
            <div class="mb-3 mmm">
                <input id="uid1" class="text-center mb-2" type="text" placeholder="请输入会员账号">
                <button id="cxBtn" class="btn btn-lg btn-warning mb-2"> 查 询 </button>
            </div>
            <div class="" id="dialogs">
                <div class="text-center font-weight-bold">
                    <table class="table">
                        <thead class="text-success">
                            <td>签到奖励</td>
                            <td>时间</td>
                            <td>是否派奖</td>
                        </thead>
                        <tbody class="text-dark">
                            <tr>
                                <td>现金 8888.88 元</td>
                                <td>2020/20/20</td>
                                <td>是</td>
                            </tr>
                            <tr>
                                <td>现金 8888.88 元</td>
                                <td>2020/20/20</td>
                                <td>是</td>
                            </tr>
                            <tr>
                                <td>现金 8888.88 元</td>
                                <td>2020/20/20</td>
                                <td>是</td>
                            </tr>
                            <tr>
                                <td>现金 8888.88 元</td>
                                <td>2020/20/20</td>
                                <td>是</td>
                            </tr>
                            <tr>
                                <td>现金 8888.88 元</td>
                                <td>2020/20/20</td>
                                <td>是</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div id="listClose" class="bg-warning text-danger font-weight-bold">
                关 闭
            </div>
        </div>
        <div class="mb-5 p-5"></div>
        <div class="mb-5 p-5"></div>
        <div class="mb-5 p-5"></div>
        <div class="mb-5 p-5"></div>
    </div>
    </div>
    </div>
    <script src="{{static_front}}/static/front/signin/v7/js/jquery-3.3.1.min.js"></script>
    <script src="{{static_front}}/static/front/signin/v7/js/popper.min.js"></script>
    <script src="{{static_front}}/static/front/signin/v7/js/bootstrap.js"></script>
    <script src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
    <script>
        $(function () {
            var bool = false;
            $(".mobile-menu-btn").click(function () {
                if ($(".slide-menu").is(":hidden")) {
                    $(".slide-menu").show();
                } else {
                    $(".slide-menu").hide();
                }
            });
            $("#qd").click(function () {
                if (bool) {
                    layer.msg("您今天已经签到了！");
                    return
                }
                var account = $("#uid").val();
                if (account == "") {
                    layer.msg("请输入会员账号", {icon: 2});
                    return;
                }
                $.ajax({
                    url: '{{urlfor "SigninApiController.Post"}}',
                    dataType: 'json',
                    cache: false,
                    type: 'POST',
                    data: {"gid": $("#gid").val(), "account": account},
                    beforeSend: function () {

                    },
                    success: function (obj) {
                        if (obj.code == 0) {
                            $("#rankDay1Btn").show();
                            layer.msg(obj.msg, {icon: 2});
                        } else if (obj.code == 2) {
                            $("#rankDay1Btn").show();
                            bool = true;
                            layer.msg(obj.msg, {icon: 1});
                        } else if (obj.code == 1) {
                            bool = true;
                            var html = '';
                            if (obj.data.hasOwnProperty("giftContent")) {
                                html = '<div>恭喜您获得</div>';
                                html = html + '</br>';
                                html = html + '<span style="font-size:37px;color: red">' + obj.data.giftContent + '&nbsp;元</span>';
                            }
                            var level = "";
                            if (obj.data.force1 < 0) {
                                level = '<div><span style="color:orangered">您以达到最大等级</span></div>'
                            } else {
                                level = '<div>到<span style="color:red">' + obj.data.nextlevlelNme + '</span>还需<span style="color:red;">&nbsp;' + obj.data.force1 + obj.data.unit + '</span></div>'
                            }
                            html = html + level;
                            if (obj.data.hasOwnProperty("gift")) {
                                html = html + '</br>';
                                html = html + '<span style="font-weight: bolder;font-size:20px;color:#6C187C;" >' + obj.data.gift + '</span>';
                            }
                            layer.alert(html, {title: obj.msg, icon: 6,});
                        } else if (obj.code == 3) {
                            html = '<div>恭喜您获得<span style="color:red;">&nbsp;' + obj.data.giftContent + '&nbsp;元</span></div>';
                            var register = "<a style=\"color:red\" href=\"{{.officialRegist}}\">点击进行注册</a>";
                            html = html + '<div><span style="color:blue">注册会员账号，签到可得更多彩金</span><br>' + register + '</div>';
                            layer.alert(html, {title: obj.msg, icon: 6});
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        layer.msg("请求异常，请稍后再试", {icon: 2});
                    }
                })
            });
        });
    </script>
</body>
</html>