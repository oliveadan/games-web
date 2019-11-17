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
	            <li class="layui-this">签到等级列表</li>
	            <li class=""><a href='{{urlfor "SigninLevelAddController.get"}}'>添加等级</a></li>
	        </ul>
	        <div class="layui-tab-content">
				<form class="layui-form layui-form-pane form-container" action='{{urlfor "SigninLevelIndexController.get"}}' method="get">
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
					当前活动：{{getGameName .searchGid}}<br>
					每次签到获得点数：<span style="color:#FF5722; margin-right: 10px;">{{or (map_get .attrMap "signinper") "未配置"}}</span>
					点数单位：<span style="color:#FF5722; margin-right: 10px;">{{or (map_get .attrMap "signinunit") "未配置"}}</span>
					<button data-gid="{{.searchGid}}" class="layui-btn layui-btn-normal layui-btn-mini edit-attr">修改</button>
					<span class="layui-word-aux">点数单位可自定义个性化名称，如：积分、原力、查克拉；会员签到时显示：获得2查克拉。</span><br>
                    <img src="{{or .careupimg "/static/img/noimg.jpg"}}" id="imgreview" width="200px" height="100px">
                    <button data-gid="{{.searchGid}}" class="layui-btn layui-btn-normal layui-btn-mini img-attr">上传瓜分图片</button>
                    <span class="layui-word-aux">用于瓜分页面展示</span><br>
				</div>
				<hr>
	            <div class="layui-tab-item layui-show">
	                <table class="layui-table">
	                    <thead>
	                    <tr>
	                        <th>等级</th>
	                        <th>等级名称</th>
	                        <th>所需点数</th>
	                        <th>签到金额(元)</th>
	                        <th>更新时间</th>
	                        <th>操作</th>
	                    </tr>
	                    </thead>
	                    <tbody>
						{{range $index, $vo := .dataList}}
						    <tr>
								<td>{{$vo.Level}}</td>
		                        <td>{{$vo.Name}}</td>
		                        <td>{{$vo.MinForce}} - {{$vo.MaxForce}}</td>
		                        <td>{{$vo.MinAmount}} - {{$vo.MaxAmount}}</td>
								<td>{{date $vo.ModifyDate "Y-m-d H:i:s"}}</td>
								<td>
		                            <a href='{{urlfor "SigninLevelEditController.get" "id" $vo.Id}}' class="layui-btn layui-btn-normal layui-btn-mini">编辑</a>
		                            <button href='{{urlfor "SigninLevelIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</button>
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
    layui.use(['layer','upload'],function(){

        var upload = layui.upload;
		$('.edit-attr').on('click', function () {
            var gameId = $(this).attr('data-gid');
			layer.open({
				type: 1,
				title: '修改签到点数和单位',
				btn: ['保存'],
				content: '<div style="padding: 10px;"><input type="text" id="signinper" placeholder="请输入每次签到获得点数" class="layui-input"><br><input type="text" id="signinunit" placeholder="请输入点数单位" class="layui-input"></div>',
				yes: function(index, layero){
					var per = $("#signinper").val();
					var unit = $("#signinunit").val();
					if(per == '' || isNaN(per)) {
                    	layer.msg("签到获得点数不能为空，且必须为数字")
						return;
					}
					if(unit=='') {
                    	layer.msg("点数单位不能为空")
						return;
					}
	                $.ajax({
	                    url: {{urlfor "SigninLevelIndexController.ModifyAttr"}},
	                    type: "post",
						data: {"gid": gameId, "per": per, "unit": unit},
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


        $('.img-attr').on('click', function () {
            var gameId = $(this).attr('data-gid');
             layer.open({
                 type:1,
                 title: '上传瓜分图片',
                 btn: ['保存'],
                 content:'\t<div class="layui-inline" style="margin-bottom: 0px;">\n' +
                 '<input type="hidden" name="Value" id="Photo" value="">\n' +
                 '<img src=\'{{or .attr.Value "/static/img/noimg.jpg"}}\' id="imgreview" width="100px" height="100px">\n'+'<br>'+
                 '\t<button type="button" class="layui-btn layui-btn-primary layui-btn-big" id="upphoto">\n' +
                 '<i class="layui-icon">&#xe61f;</i>上传图片</button>\n',
                 yes: function(index, layero){
                     $.ajax({
                         url: {{urlfor "SigninLevelIndexController.UplodImg"}},
                         type: "post",
                         data: {"gid": gameId,'imgsrc':$("#Photo").val()},
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
             //图片上传
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

    });
</script>
</body>
</html>