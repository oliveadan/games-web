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
	            <li class=""><a href='{{urlfor "PermissionIndexController.get"}}'>菜单列表</a></li>
	            <li class="layui-this">编辑菜单</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "PermissionEditController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}" >
						<div class="layui-form-item">
	                        <label class="layui-form-label">父节点</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Pid" value="{{.data.Pid}}" required lay-verify="required" placeholder="请输入角色名称" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">名称</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Name" value="{{.data.Name}}" required lay-verify="required" placeholder="请输入角色名称" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">描述</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Description" value="{{.data.Description}}" placeholder="请输入描述" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">Url地址</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Url" value="{{.data.Url}}" placeholder="请输入url地址" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">图标</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Icon" value="{{.data.Icon}}" placeholder="请输入图标" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">排序</label>
	                        <div class="layui-input-block">
	                            <input type="text" name="Sort" value="{{.data.Sort}}" required lay-verify="required" placeholder="请输入排序" class="layui-input">
	                        </div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">菜单显示</label>
	                        <div class="layui-input-block">
	                            <input type="radio" name="Display" value="1" title="显示" {{if eq .data.Display 1}}checked="checked"{{end}}>
	                            <input type="radio" name="Display" value="0" title="隐藏" {{if eq .data.Display 0}}checked="checked"{{end}}>
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