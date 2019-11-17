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
                <li class="layui-this">电子金管家总信息</li>
                <li><a id="import" lay-data="{url: '{{urlfor "UpgradingController.Import"}}'}"
                       href='javascript:void(0);'>批量导入</a></li>
            </ul>
            <div class="layui-tab-content">
                <form class="layui-form layui-form-pane form-container" style="max-width: 1500px;"
                      action='{{urlfor "UpgradingController.get"}}' method="get">
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="gameId" lay-verify="required" lay-search>
                            {{range $i, $m := .gameList}}
                                <option value="{{$m.Id}}"
                                        {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                            {{end}}
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="text" name="account" value="{{.condArr.account}}" placeholder="会员账号"
                                   class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="text" name="totalamount" value="{{.condArr.totalamount}}" placeholder="投注金额"
                                   class="layui-input">
                        </div>
                    </div>
                    <!--<div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="text" name="CurrentGift" value="{{.condArr.currentgift}}" placeholder="当期晋级彩金"
                                   class="layui-input">
                        </div>
                    </div> -->
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="checkbox" name="isExport" value="1" lay-skin="switch" lay-text="导出|导出">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn">搜索/导出</button>
                        <!--<a href='{{urlfor "UpgradingController.Delbatch" }}'
                           class="layui-btn layui-btn-danger ajax-batch">删除所有</a> -->
                        <a href='{{urlfor "UpgradingController.CreateTotal" }}'
                           class="layui-btn layui-btn-normal ajax-total ">生成总榜单信息</a>
                        <a href='{{urlfor "UpgradingController.CountWeek" }}'
                           class="layui-btn layui-btn-radius layui-btn-danger ajax-week ">计算周俸禄</a>
                        <a href='{{urlfor "UpgradingController.CountMonth" }}'
                           class="layui-btn layui-btn-radius layui-btn-warm ajax-month ">计算月俸禄</a>
                    </div>
                </form>
                <hr>
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>会员账号</th>
                            <th>日期</th>
                            <th>总投注额</th>
                            <th>当前等级</th>
                            <!--<th>当期晋级彩金</th> -->
                            <th>累计晋级彩金</th>
                            <th>周俸禄</th>
                            <th>月俸禄</th>
                            <th>距离晋级需总投注金额</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .dataList}}
                        <tr>
                            <td>{{$vo.Account}}</td>
                            <td>{{date $vo.ModifyDate "Y-m-d H:i:s"}}</td>
                            <td>{{$vo.TotalAmount}}</td>
                            <td>{{$vo.Level}}</td>
                            <!--<td>{{$vo.CurrentGift}}</td> -->
                            <td>{{$vo.TotalGift}}</td>
                            <td>{{$vo.WeekSalary}}</td>
                            <td>{{$vo.MonthSalary}}</td>
                            <td>{{$vo.Balance}}</td>
                            <td>
                                <a href='{{urlfor "UpgradingEditController.get" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-normal layui-btn-xs ">修改</a>
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
<script>
    layui.use(['layer'], function () {
        var layer = layui.layer;
        //生成总榜信息
        $('.ajax-total').on('click', function () {
            var _href = $(this).attr('href');
            layer.open({
                shade: false,
                content: '确定要生成总榜信息吗？',
                btn: ['确定', '取消'],
                yes: function (index) {
                    $.ajax({
                        url: _href,
                        type: "post",
                        data: $('.layui-form').serialize(),
                        beforeSend: function () {
                            layer.load();
                        },
                        success: function (info) {
                            layer.closeAll('loading');
                            if (info.code === 1) {
                                setTimeout(function () {
                                    location.href = info.url || location.href;
                                }, 1000);
                            }
                            layer.msg(info.msg,{time:5000});
                        },
                        error:function () {
                            layer.closeAll('loading');
                        }
                    });
                    layer.close(index);
                }
            });
            return false;
        });

        //计算周俸禄
        $('.ajax-week').on('click', function () {
            var _href = $(this).attr('href');
            layer.open({
                shade: false,
                content: '确定要计算周俸禄吗？',
                btn: ['确定', '取消'],
                yes: function (index) {
                    $.ajax({
                        url: _href,
                        type: "post",
                        data: $('.layui-form').serialize(),
                        beforeSend: function () {
                            layer.load();
                        },
                        success: function (info) {
                            layer.closeAll('loading');
                            layer.msg(info.msg,{time:5000});
                        },
                        error:function () {
                            layer.closeAll('loading');
                        }
                    });
                    layer.close(index);
                }
            });
            return false;
        });

        //计算月俸禄
        $('.ajax-month').on('click', function () {
            var _href = $(this).attr('href');
            layer.open({
                shade: false,
                content: '确定要计算月俸禄吗？',
                btn: ['确定', '取消'],
                yes: function (index) {
                    $.ajax({
                        url: _href,
                        type: "post",
                        data: $('.layui-form').serialize(),
                        beforeSend: function () {
                            layer.load();
                        },
                        success: function (info) {
                            layer.closeAll('loading');
                            layer.msg(info.msg,{time:5000});
                        },
                        error:function () {
                            layer.closeAll('loading');
                        }
                    });
                    layer.close(index);
                }
            });
            return false;
        });
    })
</script>
</body>
</html>