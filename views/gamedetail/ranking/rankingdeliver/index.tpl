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
                <li class="layui-this">投注排行榜派奖页</li>
            </ul>
            <div class="layui-tab-content">
                <form class="layui-form layui-form-pane form-container" style="max-width: 1500px;"
                      action='{{urlfor "RankingDeliverIndexController.get"}}' method="get">
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select id="gameid" name="gameId" lay-verify="required">
                            {{range $i, $m := .gameList}}
                                <option name="{{$m.Name}}" value="{{$m.Id}}"
                                        {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                            {{end}}
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select id="type1" name="RankingType" lay-filter="ranktypelt" lay-verify="required">
                                <option name="周排行" value="0" {{if eq 0 .condArr.rankingType}}selected="selected"{{end}}>周排行</option>
                                <option name="月排行" value="1" {{if eq 1 .condArr.rankingType}}selected="selected"{{end}}>月排行</option>
                                <option name="幸运榜" value="2" {{if eq 2 .condArr.rankingType}}selected="selected"{{end}}>幸运榜</option>
                                <option name="总榜" value="3" {{if eq 3 .condArr.rankingType}}selected="selected"{{end}}>总榜</select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select id="period" name="Period" lay-verify="required" {{if eq "3" .rankingtype}} style="display: none"{{end}}>
                                <option   value="" {{if eq ""  .condArr.currentPeriod}}selected="selected"{{end}}>全部期数/月份</option>
                             {{range $i, $m := .periods}}
                                <option value="{{index $m 0}}" {{if eq (index $m 0)  $.condArr.currentPeriod}}selected="selected"{{end}}>{{index $m 1}}</option>
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
                            <input type="text" name="amount" value="{{.condArr.amount}}" placeholder="投注金额"
                                   class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="RankingFlag"  >
                                <option value=" " {{if eq  ""  .condArr.rankingflag}}selected="selected"{{end}}>全部标识</option>
                                <option value="0" {{if eq "0" .condArr.rankingflag}}selected="selected"{{end}}>真实</option>
                                <option value="1" {{if eq "1" .condArr.rankingflag}}selected="selected"{{end}}>虚拟</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="delivered">
                                <option value="2" {{if eq 2 .condArr.delivered}}selected="selected"{{end}}>全部派送状态</option>
                                <option value="0" {{if eq 0 .condArr.delivered}}selected="selected"{{end}}>未派送</option>
                                <option value="1" {{if eq 1 .condArr.delivered}}selected="selected"{{end}}>已派送</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <input type="checkbox" name="isExport" value="1" lay-skin="switch" lay-text="导出|导出"/>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn">搜索/导出</button>
                        <button href='{{urlfor "RankingIndexController.Delbatch" }}'
                                class="layui-btn layui-btn-danger layui-btn-small ajax-batch">删除所有</button>
                        <button href='{{urlfor "RankingDeliverIndexController.Deliveredbatch"}}'
                           class="layui-btn layui-btn-small ajax-batch">批量标记派送</button>
                        <button href='{{urlfor "RankingDeliverIndexController.CreateDelivered" }}'
                           class="layui-btn layui-btn-small layui-btn-normal ajax-create">生成派奖信息</button>
                        <button href='{{urlfor "RankingDeliverIndexController.CreateTotal" }}'
                           class="layui-btn layui-btn-small  layui-btn-normal ajax-total">生成总榜派奖信息</button>
                    </div>
                </form>
                <hr>
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th>期数/月份</th>
                            <th>会员账号</th>
                            <th>有效投注</th>
                            <th>排名</th>
                            <th>奖品</th>
                            <th>会员标识</th>
                            <th>是否派送</th>
                            <th>派送时间</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .List}}
                        <tr>
                            <td>{{if eq 1 $vo.RankingType}}{{$vo.Period}}{{"月份"}}{{else}}{{$vo.PeriodString}}{{end}}</td>
                            <td>{{$vo.Account}}</td>
                            <td>{{$vo.Amount}}</td>
                            <td>{{$vo.Seq}}</td>
                            <td>{{$vo.Prize}}</td>
                            <td>{{if eq 0 $vo.RankingFlag}}真实{{else}}<font color="red">虚拟</font>{{end}}</td>
                            <td>{{if eq $vo.Delivered 1}}<span class="layui-badge layui-bg-green">已派送</span>{{else}}
                                <span class="layui-badge layui-bg-red">未派送</span>{{end}}</td>
                            <td>{{date $vo.DeliveredTime "Y-m-d H:i:s"}}</td>
                            <td>
                            {{/*<a href='{{urlfor "EditRankingController.get" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-normal layui-btn-mini ">修改</a>*/}}
                                <button href='{{urlfor "RankingIndexController.Delone" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</button>
                            {{if eq $vo.Delivered 0}}
                                <button href='{{urlfor "RankingDeliverIndexController.Delivered" "id" $vo.Id "delivered" 1}}'
                                   class="layui-btn layui-btn-mini ajax-click">标记派送</button>
                            {{else}}
                                <button href='{{urlfor "RankingDeliverIndexController.Delivered" "id" $vo.Id "delivered" 0}}'
                                   class="layui-btn layui-btn-primary layui-btn-mini ajax-click">取消派送</button>
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
</body>
<script>
    layui.use(['layer'], function () {
        $('.ajax-create').on('click', function () {
            var layer = layui.layer;
            var _href = $(this).attr('href');
            var gamename = $("#gameid").find("option:selected").attr("name");
            var type = $("#type1").find("option:selected").attr("name");
            var period = $("#period").find("option:selected").attr("value");
            if (period == 0){
                layer.msg("请选择具体的期数/月份进行生成");
            }else{
                layer.open({
                    shade: false,
                    content: '将根据：' + gamename + ',' + type + ',期数/月份：' + period + ',生成派奖信息.',
                    btn: ['确定', '取消'],
                    yes: function (index) {
                        $.ajax({
                            url: _href,
                            type: "post",
                            data: $('.layui-form').serialize(),
                            before:layer.msg("计算中……，并不是卡了请耐心等待~",{time:false}),
                            success: function (info) {
                                if (info.code === 1) {
                                    setTimeout(function () {
                                        location.href = info.url || location.href;
                                    }, 1000);
                                }
                                layer.msg(info.msg);
                            }
                        });
                        layer.close(index);
                    }
                });
            }
            return false;
        });
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
                        before:layer.msg("计算中……，并不是卡了请耐心等待~",{time:false}),
                        success: function (info) {
                            if (info.code === 1) {
                                setTimeout(function () {
                                    location.href = info.url || location.href;
                                }, 1000);
                            }
                            layer.msg(info.msg);
                        }
                    });
                    layer.close(index);
                }
            });
            return false;
        });
        //select 联动
        var form = layui.form;
        form.on('select(ranktypelt)', function(data){
            var gameid = $("#gameid").find("option:selected").attr("value");
            $.ajax({
                url: {{urlfor "RankingDeliverIndexController.Post"}},
                type: 'POST',
                data: {"ranktype":data.value,"gameid":gameid},
                success: function (data) {
                    document.getElementById("period").options.length=0;
                    document.getElementById("period").options.add(new Option("全部期数/月份"," "));
                    data.forEach(function (value) {
                        document.getElementById("period").options.add(new Option(value[1],value[0]));
                    });
                    /* $.each(data,function(key,values){
                         document.getElementById("period").options.add(new Option(values,key));
                         console.log(key);
                         console.log(values)
                     });*/
                    form.render('select');
                }
            });
        });
    })
</script>
</html>