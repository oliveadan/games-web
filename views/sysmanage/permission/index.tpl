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
	            <li class="layui-this">菜单列表</li>
	            <li class=""><a href='{{urlfor "PermissionAddController.get"}}'>添加菜单</a></li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>ID</th>
	                        <th>名称</th>
	                        <th>描述</th>
							<th>地址</th>
							<th>图标</th>
							<th>排序</th>
							<th>显示</th>
	                        <th>状态</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{$vo.Name}}</td>
		                        <td>{{$vo.Description}}</td>
		                        <td>{{$vo.Url}}</td>
		                        <td><i class="layui-icon">{{if $vo.Icon}}&{{$vo.Icon}}{{end}}</i></td>
		                        <td>{{$vo.Sort}}</td>
		                        <td>{{if eq $vo.Display 1}}<span class="layui-badge layui-bg-green">显示</span>{{else}}<span class="layui-badge layui-bg-red">隐藏</span>{{end}}</td>
		                        <td>{{if eq $vo.Enabled 1}}<span class="layui-badge layui-bg-green">启用</span>{{else}}<span class="layui-badge layui-bg-red">禁用</span>{{end}}</td>
		                        <td>
		                            <a href='{{urlfor "PermissionEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "PermissionIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
		                        </td>
		                    </tr>
						{{else}}
							{{template "sysmanage/aalayout/table-no-data.tpl"}}
						{{end}}
	                    </tbody>
	                </table>
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