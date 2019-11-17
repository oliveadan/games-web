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
                <li class=""><a href='{{urlfor "BoxIndexController.get"}}'>活动展示</a></li>
                <li class="layui-this">绑定宝箱</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "BoxAddController.post"}}' method="post">
                    {{ .xsrfdata }}
                        <div class="layui-form-item">
                            <label class="layui-form-label">宝箱活动</label>
                            <div class="layui-input-inline">
                                <select name="GameId" lay-verify="required" lay-search>
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}">{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">网页配置信息取自此活动</div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">青铜宝箱</label>
                            <div class="layui-input-inline">
                                <select name="BronzeboxId" lay-verify="required" lay-search>
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}">{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">请选择对应的青铜宝箱活动</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">白银宝箱</label>
                            <div class="layui-input-inline">
                                <select name="SilverboxId" lay-verify="required" lay-search>
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}">{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">请选择对应的白银宝箱活动</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">黄金宝箱</label>
                            <div class="layui-input-inline">
                                <select name="GoldboxId" lay-verify="required" lay-search>
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}">{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">请选择对应的黄金宝箱活动</div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">至尊宝箱</label>
                            <div class="layui-input-inline">
                                <select name="ExtremeboxId" lay-verify="required" lay-search>
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}">{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                            <div class="layui-form-mid layui-word-aux">请选择对应的至尊宝箱活动</div>
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