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
	            <li class="layui-this">大富翁配置</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "RichAttributeIndexController.post"}}' method="post">
	                    {{ .xsrfdata }}
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">活动名称</label>
	                        <div class="layui-input-block">
								<select id="GameId" name="GameId" lay-verify="required" lay-filter="gameslt" lay-search>
	                               	<option value=""></option>
									{{range $i, $m := .gameList}}
									<option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
						<div class="layui-form-item">
		                    <div class="layui-inline">
		                        <label class="layui-form-label">设置</label>
		                        <div class="layui-input-inline" style="width: 60px;">
									<input type="number" name="unplayday" value="{{map_get .dataMap "unplayday"}}" placeholder="天数" class="layui-input">
								</div>
								<div class="layui-form-mid">天未参加活动，则退</div>
		                        <div class="layui-input-inline" style="width: 60px;">
									<input type="number" name="backstep" value="{{map_get .dataMap "backstep"}}" placeholder="步数" class="layui-input">
								</div>
								<div class="layui-form-mid">步</div>
		                    </div>
						</div>
	                    <div class="layui-form-item" style="margin-bottom: 0;">
	                        <label class="layui-form-label">点数概率</label>
							<div class="layui-form-mid layui-word-aux">
								设置点数 1-6 出现的概率，每个概率可设置 0-100，全部设为 0 则表示概率均等
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label"></label>
	                        <div class="layui-inline" style="width: 60px;">
								<div class="layui-form-mid">点数 1</div>
								<input type="number" name="rate1" value="{{or (map_get .dataMap "rate1") 0}}" required lay-verify="required" class="layui-input">
							</div>
	                        <div class="layui-inline" style="width: 60px;">
								<div class="layui-form-mid">点数 2</div>
								<input type="number" name="rate2" value="{{or (map_get .dataMap "rate2") 0}}" required lay-verify="required" class="layui-input">
							</div>
	                        <div class="layui-inline" style="width: 60px;">
								<div class="layui-form-mid">点数 3</div>
								<input type="number" name="rate3" value="{{or (map_get .dataMap "rate3") 0}}" required lay-verify="required" class="layui-input">
							</div>
	                        <div class="layui-inline" style="width: 60px;">
								<div class="layui-form-mid">点数 4</div>
								<input type="number" name="rate4" value="{{or (map_get .dataMap "rate4") 0}}" required lay-verify="required" class="layui-input">
							</div>
	                        <div class="layui-inline" style="width: 60px;">
								<div class="layui-form-mid">点数 5</div>
								<input type="number" name="rate5" value="{{or (map_get .dataMap "rate5") 0}}" required lay-verify="required" class="layui-input">
							</div>
	                        <div class="layui-inline" style="width: 60px;">
								<div class="layui-form-mid">点数 6</div>
								<input type="number" name="rate6" value="{{or (map_get .dataMap "rate6") 0}}" required lay-verify="required" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">关卡数</label>
	                        <div class="layui-input-block">
								<input type="number" name="totalstage" value="{{map_get .dataMap "totalstage"}}" required lay-verify="required" placeholder="请输入关卡数" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">关卡背景图</label>
							<div class="layui-form-mid layui-word-aux">
								上传关卡背景图时，图片名字必须按命名规则"a或b+关卡"(a表示上半部分,b表示下半部分)来命名，<br>
								如第1关上半部分背景图：a1.jpg，第1关下半部分背景图：b1.jpg<br>
								图片格式要求：上半部分尺寸（1920x630），下半部分尺寸（1920x685）<br>
								未上传背景图的关卡，则使用默认背景图
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label"></label>
							<div class="layui-inline">
	                            <button type="button" class="layui-btn layui-btn-primary layui-btn-big" id="upphoto">
								  	<i class="layui-icon">&#xe61f;</i>上传图片
								</button>
	                        </div>
	                    </div>
	                    <div class="layui-form-item" id="photoreview">
	                        <label class="layui-form-label"></label>
							{{range $k, $v := .photoMap}}
							<div class="layui-inline">
								第{{substr $k 1 ($k|len)}}关{{if eq (substr $k 0 1) "a"}}上{{else}}下{{end}}半部分<br>
								<img src="{{$v}}" id="imgreview{{$k}}" width="100px" height="50px">
	                        </div>
							{{end}}
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
layui.use(['form', 'upload'], function(){
  	var form = layui.form;
	var upload = layui.upload;
   
  	form.on('select(gameslt)', function(data){
		location.href = {{urlfor "RichAttributeIndexController.Get"}}+"?gameId="+data.value;
	});
   
  	var uploadInst = upload.render({
	    elem: '#upphoto',
		data: {isUpload: 'Y', GameId: $("#GameId").val()},
		method: 'post',
		url: '{{urlfor "RichAttributeIndexController.Post"}}',
		before: function(obj){
	    	layer.load(); //上传loading
	  	},
	    done: function(res){
			layer.closeAll('loading');
			layer.msg(res.msg);
			if(res.code==1) {
				var seq = res.data.part+res.data.stage;
				if($("#imgreview"+seq).length > 0) {
					$("#imgreview"+seq).attr("src", res.data.path);
				} else {
					var html = '<div class="layui-inline">'
							+'第'+res.data.stage+'关'+(res.data.part=="a"?"上":"下")+'半部分<br>'
							+'	<img src="'+res.data.path+'" id="imgreview'+seq+'" width="100px" height="50px">'
	                        +'</div>';
					$("#photoreview").append(html);
				}
			}
	    },
	    error: function(){
			layer.closeAll('loading');
			layer.msg("图片上传失败，请重试");
	    }
  	});
});
</script>
</body>
</html>