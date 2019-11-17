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
				<li class=""><a href='{{urlfor "MonthsigninBetIndexController.get"}}'>会员投注列表</a></li>
				<li class="layui-this">修改会员投注</li>
			</ul>
			<div class="layui-tab-content">
				<div class="layui-tab-item layui-show">
					<form class="layui-form form-container" action='{{urlfor "MonthsigninBetEditController.post"}}' method="post">
						{{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}" >
						<div class="layui-form-item">
							<label class="layui-form-label">账号</label>
							<div class="layui-input-block">
								<input type="text" name="Account" value="{{.data.Account}}" required lay-verify="required" placeholder="请输入账号" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">会员投注</label>
							<div class="layui-input-block">
								<input type="number" name="Bet" value="{{.data.Bet}}" required lay-verify="required"  placeholder="请输入会员投注" class="layui-input">
							</div>
						</div>
						<div class="layui-form-item">
							<label class="layui-form-label">补签后剩余投注</label>
							<div class="layui-input-block">
								<input type="number" name="SurplusBet" value="{{.data.SurplusBet}}" required lay-verify="required"  placeholder="请输入会员投注" class="layui-input">
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
</body>
</html>