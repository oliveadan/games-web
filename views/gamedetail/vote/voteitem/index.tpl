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
	            <li class="layui-this">选票列表</li>
	            <li class=""><a href='{{urlfor "VoteItemAddController.get"}}'>添加选票</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "VoteItemIndexController.get"}}' method="get">
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
				<div style="margin: 0 5px;">
					当前活动：{{getGameName .voteGid}}<br>奖池因子：<span style="color:#FF5722;">{{or .factor "未配置"}}</span>
					<button data-gid="{{.voteGid}}" class="layui-btn layui-btn-normal layui-btn-mini edit-factor">修改</button>
					<button href='{{urlfor "VoteItemIndexController.Generate" "gid" .voteGid}}' class="layui-btn layui-btn-normal layui-btn-mini ajax-generate">生成中奖记录</button>
				</div>
				<div class="layui-word-aux"><p>奖池因子用于计算选票的奖池总金额，计算规则：(所有选票总票数 - 当前选票总票数) x 奖池因子 = 奖池总金额</p></div>
				<hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>ID</th>
	                        <th>选票名称</th>
	                        <th>排序</th>
	                        <th>真实票数</th>
	                        <th>调整票数</th>
	                        <th>总票数</th>
	                        <th>奖池总金额</th>
	                        <th>人均金额</th>
	                        <th>更新时间</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
								<td>{{$vo.Id}}</td>
		                        <td>{{$vo.Name}}</td>
		                        <td>{{$vo.Seq}}</td>
		                        <td>{{$vo.NumVote}}</td>
		                        <td>{{$vo.NumAdjust}}</td>
		                        <td>{{numberAdd $vo.NumVote $vo.NumAdjust}}</td>
								<td>{{if (map_get $.prizeMap $vo.Id)}}{{index (map_get $.prizeMap $vo.Id) 0}}{{end}}</td>
								<td>{{if (map_get $.prizeMap $vo.Id)}}{{index (map_get $.prizeMap $vo.Id) 1}}{{end}}</td>
		                        <td>{{date $vo.ModifyDate "Y-m-d H:i:s"}}</td>
								<td>
									{{if eq $vo.Flag 0}}
									<button href='{{urlfor "VoteItemIndexController.MarkFlag" "id" $vo.Id "flag" 1}}' class="layui-btn layui-btn-mini ajax-click">设为中奖</button>
									{{else}}
									<button href='{{urlfor "VoteItemIndexController.MarkFlag" "id" $vo.Id "flag" 0}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-click">取消中奖</button>
									{{end}}
		                            <a href='{{urlfor "VoteItemEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <button href='{{urlfor "VoteItemIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</button>
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
    layui.use('layer', function(){
		$('.edit-factor').on('click', function () {
            var gameId = $(this).attr('data-gid');
            layer.prompt({
                title: '修改奖池因子'
            }, function(value, index, elem){
                if(isNaN(value)) {
                    layer.msg("奖池因子必须为数字")
					return;
				}
                $.ajax({
                    url: {{urlfor "VoteItemIndexController.ModifyFactor"}},
                    type: "post",
					data: {"gid": gameId, "factor": value},
                    success: function (info) {
                        if (info.code === 1) {
                            setTimeout(function () {
                                location.href = info.url || location.href;
                            }, 1000);
                        }
                        layer.msg(info.msg);
                    }
                });
                layer.close(index);
            });

            return false;
        });
		// 生成中奖记录
		$('.ajax-generate').on('click', function () {
	        var _href = $(this).attr('href');
	        layer.open({
	            content: '生成时将删除当前活动下所有未派彩的中奖记录，<br>确定生成新的中奖记录？',
	            btn: ['确定', '取消'],
	            yes: function (index) {
	                $.ajax({
	                    url: _href,
	                    type: "get",
	                    success: function (info) {
	                        if (info.code === 1) {
	                            setTimeout(function () {
	                                location.href = info.url || location.href;
	                            }, 1000);
	                        }
	                        layer.msg(info.msg);
	                    }
	                });
	                layer.close(index);
	            }
	        });
	
	        return false;
	    });
    });
</script>
</body>
</html>