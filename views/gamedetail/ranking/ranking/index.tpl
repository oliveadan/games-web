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
                <li class="layui-this">投注排行榜</li>
                <li><a href='{{urlfor "AddRankingController.post"}}'>添加排行榜信息</a></li>
                <li><a id="import" lay-data="{url: '{{urlfor "RankingIndexController.Import"}}'}"
                       href='javascript:void(0);'>批量导入</a></li>
            </ul>
            <div class="layui-tab-content">
                <form class="layui-form layui-form-pane form-container" style="max-width: 1500px;"
                      action='{{urlfor "RankingIndexController.get"}}' method="get">
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select name="gameId" id="gameid">
                            {{range $i, $m := .gameList}}
                                <option value="{{$m.Id}}" {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                            {{end}}
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">

                            <select id="type1" name="RankingType" lay-verify="required" lay-filter="ranktypelt">
                                <option value="0" {{if eq 0 .condArr.rankingType}}selected="selected"{{end}}>周排行
                                </option>
                                <option value="1" {{if eq 1 .condArr.rankingType}}selected="selected"{{end}}>月排行
                                </option>
                                <option value="2" {{if eq 2 .condArr.rankingType}}selected="selected"{{end}}>幸运榜
                                </option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline">
                            <select id="period" name="Period" lay-verify="required" lay-search>
                                <option value="" {{if eq ""  $.condArr.currentPeriod}}selected="selected"{{end}}>全部期数/月份</option>
                            {{range $i, $m := .periods}}
                                <option value="{{index $m 0}}" {{if eq (index $m 0) $.condArr.currentPeriod}}selected="selected"{{end}}>{{index $m 1}}</option>
                            {{end}}
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline" >
                        <div class="layui-input-inline">
                            <input type="text" name="account" value="{{.condArr.account}}" placeholder="会员账号"
                                   class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline" >
                            <input type="text" name="acmout" value="{{.condArr.amount}}" placeholder="投注金额"
                                   class="layui-input">
                        </div>
                    </div>
                    <div class="layui-inline">
                        <div class="layui-input-inline" >
                            <select name="RankingFlag" lay-verify="required" lay-search>
                                <option value="" {{if eq "" .condArr.rankingflag}}selected="selected"{{end}}>全部标识</option>
                                <option value="0" {{if eq "0" .condArr.rankingflag}}selected="selected"{{end}}>真实</option>
                                <option value="1" {{if eq "1" .condArr.rankingflag}}selected="selected"{{end}}>虚拟</option>
                            </select>
                        </div>
                    </div>
                    <div class="layui-inline">
                        <button class="layui-btn">搜索</button>
                        <a {{if eq "不显示" .str}} style="display: none"{{end}}
                                                href='{{urlfor "RankingIndexController.Delbatch" }}'
                                                class="layui-btn layui-btn-danger ajax-batch">删除所有</a>
                    </div>
                </form>
                <hr>
                <div class="layui-tab-item layui-show">
                    <table class="layui-table">
                        <thead>
                        <tr>
                            <th width="20%">期数/月份</th>
                            <th>会员账号</th>
                            <th>有效投注</th>
                            <th>会员标识</th>
                            <th>操作</th>
                        </tr>
                        </thead>
                        <tbody>
                        {{range $index, $vo := .List}}
                        <tr>
                            <td >{{if eq 1 $vo.RankingType}}{{$vo.Period}}{{"月份"}}{{else}}{{$vo.PeriodString}}{{end}}</td>
                            <td>{{$vo.Account}}</td>
                            <td>{{$vo.Amount}}</td>
                            <td>{{if eq 0 $vo.RankingFlag}}真实{{else}}<font color="red">虚拟</font>{{end}}</td>
                            <td {{if eq 3 $vo.RankingType}}style="display: none"{{end}}>
                                {{/*<a href='{{urlfor "EditRankingController.get" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-normal layui-btn-mini ">修改</a>*/}}
                                <button href='{{urlfor "RankingIndexController.Delone" "id" $vo.Id}}'
                                   class="layui-btn layui-btn-danger layui-btn-mini ajax-delete">删除</button>
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
    layui.use('form', function(){
        var gameid = $("#gameid").find("option:selected").attr("value");
        var form = layui.form;
        form.on('select(ranktypelt)', function(data){
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
                    form.render('select');
                }
            });
        });
    });
</script>
</html>