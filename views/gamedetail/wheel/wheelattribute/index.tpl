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
	            <li class="layui-this">大转盘配置</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "WheelAttributeIndexController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<div class="layui-form-item">
	                        <label class="layui-form-label">活动名称</label>
	                        <div class="layui-input-block">
								<select id="GameId" name="GameId" lay-verify="required" lay-filter="gameslt" lay-search>
	                               	{{range $i, $m := .gameList}}
									<option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
                        <div class="layui-form-item">
	                        <label class="layui-form-label">转盘图片</label>
	                        <div class="layui-inline" style="margin-bottom: 0px;">
								<input type="hidden" name="Value" id="Photo" value="{{.attr.Value}}">
								<img src='{{or .attr.Value "/static/img/noimg.jpg"}}' id="imgreview" width="100px" height="100px">
	                            <button type="button" class="layui-btn layui-btn-primary layui-btn-big" id="upphoto">
								  	<i class="layui-icon">&#xe61f;</i>上传图片
								</button>
								示例图：<img src="/static/front/wheel/images/turntable.png" id="imgreview" width="100px" height="100px">
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
layui.use('upload', function(){
  	var upload = layui.upload;
   
  	var uploadInst = upload.render({
	    elem: '#upphoto',
		url: '{{urlfor "SyscommonController.Upload"}}',
		before: function(obj){
	    	layer.load(); //上传loading
	  	},
	    done: function(res){
			layer.closeAll('loading');
			if(res.code==0) {
				$("#Photo").val(res.data.src);
				$("#imgreview").attr("src", res.data.src);
				layer.msg(res.msg);
			} else {
				layer.msg(res.msg);
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