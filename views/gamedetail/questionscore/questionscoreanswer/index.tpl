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
	            <li class="layui-this">调查结果</li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "QuestionscoreAnswerIndexController.get"}}' method="get">
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
                            <input type="checkbox" name="isExport" value="1" lay-skin="switch" lay-text="导出|导出">
                        </div>
                    </div>
	                <div class="layui-inline">
	                    <button class="layui-btn">搜索/导出</button>
					</div>
	            </form>
	            <hr>
	            <div class="layui-tab-item layui-show">
					<div>
	                <table class="layui-table" id="tbl" lay-data="{cellMinWidth:100}">
	                    <thead>
	                    <tr>
							<th lay-data="{field:'0', width:120}">提交IP</th>
							<th lay-data="{field:'1', width:170}">提交时间</th>
							{{range $i, $vo := .tableHeadList}}
							<th lay-data="{field:'{{$vo.Id}}', width:220}">{{$vo.Seq}}、{{$vo.Content}}</th>
							{{end}}
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $i, $v := .dataList}}
						    <tr>
								<td>{{map_get $v 0}}</td>
								<td>{{map_get $v -1}}</td>
								{{range $i, $vo := $.tableHeadList}}
								<td>{{map_get $v $vo.Id}}</td>
								{{end}}
		                    </tr>
						{{else}}
							{{template "sysmanage/aalayout/table-no-data.tpl"}}
						{{end}}
	                    </tbody>
	                </table>
					</div>
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