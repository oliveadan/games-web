<!DOCTYPE html>
<html>

<head>
    <title>Login</title>
    <meta charset="utf-8">
    <link href="{{static_front}}/static/front/vipvalue/css/style.css" rel='stylesheet' type='text/css'/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>

<body>
<div class="content">
    <input type="hidden" id="gid" value="{{.gameId}}">
    <form>
        <input type="text" class="text"  id="account"  placeholder="请输入您的会员账号">
        <div class="submit">
        <input id="triggerBtn" type="button" value="查看VIP账号价值">
        </div>
        <!-- 模态框 -->
        <div id="myModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <b class="mhra"></b>&nbsp;&nbsp;&nbsp;&nbsp;VIP<b class=mhrb></b>
                </div>
                <div class="modal-body">
                    您于<b class="mbyo"></b>日注册<br>
                    加入永利集团已经<b class="mbyt"></b>天
                </div>
                <div class="modal-footer">
                    账号价值<b>【</b><b class="mfr"></b><b>】</b>元
                </div>
                <span id="closeBtn" class="close">
                    <img src="{{static_front}}/static/front/vipvalue/images/close.png" alt="">
                </span>
            </div>
        </div>
    </form>
</div>
<div style="display:none"></div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
</body>
<script>
(function () {
    /*建立模态框对象*/
    var modalBox = {};
    modalBox.modal = document.getElementById("myModal");
    modalBox.triggerBtn = document.getElementById("triggerBtn");
    modalBox.closeBtn = document.getElementById("closeBtn");
    modalBox.show = function () {
        this.modal.style.display = "block";
    };
    modalBox.close = function () {
        this.modal.style.display = "none";
    };
    modalBox.outsideClick = function () {
        var modal = this.modal;
        window.onclick = function (event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    };
    modalBox.init = function () {
        var that = this;
        this.triggerBtn.onclick = function () {
            $(document).one("click", "#triggerBtn", function () {
                var account = $("#account").val();
                if (account == "") {
                    layer.msg("会员账号不能为空");
                    return
                } else {
                    $.ajax({
                        url: '/vipvalue',
                        dataType: 'json',
                        cache: false,
                        type: 'POST',
                        data: {
                            gid: $("#gid").val(),
                            account: account
                        },
                        success: function (obj) {
                            if (obj.code == 0) {
                                layer.msg(obj.msg);
                                return
                            } else {
                                that.show();
                                var date = obj.data.VipValue.RegisterDate;
                                var newdate = date.substring(0,10);
                                $('.mhra').html(obj.data.VipValue.Account);
                                $('.mhrb').html(obj.data.VipValue.VipLevel);
                                $('.mbyo').html(newdate);
                                $('.mbyt').html(obj.data.VipValue.RegisterDays);
                                $('.mfr').html(obj.data.VipValue.Value);
                            }
                        }
                    })
                }
            })
        };
        this.closeBtn.onclick = function () {
            that.close();
        };
        this.outsideClick();
    };
    modalBox.init();
})();
</script>
</html>