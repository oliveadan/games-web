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
                <li class=""><a href='{{urlfor "SeckillAndRushAddController.get"}}'>添加绑定</a></li>
            </ul>
            <hr>
            <div style="margin: 0 5px;">
                秒杀和抢购活动说明：<br>
                <span style="color: red">
                    1.分别创建和秒杀和抢购活动<br>
                    2.进行活动绑定<br>
                    3.次数导入，请根据对应的活动依次导入。<br>
                    4.中奖记录，请根据对应的活动依次查看。<br>
                    5.注意：页面配置信息取自秒杀活动
                </span>

            </div>
            <hr>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>秒杀</th>
                            <th>抢购</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .seckillandrush}}
                        <tr>
                            <td>{{$vo.Id}}</td>
                            <td>{{getGameName $vo.SeckillId}}</td>
                            <td>{{getGameName $vo.RushId}}</td>
                            <td>
                                <a href='{{urlfor "SeckillAndRushIndexController.Delone" "id" $vo.Id}}' class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
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