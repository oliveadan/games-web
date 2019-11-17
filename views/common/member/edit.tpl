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
	            <li class=""><a href='{{urlfor "MemberIndexController.get"}}'>会员列表</a></li>
	            <li class="layui-this">编辑会员</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "MemberEditController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}" >
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">账号</label>
	                        <div class="layui-input-block">
								<input type="text" name="Account" value="{{.data.Account}}" required lay-verify="required" placeholder="请输入账号" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">名称</label>
	                        <div class="layui-input-block">
								<input type="text" name="Name" value="{{.data.Name}}" placeholder="可空" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
                            <label class="layui-form-label">电话</label>
                            <div class="layui-input-block">
                                <input type="text" name="Mobile" value="{{.data.Mobile}}" placeholder="可空" class="layui-input">
                            </div>
                        </div>
						<div class="layui-form-item">
							<label class="layui-form-label">邀请码</label>
							<div class="layui-input-block">
								<input type="text" name="InvitationCode" value="{{.data.InvitationCode}}" placeholder="可空" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">总点数</label>
							<div class="layui-input-block">
								<input type="text" name="Force" value="{{.data.Force}}" placeholder="总点数" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">可签到活动ID</label>
							<div class="layui-input-block">
								<input type="text" name="SignEnable" value="{{.data.SignEnable}}" placeholder="可空" class="layui-input">
							</div>
						</div>
	                    <div class="layui-form-item">
	                        <div class="layui-input-block">
	                            <button class="layui-btn" lay-submit lay-filter="*">保存</button>
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
</body>
</html>