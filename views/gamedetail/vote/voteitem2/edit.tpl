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
	            <li class=""><a href='{{urlfor "VoteItem2IndexController.get"}}'>选票列表</a></li>
	            <li class="layui-this">编辑选票</li>
	        </ul>
	        <div class="layui-tab-content">
	            <div class="layui-tab-item layui-show">
	                <form class="layui-form form-container" action='{{urlfor "VoteItem2EditController.post"}}' method="post">
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
	                        <label class="layui-form-label">选票名称</label>
	                        <div class="layui-input-block">
								<input type="text" name="Name" value="{{.data.Name}}" required lay-verify="required" placeholder="请输入选票名称" class="layui-input">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">排序</label>
	                        <div class="layui-input-inline">
								<input type="number" name="Seq" value="{{.data.Seq}}" required lay-verify="required" class="layui-input">
							</div>
	                    	<div class="layui-form-mid layui-word-aux">从小到大显示，越小越靠前</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">真实票数</label>
	                        <div class="layui-input-block">
								<input type="number" value="{{.data.NumVote}}" class="layui-input" readonly="readonly">
							</div>
	                    </div>
	                    <div class="layui-form-item">
	                        <label class="layui-form-label">调整票数</label>
	                        <div class="layui-input-inline">
								<input type="number" name="NumAdjust" value="{{.data.NumAdjust}}" class="layui-input">
							</div>
	                    	<div class="layui-form-mid layui-word-aux">可为正数或负数，真实票数+调整票数=总票数</div>
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