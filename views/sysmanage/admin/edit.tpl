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
	            <li class=""><a href='{{urlfor "AdminIndexController.get"}}'>管理员列表</a></li>
	            <li class="layui-this">编辑管理员</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "AdminEditController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}" >
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">用户名</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Username" value="{{.data.Username}}" required lay-verify="required" placeholder="请输入用户名" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">名称</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Name" value="{{.data.Name}}" required lay-verify="required" placeholder="请输入名称" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">密码</label>
	                        <div class="layui-input-block">
	                            <input type="password" name="Password" value="" placeholder="请输入密码" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">确认密码</label>
	                        <div class="layui-input-block">
	                            <input type="password" name="repassword" value="" placeholder="请再次输入密码" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">状态</label>
	                        <div class="layui-input-block">
	                            <input type="radio" name="Enabled" value="1" title="启用" {{if eq .data.Enabled 1}}checked="checked"{{end}}>
	                            <input type="radio" name="Enabled" value="0" title="禁用" {{if eq .data.Enabled 0}}checked="checked"{{end}}>
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">所属权限组</label>
	                        <div class="layui-input-block">
	                        {{range $index, $vo := .roleList}}
								<input type="checkbox" name="roles" title="{{$vo.Name}}" value="{{$vo.Id}}" {{if map_get $.adminRoleMap $vo.Id}} checked {{end}}>
							{{else}}
								<label class="layui-form-label">未配置角色</label>
							{{end}}
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