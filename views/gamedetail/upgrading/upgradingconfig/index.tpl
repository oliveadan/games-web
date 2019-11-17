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
                <li class="layui-this">电子金管家配置</li>
                <li><a href='{{urlfor "AddUpgradingAttribute.get"}}'>添加配置</a></li>
            </ul>
            <div class="layui-tab-content">
                <form class="layui-form layui-form-pane form-container" action='{{urlfor "UpgradingConfigController.get"}}' method="get">
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="gameId" lay-verify="required" lay-search>
                            {{range $i, $m := .gameList}}
                                <option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                            {{end}}
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn">搜索</button>
                        <a href='{{urlfor "IntegralIndexController.Delbatch"}}' class="layui-btn layui-btn-danger layui-btn-small ajax-batch">批量删除</a>
                    </div>
                </form>
                <hr>
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>等级</th>
                            <th>投注金度</th>
                            <th>晋级彩金</th>
                            <th>周俸禄</th>
                            <th>月俸禄</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .dataList}}
                        <tr>
                            <td>{{$vo.Level}}</td>
                            <td>{{$vo.TotalAmount}}</td>
                            <td>{{$vo.LevelGift}}</td>
                            <td>{{$vo.WeekAmount}}</td>
                            <td>{{$vo.MonthAmount}}</td>
                            <td>
                                <a href='{{urlfor "EditUpgradingAttribute.get" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-normal layui-btn-mini ">修改</a>
                                <a href='{{urlfor "UpgradingAttribute.Delone" "id" $vo.Id}}'
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