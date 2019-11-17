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
                <li class=""><a href='{{urlfor "UpgradingWeekController.get"}}'>电子金管家配置周信息</a></li>
                <li class="layui-this">修改周信息</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "EditUpgradingWeekController.post"}}'
                          method="post">
                    {{ .xsrfdata }}
                        <input type="text"  name="Id" value="{{.data.Id}}" hidden="hidden"/>
                        <div class="layui-form-item">
                            <label class="layui-form-label">活动名称</label>
                            <div class="layui-input-inline">
                                <select name="GameId" lay-verify="required" lay-search>
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">会员账号</label>
                            <div class="layui-input-block">
                                <input type="text" name="Account"
                                       value="{{.data.Account}}"
                                       required lay-verify="required" placeholder="请输入会员账号"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">投注金度</label>
                            <div class="layui-input-block">
                                <input type="text" name="WeekAmount"
                                       value="{{.data.WeekAmount}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入投注金额" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">期数</label>
                            <div class="layui-input-block">
                                <input type="text" name="Period"
                                       value="{{.data.Period}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入期数" class="layui-input"/>
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