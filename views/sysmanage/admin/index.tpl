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
	            <li class="layui-this">管理员列表</li>
	            <li class=""><a href='{{urlfor "AdminAddController.get"}}'>添加管理员</a></li>
	        </ul>
	        <div class="layui-tab-content">
	            <form class="layui-form layui-form-pane" action='{{urlfor "AdminIndexController.get"}}' method="get">
	                <div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <input type="text" name="username" value="{{.condArr.username}}" placeholder="用户名" class="layui-input">
	                    </div>
	                </div>
	                <div class="layui-inline">
	                    <button class="layui-btn">搜索</button>
	                </div>
	            </form>
	            <hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>ID</th>
	                        <th>用户名</th>
	                        <th>名称</th>
	                        <th>状态</th>
	                        <th>创建时间</th>
	                        <th>最后登录时间</th>
	                        <th>最后登录IP</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{$vo.Username}}</td>
		                        <td>{{$vo.Name}}</td>
		                        <td>{{if eq $vo.Enabled 1}}<span class="layui-badge layui-bg-green">启用</span>{{else}}<span class="layui-badge layui-bg-red">禁用</span>{{end}}</td>
		                        <td>{{date $vo.CreateDate "Y-m-d H:i:s"}}</td>
		                        <td>{{date $vo.LoginDate "Y-m-d H:i:s"}}</td>
		                        <td>{{$vo.LoginIp}}</td>
		                        <td>
		                            <a href='{{urlfor "AdminEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "AdminIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
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