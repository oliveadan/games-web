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
	            <li class="layui-this">会员投注列表</li>
	            <li class=""><a href='{{urlfor "MonthsigninBetAddController.get"}}'>添加会员投注</a></li>
	            <li class=""><a id="import" lay-data="{url: '{{urlfor "MonthsigninBetIndexController.Import"}}'}" href='javascript:void(0);'>批量导入</a></li>
	            <li class=""><a href='{{urlfor "MonthsigninBetIndexController.DelBatch"}}' class="layui-btn layui-btn-danger layui-btn-small ajax-batch">删除所有会员</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "MonthsigninBetIndexController.get"}}' method="get">
					<div class="layui-inline">
						<label class="layui-form-label">活动名称</label>
						<div class="layui-input-inline">
							<select name="gameId" lay-verify="required" lay-filter="gameslt" lay-search>
								{{range $i, $m := .gameList}}
									<option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
								{{end}}
							</select>
						</div>
					</div>
	                <div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <input type="text" name="account" value="{{.condArr.account}}" placeholder="会员账号" class="layui-input">
	                    </div>
	                </div>
                   {{/* <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="checkbox" name="isExport" value="1" lay-skin="switch" lay-text="导出|导出">
                        </div>
                    </div>*/}}
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
							<th>会员账号</th>
							<th>活动名称</th>
							<th>导入时间</th>
							<th>投注</th>
							<th>补签后剩余投注</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
								<td>{{$vo.Id}}</td>
								<td>{{$vo.Account}}</td>
								<td>{{getGameName $vo.GameId}}</td>
								<td>{{date $vo.CreateDate "Y-m-d H:i:s"}}</td>
								<td>{{$vo.Bet}}</td>
								<td>{{$vo.SurplusBet}}</td>
		                        <td>
		                            <a href='{{urlfor "MonthsigninBetEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "MonthsigninBetIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
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