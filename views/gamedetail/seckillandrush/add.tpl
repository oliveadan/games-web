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
                <li class=""><a href='{{urlfor "SeckillAndRushIndexController.get"}}'>活动展示</a></li>
                <li class="layui-this">绑定秒杀和抢购</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "SeckillAndRushAddController.post"}}' method="post">
                    {{ .xsrfdata }}
                        <div class="layui-form-item">
                            <label class="layui-form-label">秒杀</label>
                            <div class="layui-input-inline">
                                <select name="SeckillId" lay-verify="required" lay-search>
                                {{range $i, $m := .seckills}}
                                    <option value="{{$m.Id}}">{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">网页配置信息取自此活动</div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">抢购活动</label>
                            <div class="layui-input-inline">
                                <select name="RushId" lay-verify="required" lay-search>
                                {{range $i, $m := .rushs}}
                                    <option value="{{$m.Id}}">{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">请选择抢购活动</div>
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