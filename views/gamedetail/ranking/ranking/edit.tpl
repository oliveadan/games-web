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
                <li class="layui-this">修改排行榜信息</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "EditRankingController.get"}}'
                          method="post">
                    {{ .xsrfdata }}
                        <input name="Id" value="{{.data.Id}}" hidden/>
                        <div class="layui-form-item">
                            <label class="layui-form-label">活动名称</label>
                            <div class="layui-input-block">
                                <input type="text" name="" value="{{getGameName .data.GameId}}"
                                       class="layui-input" readonlyr>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">榜单类型</label>
                            <div class="layui-input-block">
                                <select name="RankingType" lay-verify="required" lay-search>
                                    <option value="0" {{if eq 0 .data.RankingType}} selected="selected" {{end}}>周排行</option>
                                    <option value="1" {{if eq 1 .data.RankingType}} selected="selected" {{end}}>月排行</option>
                                    <option value="2" {{if eq 2 .data.RankingType}} selected="selected" {{end}}>幸运榜</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">会员账号</label>
                            <div class="layui-input-block">
                                <input type="text" name="Account" required lay-verify="required" placeholder="请输入账号"
                                       value="{{.data.Account}}"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">投注金额</label>
                            <div class="layui-input-block">
                                <input type="text" name="Amount"
                                       value="{{.data.Amount}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入投注金额" class="layui-input">
                            </div>
                        </div>
                    {{/*    <div class="layui-form-item">
                            <label class="layui-form-label">排名</label>
                            <div class="layui-input-block">
                                <input type="text" name="Seq"
                                       value="{{.data.Seq}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入排名" class="layui-input">
                            </div>
                        </div>*/}}
                        <div class="layui-form-item">
                            <label class="layui-form-label">期数/月份</label>
                            <div class="layui-input-block">
                                <input type="text" name="Period"
                                       value="{{.data.Period}}"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入排名" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">会员标识</label>
                                <div class="layui-input-block">
                                    <input type="radio" name="RankingFlag" value="0" title="真实会员" {{if eq 0 .data.RankingFlag}}checked="checked"{{end}}>
                                    <input type="radio" name="RankingFlag" value="1" title="虚拟会员" {{if eq 1 .data.RankingFlag}}checked="checked"{{end}}>
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