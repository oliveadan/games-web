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
                <li class=""><a href='{{urlfor "RankingConfigIndexController.get"}}'>投注排行榜配置信息</a></li>
                <li class="layui-this">添加配置</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "AddRankingConfigController.post"}}'
                          method="post">
                    {{ .xsrfdata }}
                        <div class="layui-form-item">
                            <label class="layui-form-label">活动名称</label>
                            <div class="layui-input-block">
                                <select id="GameId" name="GameId" lay-verify="required" >
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
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
                                    <option value="3">总榜</option>
                                </select>
                            </div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">最小排名</label>
                            <div class="layui-input-inline">
                                <input type="text" name="MinRank"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入最小排名"
                                       class="layui-input">
                            </div>
                            <label class="layui-form-label">最大排名</label>
                            <div class="layui-input-inline">
                                <input type="text" name="MaxRank"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入最大排名"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">    </label>
                            <div class="layui-input-block">
                                例：如果是第1名，最小排名和最大排名都设置为1<br>
                                   如果是第4到第10，最小排名设置为4最大排名设置为10
                            </div>
                            <div class="layui-form-mid layui-word-aux"></div>
                        </div>


                        <div class="layui-form-item">
                            <label class="layui-form-label">最小投注额</label>
                            <div class="layui-input-inline">
                                <input type="text" name="EffectiveBetting" value="0"
                                       onkeyup="this.value=this.value.replace(/\D/g,'')"
                                       required lay-verify="required" placeholder="请输入最小有效投注" class="layui-input">
                            </div>
                            <div class="layui-form-mid layui-word-aux">会员的投注必须达到最小投注额才能获得奖品，不限制的情况下设置为0</div>
                        </div>

                        <div class="layui-form-item">
                            <label class="layui-form-label">奖品</label>
                            <div class="layui-input-block">
                                <input type="text" name="Prize"
                                       required lay-verify="required" placeholder="请输入奖品"
                                       class="layui-input">
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