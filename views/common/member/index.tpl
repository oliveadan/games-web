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
	            <li class="layui-this">会员列表</li>
	            <li class=""><a href='{{urlfor "MemberAddController.get"}}'>添加会员</a></li>
	            <li class=""><a id="import" lay-data="{url: '{{urlfor "MemberIndexController.Import"}}'}" href='javascript:void(0);'>批量导入</a></li>
	            <li class=""><a href='{{urlfor "MemberIndexController.Delbatch"}}' class="layui-btn layui-btn-danger layui-btn-small ajax-batch">删除所有会员</a></li>
	            <li class=""><a href='{{urlfor "MemberIndexController.RebootSign"}}' class="layui-btn layui-btn-danger layui-btn-small ajax-batch">重置签到数据</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "MemberIndexController.get"}}' method="get">
	                <div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <input type="text" name="param1" value="{{.param1}}" placeholder="账号 | 姓名 | 电话" class="layui-input">
	                    </div>
	                </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="checkbox" name="isExport" value="1" lay-skin="switch" lay-text="导出|导出">
                        </div>
                    </div>
	                <div class="layui-inline">
	                    <button class="layui-btn">搜索/导出</button>
	                </div>
	            </form>
	            <hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>ID</th>
	                        <th>账号</th>
	                        <th>姓名</th>
	                        <th>电话</th>
	                        <th>注册IP</th>
	                        <th>邀请码</th>
	                        <th>推荐码</th>
							<th>等级</th>
							<th>总点数</th>
	                        <th>签到时间</th>
	                        <th>可签到活动ID</th>
	                        <th>活跃值</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{$vo.Account}}</td>
		                        <td>{{$vo.Name}}</td>
		                        <td>{{$vo.Mobile}}</td>
		                        <td>{{$vo.RegIp}}</td>
		                        <td>{{$vo.InvitationCode}}</td>
		                        <td>{{$vo.ReferrerCode}}</td>
		                        <td>{{$vo.LevelName}}</td>
		                        <td>{{$vo.Force}}</td>
		                        <td>{{date $vo.LastSigninDate "Y-m-d H:i:s"}}</td>
		                        <td>{{$vo.SignEnable}}</td>
		                        <td>{{$vo.Dynamic}}</td>
		                        <td>
		                            <a href='{{urlfor "MemberEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "MemberIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
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