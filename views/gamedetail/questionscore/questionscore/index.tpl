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
	            <li class="layui-this">问卷(计分版)配置</li>
                <li class=""><a id="import" lay-data="{url: '{{urlfor "QuestionscoreIndexController.Import"}}'}" href='javascript:void(0);'>批量导入</a></li>
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
									<option name="gameid" value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
									{{end}}
	                            </select>
							</div>
	                    </div>
						<div class="layui-form-item">
							<label class="layui-form-label">题目类型</label>
							<div class="layui-input-block">
								<select id="Category" lay-verify="required" lay-filter="category" lay-search>
									<option value="">全部</option>
									<option value="1" {{if eq .category "1"}}selected="selected"{{end}}>彩票</option>
									<option value="2" {{if eq .category "2"}}selected="selected"{{end}}>真人</option>
									<option value="3" {{if eq .category "3"}}selected="selected"{{end}}>电子</option>
									<option value="4" {{if eq .category "4"}}selected="selected"{{end}}>体育</option>
								</select>
							</div>
						</div>
					</form>
					<div class="layui-form-item">
						<label class="layui-form-label">题目数量</label>
						<span style="color:#FF5722; margin-right: 10px;">{{or .quantity "未配置"}}</span>
						<button  id="edittime" class="layui-btn layui-btn-small edit-attr">修改</button>
					</div>
					<div class="layui-form-item">
                        <label class="layui-form-label">问卷内容</label>
						<div class="layui-input-block">
							<button class="layui-btn layui-btn-small" id="btn-open"><i class="layui-icon">&#xe654;</i>添加题目</button>
							<button class="layui-btn layui-btn-small layui-btn-danger" id="btn-batchdell"><i class="layui-icon">&#xe640;</i>批量删除</button>
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
											<input type="hidden" id="question-score-{{$v.Id}}" value="{{$v.Score}}">
											<input type="hidden" id="question-contenttype-{{$v.Id}}" value="{{$v.ContentType}}">
											<input type="hidden" id="question-required-{{$v.Id}}" value="{{$v.Required}}">
											<input type="hidden" id="question-category-{{$v.Id}}" value="{{$v.Category}}">
											<span>题目：ID({{$v.Id}}){{$v.Seq}}、{{$v.Content}}{{if eq $v.Required 1}}<span style="color:red;">（必出）</span>{{else}}（随机出现）{{end}}</span>
											{{if eq $v.Category 1}}<span style="color: #ff2bc3">彩票</span>{{end}}
											{{if eq $v.Category 2}}<span style="color: #ff2bc3">真人</span>{{end}}
											{{if eq $v.Category 3}}<span style="color: #ff2bc3">电子</span>{{end}}
											{{if eq $v.Category 4}}<span style="color: #ff2bc3">体育</span>{{end}}
											<div class="layui-btn-group">
											  	<button class="layui-btn layui-btn-primary layui-btn-mini btn-edit-question" data-qid="{{$v.Id}}">
											    	<i class="layui-icon">&#xe642;</i>
											  	</button>
											  	<a href='{{urlfor "QuestionscoreIndexController.Delone" "id" $v.Id}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-delete">
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
												<span style="color:red;">(分数：{{$v2.Score}})</span>
												<input type="hidden" id="option-seq-{{$v2.Id}}" value="{{$v2.Seq}}">
												<input type="hidden" id="option-content-{{$v2.Id}}" value="{{$v2.Content}}">
												<input type="hidden" id="option-score-{{$v2.Id}}" value="{{$v2.Score}}">
												<div class="layui-btn-group">
												  	<button class="layui-btn layui-btn-primary layui-btn-mini btn-edit-option" data-qid="{{$v2.Id}}">
												    	<i class="layui-icon">&#xe642;</i>
												  	</button>
												  	<a href='{{urlfor "QuestionscoreIndexController.Delone" "id" $v2.Id}}' class="layui-btn layui-btn-primary layui-btn-mini ajax-delete">
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
	<form  class="layui-form" action='{{urlfor "QuestionscoreController.post"}}' method="post">
		{{ .xsrfdata }}
		<input type="hidden" name="Id" id="formId" value="0">
		<input type="hidden" name="Pid" id="formPid" value="0">
		<input type="hidden" name="GameId" id="formGid" value="0">
		<div class="layui-form-item question-title">
	        <label class="layui-form-label">类型</label>
	        <div class="layui-input-block">
				<select name="ContentType" id="formContentType" lay-verify="required">
					<option value="1">单选题</option>
					<option value="2">多选题</option>
                </select>
			</div>
	    </div>
		<div class="layui-form-item question-category">
			<label class="layui-form-label">问题分类</label>
			<div class="layui-input-block">
				<select name="Category" id="formcategory" lay-verify="required">
					<option value="1">彩票</option>
					<option value="2">真人</option>
					<option value="3">电子</option>
					<option value="4">体育</option>
				</select>
			</div>
		</div>
		<div class="layui-form-item">
	        <label class="layui-form-label">排序</label>
	        <div class="layui-input-block">
				<input type="number" id="formSeq" name="Seq" value="" required lay-verify="required" placeholder="请输入序号" class="layui-input">
			</div>
	    </div>

		<div class="layui-form-item question-score">
			<label class="layui-form-label">分数</label>
			<div class="layui-input-block">
				<input name="Score" id="formScore"  placeholder="请输入分数" class="layui-input">
			</div>
		</div>
		<div class="layui-form-item">
	        <label class="layui-form-label">内容</label>
	        <div class="layui-input-block">
				<textarea name="Content" id="formContent" required lay-verify="required" placeholder="请输入题目或选项" class="layui-textarea"></textarea>
			</div>
	    </div>
		<div class="layui-form-item question-title">
	        <label class="layui-form-label">必出</label>
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


	$('#edittime').on('click', function () {
		layer.open({
			type: 1,
			title: '修改题目数量',
			btn: ['保存'],
			content: '<div style="padding: 10px;"><input type="number" id="timeattribute" placeholder="请输入题目数量" class="layui-input"></div>',
			yes: function(index, layero){
				var tb = $("#timeattribute").val();
				if(tb == '' || isNaN(tb)) {
					layer.msg("题目数量不能为空");
					return;
				}
				$.ajax({
					url: {{urlfor "QuestionscoreIndexController.ModifyAttr"}},
					type: "post",
					data: {"quantity":tb,"gid":$("#GameId").val()},
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




  	form.on('select(gameslt)', function(data){
		location.href = {{urlfor "QuestionscoreIndexController.Get"}}+"?gameId="+data.value;
	});
	form.on('select(category)', function(data){
		var gameId = $("#GameId").find("option:selected").attr("value");
		location.href = {{urlfor "QuestionscoreIndexController.Get"}}+"?gameId="+gameId+"&category="+data.value;
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
		$(".question-category").show();
		$(".question-score").hide();
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
	$('#btn-batchdell').on('click', function () {
		if(!$("#GameId").val()) {
			layer.msg("请选择活动名称！");
			return;
		}
		if (!$("#Category").val()) {
			layer.msg("请选择题目类型！");
			return;
		}
		$.ajax({
			url:'{{urlfor "QuestionscoreIndexController.Batchdel"}}',
			type:'post',
			data: {"name":$("#GameId").val(),"category":$("#Category").val()},
			success: function (info) {
				if (info.code === 1) {
					setTimeout(function () {
						location.href = info.url || location.href;
					}, 1000);
				}
				layer.msg(info.msg);
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
		$(".question-category").hide();
		$(".question-score").show();
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
		$("#formScore").val($("#option-score-"+qid).val());
		$(".question-title").hide();
		$(".question-category").hide();
		layer.open({
	  		type: 1,
			title: '修改选项',
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
		$(".question-score").hide();
		$(".question-category").show();
		$("#formId").val(qid);
		$("#formGid").val($("#GameId").val());
		$("#formPid").val(0);
		$("#formSeq").val($("#question-seq-"+qid).val());
		$("#formContent").val($("#question-content-"+qid).val());
		$("#formScore").val($("#question-score-"+qid).val());
		$("#formContentType").val($("#question-contenttype-"+qid).val());
		$("#formcategory").val($("#question-category-"+qid).val());
		if($("#question-required-"+qid).val() == 1) {
			$("#formRequired").attr('checked', true);
		}
		form.render();
		$(".question-title").show();
		layer.open({
	  		type: 1,
			title: '修改题目',
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