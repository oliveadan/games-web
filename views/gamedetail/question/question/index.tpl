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
	            <li class="layui-this">问卷配置</li>
	        </ul>
	        <div class="layui-tab-content" style="width: 800px;">
	            <div class="layui-tab-item layui-show">
					<form class="layui-form" action="">
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">活动名称</label>
	                        <div class="layui-input-block">
								<select id="GameId" lay-verify="required" lay-filter="gameslt" lay-search>
	                               	<option value=""></option>
									{{range $i, $m := .gameList}}
									<option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
					</form>
					<div class="layui-form-item">
                        <label class="layui-form-label">问卷内容</label>
						<div class="layui-input-block">
							<button class="layui-btn layui-btn-small" id="btn-open"><i class="layui-icon">&#xe654;</i>添加题目</button>
						</div>
					</div>
					<div class="layui-form-item">
                        <label class="layui-form-label"></label>
						<div class="layui-input-block">
							<div class="layui-collapse">
							{{range $i, $v := .dataList}}
								{{if eq $v.Pid 0}}
								<div class="layui-colla-item">
									<div class="layui-colla-title" style="height: 100%;">
										<div>
											<input type="hidden" id="question-seq-{{$v.Id}}" value="{{$v.Seq}}">
											<input type="hidden" id="question-content-{{$v.Id}}" value="{{$v.Content}}">
											<input type="hidden" id="question-contenttype-{{$v.Id}}" value="{{$v.ContentType}}">
											<input type="hidden" id="question-required-{{$v.Id}}" value="{{$v.Required}}">
											<span>题目：{{$v.Seq}}、{{$v.Content}}{{if eq $v.Required 1}}<span style="color:red;">（必填）</span>{{else}}（非必填）{{end}}</span>
											<div class="layui-btn-group">
											  	<button class="layui-btn layui-btn-primary layui-btn-mini btn-edit-question" data-qid="{{$v.Id}}">
											    	<i class="layui-icon">&#xe642;</i>
											  	</button>
											  	<a href='{{urlfor "QuestionIndexController.Delone" "id" $v.Id}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-delete">
											    	<i class="layui-icon">&#xe640;</i>
											  	</a>
											</div>
										</div>
										<div>
											<span>{{map_get getQuestionContentTypeMap $v.ContentType}}</span>
											
											{{if eq $v.ContentType 1 2}}
											<button class="layui-btn layui-btn-primary layui-btn-mini btn-add-option" data-pid="{{$v.Id}}"><i class="layui-icon">&#xe654;</i>添加选项</button>
											{{end}}
										</div>
									</div>
									{{if eq $v.ContentType 1 2}}
							    	<div class="layui-colla-content layui-show">
										{{range $j, $v2 := $.dataList}}
											{{if eq $v2.Pid $v.Id}}
											<div style="margin-top: 10px;">{{$v2.Seq}}、{{$v2.Content}}
												<input type="hidden" id="option-seq-{{$v2.Id}}" value="{{$v2.Seq}}">
												<input type="hidden" id="option-content-{{$v2.Id}}" value="{{$v2.Content}}">
												<div class="layui-btn-group">
												  	<button class="layui-btn layui-btn-primary layui-btn-mini btn-edit-option" data-qid="{{$v2.Id}}">
												    	<i class="layui-icon">&#xe642;</i>
												  	</button>
												  	<a href='{{urlfor "QuestionIndexController.Delone" "id" $v2.Id}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-delete">
												    	<i class="layui-icon">&#xe640;</i>
												  	</a>
												</div>
											</div>
											{{end}}
										{{end}}
									</div>
									{{end}}
								</div>
								{{end}}
							{{end}}
							</div>
						</div>
					</div>
	            </div>
	        </div>
	    </div>
	</div>
    <!--底部-->
    {{template "sysmanage/aalayout/footer.tpl" .}}
