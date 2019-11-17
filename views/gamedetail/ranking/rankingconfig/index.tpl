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
                <li class="layui-this">投注排行榜配置信息</li>
                <li><a href='{{urlfor "AddRankingConfigController.get"}}'>添加配置</a></li>
            </ul>
            <div class="layui-tab-content">
                <form class="layui-form layui-form-pane form-container"
                      action='{{urlfor "RankingConfigIndexController.get"}}' method="get">
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="gameId">
                            {{range $i, $m := .gameList}}
                                <option value="{{$m.Id}}"
                                        {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                            {{end}}
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select id="type1" name="RankingType" lay-verify="required" lay-filter="ranktypelt">
                                <option value="5" {{if eq 5 .condArr.rankingType}}selected="selected"{{end}}>全部类型
                                </option>
                                <option value="0" {{if eq 0 .condArr.rankingType}}selected="selected"{{end}}>周排行
                                </option>
                                <option value="1" {{if eq 1 .condArr.rankingType}}selected="selected"{{end}}>月排行
                                </option>
                                <option value="2" {{if eq 2 .condArr.rankingType}}selected="selected"{{end}}>幸运榜
                                </option>
                                <option value="3" {{if eq 3 .condArr.rankingType}}selected="selected"{{end}}>总榜
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn">搜索</button>
                    </div>
                </form>
                <hr>
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>榜单类型</th>
                            <th>最小排名</th>
                            <th>最大排名</th>
                            <th>最小有效投注</th>
                            <th>奖品</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .dataList}}
                        <tr>
                            <td>{{if eq 3 $vo.RankingType}}总榜
                                {{else if eq 2 $vo.RankingType}}幸运榜
                                {{else if eq 1 $vo.RankingType}}月榜
                                {{else if eq 0 $vo.RankingType}}周榜
                                {{end}}
                            </td>
                            <td>{{$vo.MinRank}}</td>
                            <td>{{$vo.MaxRank}}</td>
                            <td>{{$vo.EffectiveBetting}}</td>
                            <td>{{$vo.Prize}}</td>
                            <td>
                                <a href='{{urlfor "EditRankingConfigController.get" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-normal layui-btn-mini ">修改</a>
                                <a href='{{urlfor "RankingConfigIndexController.Delone" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
                            </td>
                        </tr>
                        {{else}}
							{{template "sysmanage/aalayout/table-no-data.tpl"}}
						{{end}}
                        </tbody>
                    </table>
                {{template "sysmanage/aalayout/paginator.tpl" .}}
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