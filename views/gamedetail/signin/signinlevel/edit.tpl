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
	            <li class=""><a href='{{urlfor "SigninLevelIndexController.get"}}'>选票列表</a></li>
	            <li class="layui-this">编辑选票</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "SigninLevelEditController.post"}}' method="post">
	                    {{ .xsrfdata }}
						<input type="hidden" name="Id" value="{{.data.Id}}" >
						<div class="layui-form-item">
	                        <label class="layui-form-label">活动名称</label>
	                        <div class="layui-input-block">
								<input type="hidden" name="GameId" value="{{.data.GameId}}">
								<input type="text" value="{{getGameName .data.GameId}}" class="layui-input" readonly="readonly">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">等级</label>
	                        <div class="layui-input-inline">
								<input type="number" name="Level" value="{{.data.Level}}" required lay-verify="required" class="layui-input">
							</div>
	                    	<div class="layui-form-mid layui-word-aux">从小到大排等级，数字越大等级越高</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">等级名称</label>
	                        <div class="layui-input-block">
								<input type="text" name="Name" value="{{.data.Name}}" required lay-verify="required" placeholder="请输入选票名称" class="layui-input">
							</div>
	                    </div>
				        <div class="layui-form-item">
				            <label class="layui-form-label">所需点数</label>
				            <div class="layui-input-inline" style="width: 100px;">
				                <input type="number" name="MinForce" value="{{.data.MinForce}}" required lay-verify="required" class="layui-input">
				            </div>
				            <div class="layui-input-inline" style="width: 10px; line-height: 38px;">
				                -
				            </div>
				            <div class="layui-input-inline" style="width: 100px;">
				                <input type="number" name="MaxForce" value="{{.data.MaxForce}}" required lay-verify="required" class="layui-input">
				            </div>
				            <div class="layui-form-mid layui-word-aux">会员累计点数&gt;=最小点数、且&lt;=最大点数时，升到当前等级。</div>
				        </div>
				        <div class="layui-form-item">
				            <label class="layui-form-label">签到金额</label>
				            <div class="layui-input-inline" style="width: 100px;">
				                <input type="number" name="MinAmount" value="{{.data.MinAmount}}" required lay-verify="required" class="layui-input">
				            </div>
				            <div class="layui-input-inline" style="width: 10px; line-height: 38px;">
				                -
				            </div>
				            <div class="layui-input-inline" style="width: 100px;">
				                <input type="number" name="MaxAmount" value="{{.data.MaxAmount}}" required lay-verify="required" class="layui-input">
				            </div>
				            <div class="layui-form-mid layui-word-aux">会员签到时，获得最小到最大金额之间的随机金额。<span style="color: #FF5722;">注意：单位为元。</span></div>
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