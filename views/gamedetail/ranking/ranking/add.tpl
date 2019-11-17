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
                <li class=""><a href='{{urlfor "RankingIndexController.get"}}'>排行榜信息列表</a></li>
                <li class="layui-this">添加排行榜信息</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "AddRankingController.post"}}'
                          method="post">
                    {{ .xsrfdata }}
                        <div class="layui-form-item">
                            <label class="layui-form-label">活动名称</label>
                            <div class="layui-input-block">
                                <select id="GameId" name="GameId" required lay-verify="required">
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}"
                                            {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">榜单类型</label>
                            <div class="layui-input-block">
                                <select name="RankingType" lay-verify="required" lay-search>
                                    <option value="0">周排行</option>
                                    <option value="1">月排行</option>
                                    <option value="2">幸运榜</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">会员账号</label>
                            <div class="layui-input-block">
                                <input type="text" name="Account" required lay-verify="required" placeholder="请输入账号"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">投注金额</label>
                            <div class="layui-input-block">
                                <input type="text" name="Amount"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入投注金额" class="layui-input">
                            </div>
                        </div>
                      {{/*  <div class="layui-form-item">
                            <label class="layui-form-label">排名</label>
                            <div class="layui-input-block">
                                <input type="text" name="Seq"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入排名" class="layui-input">
                            </div>
                        </div>*/}}
                        <div class="layui-form-item">
                            <label class="layui-form-label">期数/月份</label>
                            <div class="layui-input-block">
                                <input type="text" name="Period"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入期数" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">会员标识</label>
                                <div class="layui-input-block">
                                    <input type="radio" name="RankingFlag" value="0" title="真实" checked>
                                    <input type="radio" name="RankingFlag" value="1" title="虚拟">
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