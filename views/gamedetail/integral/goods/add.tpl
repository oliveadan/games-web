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
                <li class=""><a href='{{urlfor "GoodsIndexController.get"}}'>商品列表</a></li>
                <li class="layui-this">添加商品</li>
            </ul>
            <div class="layui-tab-content">
                <div class="layui-tab-item layui-show">
                    <form class="layui-form form-container" action='{{urlfor "GoodsAddController.post"}}' method="post">
                    {{ .xsrfdata }}
                        <div class="layui-form-item">
                            <label class="layui-form-label">活动名称</label>
                            <div class="layui-input-block">
                                <select name="GameId" lay-verify="required" lay-search>
                                {{range $i, $m := .gameList}}
                                    <option value="{{$m.Id}}"
                                            {{if eq $m.Id $.currentGameId}}selected="selected"{{end}}>{{$m.Name}}</option>
                                {{end}}
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">商品状态</label>
                            <div class="layui-input-block">
                                <select name="BroadcastFlag" lay-verify="required" lay-search>
                                        <option value="0" >无</option>
                                        <option value="1" >新增</option>
                                        <option value="2" >热销</option>
                                        <option value="3" >限量</option>
                                        <option value="4" >特惠</option>
                                </select>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">商品名称</label>
                            <div class="layui-input-block">
                                <input type="text" name="Name" value="" required lay-verify="required"
                                       placeholder="请输入商品名称，如：￥599" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">商品说明</label>
                            <div class="layui-input-block">
                                <input type="text" name="Content" value="" placeholder="请输入商品说明，如：现金券、礼包"
                                       class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">所需积分</label>
                            <div class="layui-input-block">
                                <input type="number" name="Seq" value="" required lay-verify="required"
                                       placeholder="请输入兑换本商品所需的积分数" class="layui-input">
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">奖品图片</label>
                            <div class="layui-inline" style="width: 48%; margin-bottom: 0px;">
                                <input type="hidden" name="Photo" id="Photo" value="">
                                <img src="/static/img/noimg.jpg" id="imgreview" width="100px" height="100px">
                                <button type="button" class="layui-btn layui-btn-primary layui-btn-big" id="upphoto">
                                    <i class="layui-icon">&#xe61f;</i>上传图片
                                </button>
                            </div>
                        </div>
                        <div class="layui-form-item">
                            <label class="layui-form-label">排序字段</label>
                            <div class="layui-input-inline">
                                <input type="number" name="Probability" value="" required
                                       placeholder="排序字段" class="layui-input">
                            </div>
                            <div class="layui-form-mid layui-word-aux">排序字段越小越靠前</div>
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
<script>
    layui.use('upload', function(){
        var upload = layui.upload;

        var uploadInst = upload.render({
            elem: '#upphoto',
            url: '{{urlfor "SyscommonController.Upload"}}',
            before: function(obj){
                layer.load(); //上传loading
            },
            done: function(res){
                layer.closeAll('loading');
                if(res.code==0) {
                    $("#Photo").val(res.data.src);
                    $("#imgreview").attr("src", res.data.src);
                    layer.msg(res.msg);
                } else {
                    layer.msg(res.msg);
                }
            },
            error: function(){
                layer.closeAll('loading');
                layer.msg("图片上传失败，请重试");
            }
        });
    });
</script>
</body>
</html>