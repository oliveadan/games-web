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
                <li class=""><a href='{{urlfor "UpgradingAttribute.get"}}'>金管家配置</a></li>
                <li class="layui-this">添加配置</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "EditUpgradingAttribute.post"}}'
                          method="post">
                    {{ .xsrfdata }}
                        <input type="text" name="Id" value="{{.data.Id}}"  hidden="hidden"/>
                        <div class="layui-form-item">
                            <label class="layui-form-label">活动名称</label>
                            <div class="layui-input-block">
                                <input name="GameId" value="{{.data.GameId}}" hidden="hidden"/>
                                <input type="text"  value="{{getGameName .data.GameId}}"
                                       readonly="readonly"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">等级</label>
                            <div class="layui-input-block">
                                <input type="text" name="Level"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       value="{{.data.Level}}"
                                       required lay-verify="required" placeholder="请输入当前等级"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">投注金度</label>
                            <div class="layui-input-block">
                                <input type="text" name="TotalAmount"
                                       value="{{.data.TotalAmount}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入投注金额" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">晋级彩金</label>
                            <div class="layui-input-block">
                                <input type="text" name="LevelGift"
                                       value="{{.data.LevelGift}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入晋级彩金" class="layui-input"/>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">周俸禄</label>
                            <div class="layui-input-block">
                                <input type="text" name="WeekAmount"
                                       value="{{.data.WeekAmount}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入周俸禄" class="layui-input"/>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">月俸禄</label>
                                <div class="layui-input-block">
                                    <input type="text" name="MonthAmount"
                                           value="{{.data.MonthAmount}}"
                                           onkeyup="this.value=this.value.replace(/\D/g,'')"
                                           required lay-verify="required" placeholder="请输入月俸禄" class="layui-input"/>
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