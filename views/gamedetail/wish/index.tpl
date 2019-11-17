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
	            <li class="layui-this">愿望列表</li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" style="max-width: 1500px;" action='{{urlfor "WishIndexController.get"}}' method="get">
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
	                        <select name="orderFild">
								<option value="1" {{if eq "1" $.condArr.orderFild}}selected="selected"{{end}}>按许愿时间降序</option>
								<option value="2" {{if eq "2" $.condArr.orderFild}}selected="selected"{{end}}>按许愿时间升序</option>
								<option value="3" {{if eq "3" $.condArr.orderFild}}selected="selected"{{end}}>按点赞次数降序</option>
                            </select>
	                    </div>
	                </div>
					<div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <select name="enabled">
								<option value="">选择审核状态</option>
								{{range $k, $v := getApprovelMap}}
								<option value="{{$k}}" {{if eq $k $.condArr.enabled}}selected="selected"{{end}}>{{$v}}</option>
								{{end}}
                            </select>
	                    </div>
	                </div>
					<div class="layui-inline">
	                    <div class="layui-input-inline">
	                        <input type="text" name="account" value="{{.condArr.account}}" placeholder="会员账号" class="layui-input">
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
                            <th><input type="checkbox" name="" lay-skin="primary" class="check-all"></th>
                            <th>ID</th>
							<th>活动名称</th>
	                        <th>会员账号</th>
	                        <th style="width: 60px;">手机号</th>
	                        <th style="width: 300px;">愿望内容</th>
	                        <th>点赞次数</th>
	                        <th>审核状态</th>
	                        <th>许愿时间</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
                                <td>
                                    <input type="checkbox" name="checkbox" value="{{$vo.Id}}" lay-skin="primary">
                                </td>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{getGameName $vo.GameId}}</td>
		                        <td>{{$vo.Account}}</td>
		                        <td>{{$vo.Mobile}}</td>
		                        <td>{{$vo.Content}}</td>
		                        <td>{{$vo.Thumbs}}</td>
								<td>{{if eq $vo.Enabled 1}}<span class="layui-badge layui-bg-blue">{{map_get getApprovelMap $vo.Enabled}}</span>{{else if eq $vo.Enabled 2}}<span class="layui-badge layui-bg-red">{{map_get getApprovelMap $vo.Enabled}}</span>{{else if eq $vo.Enabled 3}}<span class="layui-badge layui-bg-green">{{map_get getApprovelMap $vo.Enabled}}</span>{{else}}<span class="layui-badge layui-bg-gray">{{map_get getApprovelMap $vo.Enabled}}</span>{{end}}</td>
		                        <td>{{date $vo.CreateDate "Y-m-d H:i:s"}}</td>
		                        <td>
									<a href='{{urlfor "WishIndexController.Enabled" "id" $vo.Id "enabled" 1}}' class="layui-btn layui-btn-normal layui-btn-mini ajax-click">审核通过</a>
									<a href='{{urlfor "WishIndexController.Enabled" "id" $vo.Id "enabled" 2}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-click">审核拒绝</a>

		                            <a href='{{urlfor "WishIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
		                        	{{if eq $vo.Enabled 1}}
									<a href='javascript:void(0);' data-gameid="{{$vo.GameId}}" data-wishid="{{$vo.Id}}" class="layui-btn layui-btn-mini ajax-reward">派奖</a>
									{{end}}
								</td>
		                    </tr>
						{{else}}
							{{template "sysmanage/aalayout/table-no-data.tpl"}}
						{{end}}
	                    </tbody>
	                </table>
                    <button lay-skin="primary" id="btn5" class="layui-btn layui-btn-normal">通过选中的</button>
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
layui.use(['layer','form'], function(){
  	var layer = layui.layer;
	var form = layui.form;

	$('.ajax-reward').on('click', function () {
		var gameId = $(this).attr('data-gameid');
		var wishId = $(this).attr('data-wishid');
		$.ajax({
            url: {{urlfor "GiftIndexController.Post"}},
            type: 'POST',
			data: {"gameId":gameId},
            success: function (data) {
				var contentDiv = '<form class="layui-form form-container"><select id="giftId" name="GiftId" lay-verify="required" lay-search>';
				data.forEach(function (value) {
					contentDiv = contentDiv + '<option value="'+value.Id+'">编号：'+value.Seq+'  名称：'+value.Name+'</option>'
				});
				contentDiv = contentDiv + '</select></form>';
                layer.open({
					type: 0,
					area: ['300px', '300px'],
		 			content: contentDiv,
		 			btn: ['确定', '取消'],
		 			yes: function(index, layero){
		   				$.ajax({
				            url: {{urlfor "WishIndexController.Reward"}},
				            type: 'POST',
							data: {"wishId":wishId, "giftId": $("#giftId").val()},
							success: function (info) {
								if (info.code === 1) {
				                    setTimeout(function () {
				                        location.href = info.url || location.href;
				                    }, 1000);
				                }
				                layer.msg(info.msg);
							}
						});
		 			}
				});
				form.render('select');
            }
        });
		
	});
});

var layer = layui.layer;
$("#btn5").click(function () {
    var arry = "";
    //获取被选中的checkbox的值
    $("input[name='checkbox']:checkbox:checked").each(function () {
        //arry.push($(this).val());
        //进行字符串拼接
        s = $(this).val() + ",";
        arry += s;
    });
    if (arry === "") {
        layer.open({
            title: '友情提示'
            , content: '没有选中项'
        });
    } else {
        layer.open({
            title: '友情提示',
            content: "确定全部审核通过?",
            btn: ['确定', '取消'],
            yes: function () {
                $.ajax({
                    type: "post",
                    url:{{urlfor "WishIndexController.CheckboxDelone"}},
                    data: {'verify': 100, 'arr': arry},
                    dataType: "json",
                    success: function (data) {
                        if (data.code == 1) {
                            setTimeout(function () {
                                location.href = data.url || location.href;
                            }, 1000);
                            layer.msg(data.msg)
                        } else {
                            layer.msg(data.msg)
                        }
                    }
                })
            }
        })
    }
})
</script>

</body>
</html>