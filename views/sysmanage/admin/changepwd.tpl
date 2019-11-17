<!DOCTYPE html>
<html lang="zh-CN">
<head>
    {{template "sysmanage/aalayout/meta.tpl" .}}
</head>
<body>
<div class="layui-layout layui-layout-admin">
    <!--头部-->
    {{template "sysmanage/aalayout/header.tpl" .}}
    <!--侧边栏-->
    {{template "sysmanage/aalayout/left.tpl" .}}
    <!--主体-->
	<div class="layui-body">
	    <!--tab标签-->
	    <div class="layui-tab layui-tab-brief">
	        <ul class="layui-tab-title">
	            <li class="layui-this">修改密码</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "ChangePwdController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<div class="layui-form-item">
	                        <label class="layui-form-label">原密码</label>
	                        <div class="layui-input-block">
								<input type="hidden" id="oldId" name="oldPassword">
	                            <input type="password" id="oldPassword" value="" required lay-verify="required" placeholder="请输入原密码" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">新密码</label>
	                        <div class="layui-input-block">
								<input type="hidden" id="newId" name="newPassword">
	                            <input type="password" id="newPassword" value="" placeholder="请输入新密码" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">确认新密码</label>
	                        <div class="layui-input-block">
								<input type="hidden" id="renewId" name="reNewPassword">
	                            <input type="password" id="reNewPassword" value="" placeholder="请再次输入新密码" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <div class="layui-input-block">
	                            <button class="layui-btn" lay-submit lay-filter="changepwd">更新</button>
	                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
	                        </div>
	                    </div>
	                </form>
	            </div>
	        </div>
	    </div>
	</div>

    <!--底部-->
    {{template "sysmanage/aalayout/footer.tpl" .}}
</div>
<script src="/static/js/jquery.min.js"></script>
<script src="/static/layui/layui.all.js"></script>
<script src="/static/js/md5.min.js"></script>
<script>
layui.use(['layer','form'], function(){
    var layer = layui.layer,
        form = layui.form;
    /**
     * 通用表单提交(AJAX方式)
     */
    form.on('submit(changepwd)', function (data) {
    	$("#oldId").val(md5($("#oldPassword").val()));
    	$("#newId").val(md5($("#newPassword").val()));
    	$("#renewId").val(md5($("#reNewPassword").val()));
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