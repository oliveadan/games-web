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
	            <li class="layui-this">商品列表</li>
	            <li class=""><a href='{{urlfor "GoodsAddController.get"}}'>添加商品</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "GoodsIndexController.get"}}' method="get">
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
	            </form>
	            <hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>ID</th>
	                        <th>活动名称</th>
	                        <th>商品名称</th>
	                        <th>商品状态</th>
	                        <th>商品说明</th>
	                        <th>商品图片</th>
	                        <th>兑换所需积分</th>
	                        <th>排序字段</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{getGameName $vo.GameId}}</td>
		                        <td>{{$vo.Name}}</td>
								<td>{{if eq 1 $vo.BroadcastFlag}}新增{{else if eq 2 $vo.BroadcastFlag}}热销{{else if eq 3 $vo.BroadcastFlag}}限量{{else if eq 4 $vo.BroadcastFlag}}特惠{{else}}无{{end}}</td>
		                        <td>{{$vo.Content}}</td>
		                        <td><img src="{{$vo.Photo}}"></td>
		                        <td>{{$vo.Seq}}</td>
		                        <td>{{$vo.Probability}}</td>
								<td>
		                            <a href='{{urlfor "GoodsEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "GoodsIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
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