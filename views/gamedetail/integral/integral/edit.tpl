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
	            <li class=""><a href='{{urlfor "IntegralIndexController.get"}}'>会员积分列表</a></li>
	            <li class="layui-this">编辑会员积分</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "IntegralEditController.post"}}' method="post">
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
	                        <label class="layui-form-label">会员账号</label>
	                        <div class="layui-input-block">
								<input type="text" name="Account" value="{{.data.Account}}" placeholder="请输入会员账号" class="layui-input" readonly="readonly">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">当前积分</label>
	                        <div class="layui-input-block">
								<input type="number" value="{{.data.LotteryNums}}" class="layui-input" readonly="readonly">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">增减积分</label>
	                        <div class="layui-input-block">
								<input type="number" name="LotteryNums" value="" placeholder="增加填正数，如：100; 扣减填负数，如：-100" class="layui-input">
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