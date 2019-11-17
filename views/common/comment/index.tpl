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
	            <li class="layui-this">评论记录</li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" style="max-width: 1500px;" action='{{urlfor "CommentIndexController.get"}}' method="get">
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
	                        <input type="text" name="shareOut" value="{{.condArr.shareOut}}" placeholder="会员账号" class="layui-input">
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
	                        <th>会员账号</th>
	                        <th>手机</th>
	                        <th>评论内容</th>
							<th>标签</th>
							<th>审核状态</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{getGameName $vo.GameId}}</td>
		                        <td>{{$vo.Account}}</td>
		                        <td>{{$vo.Mobile}}</td>
		                        <td>{{$vo.Content}}</td>
                                <td>{{if eq $vo.Tag 1}}<span class="layui-badge layui-bg-blue">普通</span>
                                {{else if eq $vo.Tag 2}}<span class="layui-badge layui-bg-orange">优秀</span>
                                {{else if eq $vo.Tag 3}}<span class="layui-badge layui-bg-green">精华</span>
                                {{else if eq $vo.Tag 9}}<span class="layui-badge layui-bg-red">置顶</span>
                                {{else if eq $vo.Tag 0}}<span class="layui-badge layui-bg-gray">默认</span>{{end}}</td>
                                <td>{{if eq $vo.Status 1}}<span class="layui-badge layui-bg-blue">审核通过</span>
                                {{else if eq $vo.Status 2}}<span class="layui-badge layui-bg-red">审核拒绝</span>
                                {{else if eq $vo.Status 0}}<span class="layui-badge layui-bg-gray">待审核</span>{{end}}</td>
		                        <td>
                                    <button href='{{urlfor "CommentIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</button>
                                    <button value="{{$vo.Id}}" onclick="getTag(this.value)" class="layui-btn layui-btn-warm layui-btn-mini">标记</button>
                                    <a href='{{urlfor "CommentIndexController.Status" "id" $vo.Id "status" 1}}' class="layui-btn layui-btn-normal layui-btn-mini ajax-click">审核通过</a>
                                    <a href='{{urlfor "CommentIndexController.Status" "id" $vo.Id "status" 2}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-click">审核拒绝</a>
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
    <!--标记窗口 -->
    <div class="tag" style="height: 50px;display: none">
        <br>
        <form class="layui-form" action="">
        <div class="layui-form-item">
            <div class="layui-input-block" >
            <input type="radio" name="tag" value="1" title="普通">
            <input type="radio" name="tag" value="2" title="优秀">
            <input type="radio" name="tag" value="3" title="精华">
            <input type="radio" name="tag" value="9" title="置顶">
            </div>
        </div>
        </form>
    </div>
    <!--底部-->
    {{template "sysmanage/aalayout/footer.tpl" .}}
</div>
{{template "sysmanage/aalayout/footjs.tpl" .}}
<script>
    function getTag(val){
        layer.open({
            type:1,
            shade: false,
            title: '标记',
            area:['300px','200px'],
            content: $('.tag'),
            btn: ['确定', '取消'],
            yes: function (index) {
                $.ajax({
                    url:'{{urlfor "CommentIndexController.Tag"}}',
                    data:{'tag':$("input[name='tag']:checked").val(),'id':val},
                    type:'post',
                    success: function (info) {
                        console.log(info);
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
    };
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