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
	            <li class=""><a href='{{urlfor "VoteItem2AddController.get"}}'>添加选票</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "VoteItem2IndexController.get"}}' method="get">
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
					当前活动：{{getGameName .voteGid}}<br>总奖池金额：<span style="color:#FF5722; margin-right: 10px;">{{or .prize "未配置"}}</span>
					<button data-gid="{{.voteGid}}" class="layui-btn layui-btn-normal layui-btn-mini edit-prize">修改</button>
					<button href='{{urlfor "VoteItem2IndexController.Generate" "gid" .voteGid}}' class="layui-btn layui-btn-normal layui-btn-mini ajax-generate">生成中奖记录</button>
					<span class="layui-word-aux">生成中奖记录规则：总奖池金额平均分配给所有中奖的票数。</span>
					<br>
					平均每票中奖金额：<span style="color:#FF5722; margin-right: 10px;">{{or .perAmount 0}}</span>
					实际派发总金额：<span style="color:#FF5722; margin-right: 10px;">{{or .realAmount 0}}</span>
					<span class="layui-word-aux">设置中奖选票后才能计算出来</span>
				</div>
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
								<td>{{date $vo.ModifyDate "Y-m-d H:i:s"}}</td>
								<td>
									{{if eq $vo.Flag 0}}
									<button href='{{urlfor "VoteItem2IndexController.MarkFlag" "id" $vo.Id "flag" 1}}' class="layui-btn layui-btn-mini ajax-click">设为中奖</button>
									{{else}}
									<button href='{{urlfor "VoteItem2IndexController.MarkFlag" "id" $vo.Id "flag" 0}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-click">取消中奖</button>
									{{end}}
		                            <a href='{{urlfor "VoteItem2EditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <button href='{{urlfor "VoteItem2IndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</button>
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
		$('.edit-prize').on('click', function () {
            var gameId = $(this).attr('data-gid');
            layer.prompt({
                title: '修改总奖池'
            }, function(value, index, elem){
                if(isNaN(value)) {
                    layer.msg("总奖池必须为数字")
					return;
				}
                $.ajax({
                    url: {{urlfor "VoteItem2IndexController.ModifyPrize"}},
                    type: "post",
					data: {"gid": gameId, "prize": value},
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