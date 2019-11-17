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
	            <li class="layui-this">奖品列表</li>
	            <li class=""><a href='{{urlfor "GiftAddController.get"}}'>添加奖品</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "GiftIndexController.get"}}' method="get">
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
	                    <button class="layui-btn">搜索</button>
	                </div>
	                <div class="layui-inline">
	                    <span>当前活动总概率：{{.totalProb}}{{if gt .lessProb 0}}，不足100，系统将自动添加 {{.lessProb}} 概率的谢谢参与奖项。{{end}}</span>
	                </div>
	            </form>
	            <hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>ID</th>
	                        <th>活动名称</th>
	                        <th>编号</th>
	                        <th>奖品名称</th>
	                        <th>中奖概率</th>
	                        <th>奖品数量</th>
	                        <th>奖品内容</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{getGameName $vo.GameId}}</td>
		                        <td>{{$vo.Seq}}</td>
		                        <td>{{$vo.Name}}</td>
		                        <td>{{$vo.Probability}}</td>
		                        <td>{{$vo.Quantity}}</td>
		                        <td>{{$vo.Content}}</td>
								<td>
		                            <a href='{{urlfor "GiftEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "GiftIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
		                        </td>
		                    </tr>
						{{else}}
							{{template "sysmanage/aalayout/table-no-data.tpl"}}
						{{end}}
	                    </tbody>
	                </table>
					{{template "sysmanage/aalayout/paginator.tpl" .}}
	            </div>
				<div>
                    <span style="color: red;">注意：①奖品数量为0时，该奖品不会参与抽奖，抽奖时概率自动记为0；<br>
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					②中奖概率总和小于100时，系统将自动添加 <i>谢谢参与</i> 奖项，使概率总和达到100。<br>
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					③上述两种情况下的奖项将不在中奖记录中显示。</span>
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