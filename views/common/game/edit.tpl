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
	            <li class=""><a href='{{urlfor "GameIndexController.get"}}'>活动列表</a></li>
	            <li class="layui-this">编辑活动</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "GameEditController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}" >
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">活动类型</label>
	                        <div class="layui-input-block">
								<select name="GameType"  id="gametype"  lay-filter="gametype" lay-verify="required">
	                               	{{range $k, $v := getGameTypeMap}}
									<option value="{{$k}}" {{if eq $k $.data.GameType}}selected="selected"{{end}}>{{$v}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
						<div class="layui-form-item">
							<label class="layui-form-label">版本</label>
							<div class="layui-input-block">
								<select name="GameVersion" id="gameversion" lay-verify="required">
									{{range $i,$v := .gameversions }}
									<option {{if eq $i $.version}} selected="selected"{{end}} value="{{index $v 0}}">{{$v}}</option>
								    {{end}}
								</select>
							</div>
						</div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">名称</label>
	                        <div class="layui-input-block">
								<input type="text" name="Name" value="{{.data.Name}}" required lay-verify="required" placeholder="请输入名称" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">描述</label>
	                        <div class="layui-input-block">
								<input type="text" name="Description" value="{{.data.Description}}" placeholder="可空，显示在网站标题" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">绑定域名</label>
	                        <div class="layui-input-block">
								<input type="text" name="BindDomain" value="{{.data.BindDomain}}" placeholder="可空，格式：baidu.com" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">开始时间</label>
	                        <div class="layui-input-block">
								<input type="text" name="StartTime" value="{{date .data.StartTime "Y-m-d H:i:s"}}" placeholder="开始时间" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">结束时间</label>
	                        <div class="layui-input-block">
								<input type="text" name="EndTime" value="{{date .data.EndTime "Y-m-d H:i:s"}}" placeholder="结束时间" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">公告</label>
	                        <div class="layui-input-block">
								<textarea rows="5" name="Announcement" placeholder="" class="layui-textarea">{{.data.Announcement}}</textarea>
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">活动规则</label>
	                        <div class="layui-input-block" style="margin-left: 122px;">
                                <script id="gameRuleEditor" name="GameRule" type="text/plain">
									{{str2html .data.GameRule}}
								</script>
							</div>
	                    </div>
						<div class="layui-form-item">
	                        <label class="layui-form-label">免责声明</label>
	                        <div class="layui-input-block" style="margin-left: 122px;">
                                <script id="gameStatementEditor" name="GameStatement" type="text/plain">
									{{str2html .data.GameStatement}}
								</script>
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
<script type="text/javascript" src="/static/ueditor/ueditor.config.js"></script>
<script type="text/javascript" src="/static/ueditor/ueditor.all.js"></script>
<script>
    layui.use(['form','laydate'], function(){
        var form = layui.form;
        var laydate = layui.laydate;

        laydate.render({
            elem: 'input[name="StartTime"]',
            type: 'datetime'
        });
        laydate.render({
            elem: 'input[name="EndTime"]',
            type: 'datetime'
        });

        var ue1 = UE.getEditor('gameRuleEditor', {
            serverUrl: '{{urlfor "SysUeditorController.Action"}}'
		});
        var ue2 = UE.getEditor('gameStatementEditor', {
            serverUrl: '{{urlfor "SysUeditorController.Action"}}'
        });

        //select 联动
        var form = layui.form;
        form.on('select(gametype)', function(data){
            var gameid = $("#gametype").find("option:selected").val();
            var maps = {{getGameVersion }};
            var gameversions = maps[gameid];

            document.getElementById("gameversion").options.length=0;

            if(gameversions.length<=1){
                document.getElementById("gameversion").options.add(new Option("1"));
            }else{
                for(var i=0;i<gameversions.length;i++){
                    document.getElementById("gameversion").options.add(new Option(i+1+"-"+gameversions[i],i+1));
                }
            }
            form.render('select');
        });
    });
</script>
</body>
</html>
