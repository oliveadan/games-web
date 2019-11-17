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
	            <li class="layui-this">活动列表</li>
	            <li class=""><a href='{{urlfor "GameAddController.get"}}'>添加活动</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "GameIndexController.get"}}' method="get">
					<div class="layui-inline">
						<div class="layui-form-inline">
							<label class="layui-form-label">活动类型</label>
							<div class="layui-input-block">
								<select name="gameType"  id="gametype" lay-filter="gametype" lay-verify="required">
									    <option value="">全部</option>
									{{range $k, $v := getGameTypeMap}}
										<option  value="{{$k}}" {{if eq $k $.gameType}} selected="selected"{{end}}>{{$v}}</option>
									{{end}}
								</select>
							</div>
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
	                        <th style="width:20px;">ID</th>
	                        <th>活动类型</th>
	                        <th>名称</th>
	                        <th>版本</th>
	                        <th style="width:80px;">开始时间</th>
	                        <th style="width:80px;">结束时间</th>
	                        <th>绑定域名</th>
	                        <th style="width:35px;">状态</th>
	                        <th style="width:320px;">操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
		                        <td>{{$vo.Id}}</td>
		                        <td>{{map_get getGameTypeMap $vo.GameType}}</td>
		                        <td>{{$vo.Name}}</td>
		                        <td>{{getGameVersionDetail $vo.GameVersion $vo.GameType}}</td>
		                        <td>{{date $vo.StartTime "Y-m-d H:i:s"}}</td>
		                        <td>{{date $vo.EndTime "Y-m-d H:i:s"}}</td>
		                        <td>{{$vo.BindDomain}}</td>
								<td>{{if eq $vo.Enabled 1}}<span class="layui-badge layui-bg-green">启用</span>{{else}}<span class="layui-badge layui-bg-red">禁用</span>{{end}}</td>
		                        <td>
									{{if eq $vo.Enabled 0}}
									<a href='{{urlfor "GameIndexController.Enabled" "id" $vo.Id}}' class="layui-btn layui-btn-mini ajax-click">启用</a>
									{{else}}
									<a href='{{urlfor "GameIndexController.Enabled" "id" $vo.Id}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-click">禁用</a>
									{{end}}

		                            <a href='{{urlfor "GameEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <a href='{{urlfor "GameIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
									<a href='{{urlfor "GamePeriodIndexController.get" "GameId" $vo.Id}}' class="layui-btn layui-btn-warm layui-btn-mini">配置时间</a>
		                        	<a href='/{{$vo.GameType}}?gid={{$vo.Id}}' target="_blank" class="layui-btn layui-btn-primary layui-btn-mini">预览</a>
		                        	<a href='{{if $vo.BindDomain}}{{$vo.BindDomain}}{{else}}notbinddomain/{{$vo.GameType}}?gid={{$vo.Id}}{{end}}' target="_blank" class="layui-btn layui-btn-primary layui-btn-mini btn-qrcode">二维码</a>
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
<script src="/static/js/jquery.qrcode.min.js"></script>
<script>
layui.use('layer', function(){
    var layer = layui.layer;
	/**
     * 二维码
     */
    $('.btn-qrcode').on('click', function () {
        var _href = $(this).attr('href');
		_href = _href.replace(/notbinddomain/, document.location.host);
		_href = _href.replace("http://", "");
		_href = "http://"+_href;
        layer.open({
			type:1,
			title: false,
			closeBtn: 0,
			shade: 0.8,
			shadeClose: true,
			offset: '200px',
            content: '<div id="qrcode" style="padding: 10px;"></div><div style="margin:10px;">'+_href+'</div>',
			success: function(layero, index){
				jQuery('#qrcode').qrcode(_href);
			}
        });
        return false;
    });
});
</script>
</body>
</html>