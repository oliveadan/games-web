<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="{{static_front}}/static/front/rich/wap/css/bootstrap.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/rich/wap/css/bootstrap.css">
    <script src="{{static_front}}/static/front/js/jquery.min.js"></script>
    <script src="{{static_front}}/static/front/rich/wap/js/bootstrap.js"></script>
    <script src="{{static_front}}/static/front/rich/wap/js/bootstrap.min.js"></script>
    <title>Document</title>
    <style>
        html {
            width: 100%;
            height: 100%;
        }

        body {
            background: url({{static_front}}/static/front/rich/wap/images/57.jpg);
            background-repeat: no-repeat;
            background-size: 100% 100%;
            text-align: center
        }

        .modal {
            margin: auto auto;
            width: 307px;
            height: 200px;
        }

        .modal-dialog {
            width: 307px;
            height: 200px;
        }

        .modal-title {
            padding: 0 0 0 0 !important;
            margin: 0 auto !important;
        }

        .modal-footer {
            margin: 0 auto !important;
        }

        .close {
            padding: 0 0 0 0 !important;
            margin: 0 0 0 0 !important;
        }

        .ipt {
            width: 80%;
            margin-left: 10%;
        }

        div {
            display: table-cell;
            vertical-align: middle;
            text-align: center;
        }

        img {
            width: 60%;
            height: 50%;
            margin-top: 145%;
        }

        @media screen and (min-width:776px) {
            html {
                width: 50%;
                height: 100%;
                margin-left: 32.5%;
            }

            body {
                background-size: 36em 100%;
            }
        }
    </style>
</head>

<body>
<input type="hidden" id="gid" value="{{.gameId}}">
    <div class="vu">
        <div class="vuson">
            <a href="" data-toggle="modal" data-target="#myModal"><img src="{{static_front}}/static/front/rich/wap/images/03.png" alt=""></a>
        </div>
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                        <h4 class="modal-title" id="myModalLabel">通过奖励领取</h4>
                    </div>
                    <input class="ipt" type="text" id="mobile" value="" placeholder="请输入您的手机号">
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                        <button type="button" onclick="getLevelGift()" class="btn btn-primary">提交</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal -->
        </div>
    </div>
</body>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script>
    $('#myModal').modal('hide')
</script>
<script>
    function getLevelGift() {
        var gid = $("#gid").val();
        var account = {{.loginAccount}};
        var stage ={{.currentStage}};
        if (account == "") {
            layer.msg("请登录后再进行领取");
            return
        }else {
            $.ajax({
                url: {{urlfor "RichApiController.GetLevelGift"}},
                type: "post",
                data: {"gid": gid, "account": account, "stage": stage, "mobile": $("#mobile").val()},
                success: function (info) {
                    if (info.code === 1) {
                        $('#myModal').modal('hide');
                    } else {
                        $("#mobile").val("");
                    }
                    layer.msg(info.msg);
                },
            });
        }
    }
</script>
</html>