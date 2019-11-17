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
                <li class="layui-this">活动展示</li>
                <li class=""><a href='{{urlfor "BoxAddController.get"}}'>添加绑定</a></li>
            </ul>
            <hr>
            <div style="margin: 0 5px;">
                宝箱活动说明：<br>
                <span style="color: red">
                    1.需要创建5个宝箱活动,4个宝箱分别对应四个活动。网页配置信息取另外一个活动信息。<br>
                    2.请确保5个活动的活动时间一致，并且全部开启。否则无法正常抽奖。<br>
                    3.次数导入，请根据宝箱对应的活动依次导入。<br>
                    4.中奖记录，请根据宝箱对应的活动依次查看。
                </span>

            </div>
            <hr>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>宝箱活动</th>
                            <th>青铜宝箱</th>
                            <th>白银宝箱</th>
                            <th>黄金宝箱</th>
                            <th>至尊宝箱</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .boxList}}
                        <tr>
                            <td>{{$vo.Id}}</td>
                            <td>{{getGameName $vo.GameId}}</td>
                            <td>{{getGameName $vo.BronzeboxId}}</td>
                            <td>{{getGameName $vo.SilverboxId}}</td>
                            <td>{{getGameName $vo.GoldboxId}}</td>
                            <td>{{getGameName $vo.ExtremeboxId}}</td>
                            <td>
                                <a href='{{urlfor "BoxIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
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