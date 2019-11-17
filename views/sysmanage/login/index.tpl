<!DOCTYPE html>
<html lang="zh-CN">
<head>
    {{template "sysmanage/aalayout/meta.tpl" .}}
</head>
<body class="login">
    <div class="login-title"><strong>{{.siteName}}</strong> BMS</div>
<form class="layui-form login-form" action='{{urlfor "LoginController.post"}}' method="post">
    {{ .xsrfdata }}
	<div class="layui-form-item">
        <label class="layui-form-label">用户名</label>
        <div class="layui-input-block">
            <input type="text" name="username" id="username" required lay-verify="required" autocomplete="off" class="layui-input" value="admin">
        </div>
    </div>
    <div class="layui-form-item">
        <label class="layui-form-label">密码</label>
        <div class="layui-input-block">
            <input type="hidden" name="password" id="password"/>
            <input type="password" id="psw" required lay-verify="required" class="layui-input" value="111111">
        </div>
    </div>
	<div class="layui-form-item">
        <label class="layui-form-label">验证码</label>
        <div class="layui-input-block">
            <input type="text" name="captcha" required lay-verify="required" class="layui-input layui-input-inline" value="1">
            {{create_captcha}}
        </div>
    </div>
    <div class="layui-form-item">
        <div class="layui-input-block">
            <button class="layui-btn" lay-submit lay-filter="login">登 录</button>
        </div>
    </div>
</form>
<script src="/static/js/jquery.min.js"></script>
<script src="/static/layui/layui.all.js"></script>
<script src="/static/js/jsencrypt.min.js"></script>
<script src="/static/js/md5.min.js"></script>
<script>
layui.use(['layer','form'], function(){
    var layer = layui.layer,
        form = layui.form;
    /**
     * 通用表单提交(AJAX方式)
     */
    form.on('submit(login)', function (data) {
        var crypt = new JSEncrypt();
        crypt.setPublicKey({{.pubkey}});
        var enc = crypt.encrypt(md5($("#psw").val()));
		//var enc = md5($("#psw").val());
    	$("#password").val(enc);
		$("#psw").val("");
        $.ajax({
            url: data.form.action,
            type: data.form.method,
            data: $(data.form).serialize(),
            success: function (info) {
                if (info.code === 1) {
                    setTimeout(function () {
                        location.href = info.url;
                    }, 1000);
                }
                layer.msg(info.msg);
            }
        });
    
        return false;
    });
});
</script>
</body>
</html>