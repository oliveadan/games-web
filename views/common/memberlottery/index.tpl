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
	            <li class="layui-this">会员抽奖次数列表</li>
	            <li class=""><a href='{{urlfor "MemberLotteryAddController.get"}}'>添加抽奖次数</a></li>
	            <li class=""><a id="import" lay-data="{url: '{{urlfor "MemberLotteryIndexController.Import"}}'}" href='javascript:void(0);'>批量导入</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "MemberLotteryIndexController.get"}}' method="get">
	                <div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <select name="gameId" lay-verify="required" lay-search>
                               	{{range $i, $m := .gameList}}
								<option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
								{{end}}
                            </select>
	                    </div>
	                </div>
					<div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <input type="text" name="account" value="{{.account}}" placeholder="会员账号" class="layui-input">
	                    </div>
	                </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="checkbox" name="isExport" value="1" lay-skin="switch" lay-text="导出|导出">
                        </div>
                    </div>
	                <div class="layui-inline">
	                    <button class="layui-btn">搜索/导出</button>
						<a href='{{urlfor "MemberLotteryIndexController.Delbatch"}}' class="layui-btn layui-btn-danger layui-btn-small ajax-batch">批量删除</a>
	                </div>
	            </form>
	            <hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>活动名称</th>
	                        <th>会员账号</th>
	                        <th>抽奖次数</th>
	                        <th>创建时间</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{getGameName $vo.GameId}}</td>
		                        <td>{{$vo.Account}}</td>
		                        <td>{{$vo.LotteryNums}}</td>
		                        <td>{{date $vo.CreateDate "Y-m-d H:i:s"}}</td>
								<td>
		                            <a href='{{urlfor "MemberLotteryEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "MemberLotteryIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
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