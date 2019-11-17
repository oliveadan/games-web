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
	            <li class="layui-this">投票详情</li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" style="max-width: 1500px;" action='{{urlfor "VoteDetailIndexController.get"}}' method="get">
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
	                        <input type="text" name="account" value="{{.condArr.account}}" placeholder="投票会员账号" class="layui-input">
	                    </div>
	                </div>
					<div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <input type="text" name="timeStart" value="{{.condArr.timeStart}}" placeholder="起始时间" class="layui-input">
	                    </div>
	                    <div class="layui-input-inline">
	                        <input type="text" name="timeEnd" value="{{.condArr.timeEnd}}" placeholder="截止时间" class="layui-input">
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
	                        <th style="width:30px;">ID</th>
	                        <th>活动名称</th>
	                        <th>投票人</th>
	                        <th>选票名称</th>
	                        <th>投票IP</th>
							<th>投票时间</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{getGameName $vo.GameId}}</td>
		                        <td>{{$vo.Account}}</td>
		                        <td>{{$vo.VoteItemName}}</td>
		                        <td>{{$vo.Ip}}</td>
								<td>{{date $vo.CreateDate "Y-m-d H:i:s"}}</td>
		                        <td>
		                            <button href='{{urlfor "VoteDetailIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</button>
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
<script>
    layui.use('laydate', function(){
        var laydate = layui.laydate;
        laydate.render({
            elem: 'input[name="timeStart"]',
            type: 'datetime'
        });
        laydate.render({
            elem: 'input[name="timeEnd"]',
            type: 'datetime'
        });
    });
</script>
</body>
</html>