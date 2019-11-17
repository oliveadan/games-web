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
				<li class=""><a href='{{urlfor "VipValueIndexController.get"}}'>会员账号价值列表</a></li>
				<li class="layui-this">添加会员账号价值</li>
			</ul>
			<div class="layui-tab-content">
				<div class="layui-tab-item layui-show">
					<form class="layui-form form-container" action='{{urlfor "VipValueEditController.post"}}' method="post">
						{{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}">
						<div class="layui-form-item">
							<label class="layui-form-label">会员账号</label>
							<div class="layui-input-inline">
								<input type="text" name="Account" value="{{.data.Account}}" required lay-verify="required"
									   placeholder="请输入会员账号" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">VIP等级</label>
							<div class="layui-input-inline">
								<input type="text" name="VipLevel" value="{{.data.VipLevel}}" required lay-verify="required"
									   placeholder="请输入VIP等级" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">注册日期</label>
							<div class="layui-input-inline">
								<input type="text" name="RegisterDate" value="{{date .data.RegisterDate "Y-m-d"}}" placeholder="请输入注册时期"
									   class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">注册天数</label>
							<div class="layui-input-inline">
								<input type="number" name="RegisterDays" value="{{.data.RegisterDays}}" required lay-verify="required"
									   placeholder="请输入注册天数" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">账号价值</label>
							<div class="layui-input-inline">
								<input type="number" name="Value" value="{{.data.Value}}" required
									   placeholder="请输入账号价值" class="layui-input">
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
	layui.use('laydate', function(){
		var laydate = layui.laydate;
		laydate.render({
			elem: 'input[name="RegisterDate"]',
			type: 'datetime'
		});
	});
</script>
</body>
</html>