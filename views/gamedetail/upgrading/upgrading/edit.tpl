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
                <li class=""><a href='{{urlfor "UpgradingController.get"}}'>电子金管家总信息</a></li>
                <li class="layui-this">修改电子金管家总信息</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "UpgradingEditController.post"}}'
                          method="post">
                    {{ .xsrfdata }}
                        <input type="hidden" name = "Id" value="{{.data.Id}}">
                        <div class="layui-form-item">
                            <label class="layui-form-label">会员账号</label>
                            <div class="layui-input-block">
                                <input type="text" name="Account" value="{{.data.Account}}" class="layui-input" disabled>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">总投注额</label>
                            <div class="layui-input-block">
                                <input type="text" name="TotalAmount" value="{{.data.TotalAmount}}" placeholder="请输入总投注额" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">当前等级</label>
                            <div class="layui-input-block">
                                <input type="text" name="Level" value="{{.data.Level}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入当前等级" class="layui-input"/>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">累计晋级彩金</label>
                            <div class="layui-input-block">
                                <input type="text" name="TotalGift" value="{{.data.TotalGift}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入累计晋级彩金" class="layui-input"/>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">周俸禄</label>
                                <div class="layui-input-block">
                                    <input type="text" name="MonthAmount" value="{{.data.WeekSalary}}"
                                           onkeyup="this.value=this.value.replace(/\D/g,'')"
                                           required lay-verify="required" placeholder="请输入周俸禄" class="layui-input"/>
                                </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">月俸禄</label>
                            <div class="layui-input-block">
                                <input type="text" name="MonthAmount"  value="{{.data.MonthSalary}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入月俸禄" class="layui-input"/>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">距离晋级需总投注金额</label>
                            <div class="layui-input-block">
                                <input type="text" name="Balance"  value="{{.data.Balance}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入距离晋级需总投注金额" class="layui-input"/>
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