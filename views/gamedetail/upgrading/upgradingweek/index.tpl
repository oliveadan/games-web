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
                <li class="layui-this">电子金管家周信息</li>
                <li><a href='{{urlfor "AddUpgradingWeekController.get"}}'>添加周信息</a></li>
                <li><a id="import" lay-data="{url: '{{urlfor "UpgradingWeekController.Import"}}'}"
                       href='javascript:void(0);'>批量导入</a></li>
            </ul>
            <div class="layui-tab-content">
                <form class="layui-form layui-form-pane form-container" style="max-width: 1500px;"
                      action='{{urlfor "UpgradingWeekController.get"}}' method="get">
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select id="gameid" name="gameId">
                                {{range $i, $m := .gameList}}
                                    <option name="{{$m.Name}}" value="{{$m.Id}}"
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
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="text" name="RiseAmount" value="{{.condArr.riseamount}}" placeholder="晋级彩金"
                                   class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="CountStatus">
                                <option value="" {{if eq "" $.condArr.countstatus}}selected="selected"{{end}} >全部计算状态
                                </option>
                                <option value="1" {{if eq "1" $.condArr.countstatus}}selected="selected"{{end}}>已计算
                                </option>
                                <option value="0" {{if eq "0" $.condArr.countstatus}}selected="selected"{{end}}>未计算
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select id="period" name="Period">
                                <option value="" {{if eq "" $.condArr.currentperiod}}selected="selected"{{end}}>全部期数
                                </option>
                                {{range $i, $m := .periods}}
                                    <option value="{{index $m 0}}"
                                            {{if eq (index $m 0) $.condArr.currentperiod}}selected="selected"{{end}}>{{index $m 1}}</option>
                                {{end}}
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="delivered">
                                <option value="2" {{if eq 2  .condArr.delivered}}selected="selected"{{end}}>全部派送状态
                                </option>
                                <option value="0" {{if eq 0 .condArr.delivered}}selected="selected"{{end}}>未派送</option>
                                <option value="1" {{if eq 1 .condArr.delivered}}selected="selected"{{end}}>已派送</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="checkbox" name="isExport" value="1" lay-skin="switch" lay-text="导出|导出">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn">搜索/导出</button>
                        <a href='{{urlfor "UpgradingWeekController.Deliveredbatch"}}'
                           class="layui-btn layui-btn-small ajax-batch">批量标记派送</a>

                        <a href='{{urlfor "UpgradingWeekController.Delbatch" }}'
                           class="layui-btn layui-btn-danger ajax-batch">删除所有</a>
                        <a href='{{urlfor  "UpgradingWeekController.CountGift" }}'
                           class="layui-btn layui-btn-normal ajax-create1">计算晋级彩金</a>
                    </div>
                </form>
                <hr>
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>期数</th>
                            <th>会员账号</th>
                            <th>投注金额</th>
                            <th>晋级彩金</th>
                            <th>是否计算</th>
                            <th>是否派送</th>
                            <th>派送时间</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .dataList}}
                            <tr>
                                <td>{{$vo.Period}}</td>
                                <td>{{$vo.Account}}</td>
                                <td>{{$vo.WeekAmount}}</td>
                                <td>{{$vo.RiseAmount}}</td>
                                <td>{{if eq 0 $vo.CountEnable}}否{{else}}是{{end}}</td>
                                <td>{{if eq $vo.Delivered 1}}<span class="layui-badge layui-bg-green">已派送</span>{{else}}
                                        <span class="layui-badge layui-bg-red">未派送</span>{{end}}</td>
                                <td>{{date $vo.DeliveredTime "Y-m-d H:i:s"}}</td>
                                <td>
                                    {{/* <a href='{{urlfor "EditUpgradingWeekController.get" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-normal layui-btn-mini ">修改</a>*/}}
                                    <a href='{{urlfor "UpgradingWeekController.Delone" "id" $vo.Id}}'
                                       class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</a>
                                    {{if eq $vo.Delivered 0}}
                                        <a href='{{urlfor "UpgradingWeekController.Delivered" "id" $vo.Id "delivered" 1}}'
                                           class="layui-btn layui-btn-mini ajax-click">标记派送</a>
                                    {{else}}
                                        <a href='{{urlfor "UpgradingWeekController.Delivered" "id" $vo.Id "delivered" 0}}'
                                           class="layui-btn layui-btn-primary layui-btn-mini ajax-click">取消派送</a>
                                    {{end}}
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
        $('.ajax-create1').on('click', function () {
            var _href = $(this).attr('href');
            var gamename = $("#gameid").find("option:selected").attr("name");
            var period = $("#period").find("option:selected").attr("value");
            if (period == "") {
                layer.msg("请选择具体的期数/月份进行生成");
            } else {
                layer.open({
                    shade: false,
                    content: '将根据：' + gamename + ',期数：' + period + ',生成晋级彩金.',
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
                                layer.msg(info.msg);
                            },
                            error: function () {
                                layer.closeAll('loading');
                            }
                        });
                        layer.close(index);
                    }
                });
            }
            return false;
        });
    })
</script>
</body>
</html>