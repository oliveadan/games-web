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
	            <li class=""><a href='{{urlfor "GiftIndexController.get"}}'>奖品列表</a></li>
	            <li class="layui-this">编辑奖品</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "GiftEditController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}" >
						<div class="layui-form-item">
	                        <label class="layui-form-label">活动名称</label>
	                        <div class="layui-input-block">
								<select name="GameId" lay-verify="required" lay-search>
	                               	{{range $i, $m := .gameList}}
									<option value="{{$m.Id}}" {{if eq $m.Id $.data.GameId}}selected="selected"{{end}}>{{$m.Name}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">编号</label>
	                        <div class="layui-input-block">
								<input type="number" name="Seq" value="{{.data.Seq}}" required lay-verify="required" placeholder="请输入编号，必须为数字1-1000000" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">名称</label>
	                        <div class="layui-input-block">
								<input type="text" name="Name" value="{{.data.Name}}" required lay-verify="required" placeholder="请输入名称" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">中奖概率</label>
	                        <div class="layui-input-block">
								<input type="text" name="Probability" value="{{.data.Probability}}" required lay-verify="required" placeholder="请输入中奖概率，必须为数字0-1000000(百万)" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">数量</label>
	                        <div class="layui-input-block">
								<input type="text" name="Quantity" value="{{.data.Quantity}}" required lay-verify="required" placeholder="请输入数量，必须为数字0-1000000" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">奖品类型</label>
	                        <div class="layui-input-block">
								<select name="GiftType" lay-verify="required">
									<option value="1" {{if eq 1 .data.GiftType}}selected="selected"{{end}}>中奖</option>
									<option value="0" {{if eq 0 .data.GiftType}}selected="selected"{{end}}>谢谢参与</option>
	                            </select>
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">大奖广播</label>
	                        <div class="layui-input-inline" style="width: 60px;">
								<input type="checkbox" name="BroadcastFlag" value="1" {{if eq 1 .data.BroadcastFlag}}checked{{end}} lay-skin="switch" lay-text="开启|开启">
							</div>
							<div class="layui-form-mid layui-word-aux">开启大奖广播后，当用户中当前奖时，全部在线用户会收到xxx中大奖弹窗</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">奖品内容</label>
	                        <div class="layui-input-block">
								<input type="text" name="Content" value="{{.data.Content}}" placeholder="请输入奖品内容，金额或其他" class="layui-input">
							</div>
	                    </div>
                        <div class="layui-form-item">
	                        <label class="layui-form-label">奖品图片</label>
	                        <div class="layui-inline" style="width: 48%; margin-bottom: 0px;">
								<input type="hidden" name="Photo" id="Photo" value="{{.data.Photo}}">
								<img src="{{if .data.Photo}}{{.data.Photo}}{{else}}/static/img/noimg.jpg{{end}}" id="imgreview" width="100px" height="100px">
	                            <button type="button" class="layui-btn layui-btn-primary layui-btn-big" id="upphoto">
								  	<i class="layui-icon">&#xe61f;</i>上传图片
								</button>
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