</div>
<div id="form-edit" style="display:none;padding:20px 20px 0 0;">
	<form  class="layui-form" action='{{urlfor "QuestionController.post"}}' method="post">
		{{ .xsrfdata }}
		<input type="hidden" name="Id" id="formId" value="0">
		<input type="hidden" name="Pid" id="formPid" value="0">
		<input type="hidden" name="GameId" id="formGid" value="0">
		<div class="layui-form-item question-title">
	        <label class="layui-form-label">类型</label>
	        <div class="layui-input-block">
				<select name="ContentType" id="formContentType" lay-verify="required">
					{{range $k, $v := getQuestionContentTypeMap}}
					<option value="{{$k}}">{{$v}}</option>
					{{end}}
                </select>
			</div>
	    </div>
		<div class="layui-form-item">
	        <label class="layui-form-label">排序</label>
	        <div class="layui-input-block">
				<input type="number" id="formSeq" name="Seq" value="" required lay-verify="required" placeholder="请输入序号" class="layui-input">
			</div>
	    </div>
		<div class="layui-form-item">
	        <label class="layui-form-label">内容</label>
	        <div class="layui-input-block">
				<textarea name="Content" id="formContent" required lay-verify="required" placeholder="请输入题目或选项" class="layui-textarea"></textarea>
			</div>
	    </div>
		<div class="layui-form-item question-title">
	        <label class="layui-form-label">是否必填</label>
	        <div class="layui-input-block">
				<input type="checkbox" id="formRequired" name="Required" lay-skin="switch" value="1" lay-text="必填|必填">
			</div>
	    </div>
		<div class="layui-form-item">
            <div class="layui-input-block">
                <button class="layui-btn" lay-submit lay-filter="*">保存</button>
                <button type="reset" class="layui-btn layui-btn-primary btn-cancel">取消</button>
            </div>
        </div>
	</form>
</div>
{{template "sysmanage/aalayout/footjs.tpl" .}}
<script>
layui.use(['form','element','layer'], function(){
	var form = layui.form;
  	var element = layui.element;
	var layer = layui.layer;
	
  	form.on('select(gameslt)', function(data){
		location.href = {{urlfor "QuestionIndexController.Get"}}+"?gameId="+data.value;
	});
	$('.btn-cancel').on('click', function () {
		layer.closeAll('page');
    });
	$('#btn-open').on('click', function () {
		if(!$("#GameId").val()) {
			layer.msg("请选择活动名称！");
			return;
		}
		$("#formGid").val($("#GameId").val());
		$("#formId").val("0");
		$("#formPid").val("0");
		$(".question-title").show();
		layer.open({
	  		type: 1,
			title: '添加题目',
			area: '500px',
	  		content: $('#form-edit'),
			end: function() {
				$('#form-edit').hide();
			}
		});
    });
	$('.btn-add-option').on('click', function () {
		var pid = $(this).attr('data-pid');
		if(!$("#GameId").val()) {
			layer.msg("请选择活动名称！");
			return;
		}
		$("#formGid").val($("#GameId").val());
		$("#formId").val("0");
		$("#formPid").val(pid);
		$(".question-title").hide();
		layer.open({
	  		type: 1,
			title: '添加选项',
			area: '500px',
	  		content: $('#form-edit'),
			end: function() {
				$('#form-edit').hide();
			}
		});
    });
	$('.btn-edit-option').on('click', function () {
		var qid = $(this).attr('data-qid');
		if(!$("#GameId").val()) {
			layer.msg("请选择活动名称！");
			return;
		}
		$("#formId").val(qid);
		$("#formGid").val($("#GameId").val());
		$("#formPid").val(qid);
		$("#formSeq").val($("#option-seq-"+qid).val());
		$("#formContent").val($("#option-content-"+qid).val());
		$(".question-title").hide();
		layer.open({
	  		type: 1,
			title: '添加选项',
			area: '500px',
	  		content: $('#form-edit'),
			end: function() {
				$('#form-edit').hide();
			}
		});
    });
	$('.btn-edit-question').on('click', function () {
		var qid = $(this).attr('data-qid');
		if(!$("#GameId").val()) {
			layer.msg("请选择活动名称！");
			return;
		}
		$("#formId").val(qid);
		$("#formGid").val($("#GameId").val());
		$("#formPid").val(qid);
		$("#formSeq").val($("#question-seq-"+qid).val());
		$("#formContent").val($("#question-content-"+qid).val());
		$("#formContentType").val($("#question-contenttype-"+qid).val());
		$("#formContentType").attr('disabled', true);
		if($("#question-required-"+qid).val() == 1) {
			$("#formRequired").attr('checked', true);
		}
		form.render();
		$(".question-title").show();
		layer.open({
	  		type: 1,
			title: '添加选项',
			area: '500px',
	  		content: $('#form-edit'),
			end: function() {
				$('#form-edit').hide();
			}
		});
    });
	
});
</script>
</body>
</html>