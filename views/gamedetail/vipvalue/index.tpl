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
	            <li class="layui-this">会员账号价值列表</li>
				<li class=""><a href='{{urlfor "VipValueAddController.get"}}'>添加会员账号价值</a></li>
				<li class=""><a id="import" lay-data="{url: '{{urlfor "VipValueIndexController.Import"}}'}" href='javascript:void(0);'>批量导入</a></li>
				<li><a href='{{urlfor "VipValueIndexController.BatchDel" }}' class="layui-btn layui-btn-danger ajax-batch">删除所有</a></li>
	        </ul>
	        <div class="layui-tab-content">
	            <hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>编号</th>
	                        <th>会员账号</th>
	                        <th>VIP等级</th>
	                        <th>注册日期</th>
	                        <th>注册天数</th>
	                        <th>账号价值</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{$vo.Account}}</td>
		                        <td>{{$vo.VipLevel}}</td>
		                        <td>{{date $vo.RegisterDate "Y-m-d"}}</td>
		                        <td>{{$vo.RegisterDays}}</td>
								<td>{{$vo.Value}}</td>
								<td>
		                            <a href='{{urlfor "VipValueEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "VipValueIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
		                        </td>
		                    </tr>
						{{else}}
							{{template "sysmanage/aalayout/table-no-data.tpl"}}
						{{end}}
	                    </tbody>
	                </table>
					{{template "sysmanage/aalayout/paginator.tpl" .}}
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