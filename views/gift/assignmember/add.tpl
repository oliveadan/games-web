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
	            <li class=""><a href='{{urlfor "AssignMemberIndexController.get"}}'>内定会员列表</a></li>
	            <li class="layui-this">添加内定会员</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "AssignMemberAddController.post"}}' method="post">
	                    {{ .xsrfdata }}
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">活动名称</label>
	                        <div class="layui-input-block">
								<select name="GameId" lay-verify="required" lay-filter="gameslt" lay-search>
	                               	{{range $i, $m := .gameList}}
									<option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">会员账号</label>
	                        <div class="layui-input-block">
								<input type="text" name="Account" value="" placeholder="请输入会员账号" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">奖品</label>
	                        <div class="layui-input-block">
								<select id="giftId" name="GiftId" lay-verify="required" lay-search>
									<option value=""></option>
	                               	{{range $i, $m := .giftList}}
									<option value="{{$m.Id}}">编号：{{$m.Seq}}  名称：{{$m.Name}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <div class="layui-input-block">
	                            <button class="layui-btn" lay-submit lay-filter="*">保存</button>
	                            <button type="reset" class="layui-btn layui-btn-primary">重置</button>
	                        </div>
	                    </div>
	                </form>
	            </div>
	        </div>
	    </div>
	</div>

    <!--底部-->
    {{template "sysmanage/aalayout/footer.tpl" .}}
</div>
{{template "sysmanage/aalayout/footjs.tpl" .}}
<script>
layui.use('form', function(){
  	var form = layui.form;
   
  	form.on('select(gameslt)', function(data){
		$.ajax({
            url: {{urlfor "GiftIndexController.Post"}},
            type: 'POST',
			data: {"gameId":data.value},
            success: function (data) {
                document.getElementById("giftId").options.length=0;
				data.forEach(function (value) {
					document.getElementById("giftId").options.add(new Option(value.Name,value.Id));
				});
				form.render('select');
            }
        });
	});
});
</script>
</body>
</html>