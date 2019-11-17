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
	            <li class=""><a href='{{urlfor "GameIndexController.get"}}'>活动列表</a></li>
                <li class=""><a href='{{urlfor "GamePeriodIndexController.get" "GameId" .GameId}}'>时间段列表</a></li>
                <li class="layui-this">添加时间段</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "GamePeriodAddController.post"}}' method="post">
                    {{ .xsrfdata }}
                        <input type="hidden" name="GameId" value="{{.GameId}}" >
                        <div class="layui-form-item">
                            <label class="layui-form-label">开始时间</label>
                            <div class="layui-input-block">
                                <input type="text" name="StartTime"   placeholder="设置一天内的活动的开始时间" lay-verify="required" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">结束时间</label>
                            <div class="layui-input-block">
                                <input type="text" name="EndTime"   placeholder="设置一天内的活动的结束时间" lay-verify="required" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <div class="layui-input-block">
                                <button class="layui-btn" lay-submit lay-filter="gameperiodSubmit">保存</button>
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
{{template "sysmanage/aalayout/footjs.tpl" .}}
<script>
    layui.use(['layer','form','laydate','layedit'], function(){
        var layer = layui.layer;
        var form = layui.form;
        var laydate = layui.laydate;
        var layedit = layui.layedit;

        laydate.render({
            elem: 'input[name="StartTime"]'
            ,type: 'time'
        });
        laydate.render({
            elem: 'input[name="EndTime"]',
            type: 'time'
        });
        layedit.set({
            uploadImage: {
                url: '{{urlfor "SyscommonController.Upload"}}',
                type: 'post'
            }
        });
        var richText = layedit.build('GameRule');

        /**
         * 通用表单提交(AJAX方式)
         */
        form.on('submit(gameperiodSubmit)', function (data) {
            layedit.sync(richText);
            $.ajax({
                url: data.form.action,
                type: data.form.method,
                data: $(data.form).serialize(),
                success: function (info) {
                    if (info.code === 1) {
                        setTimeout(function () {
                            location.href = info.url || location.href;
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
