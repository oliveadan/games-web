<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="Cache-Control" content="no-cache">
    <meta content="telephone=no" name="format-detection">
    <meta name="viewport" content="width=device-width, minimum-scale=1.0, maximum-scale=2.0">
    <meta name="viewport"
          content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0,user-scalable=no">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta name="renderer" content="webkit">
    <title>{{.siteName}}</title>
    <meta name="description" content="{{.siteName}}娱乐城">
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico"/>
    <link rel="stylesheet" href="{{static_front}}/static/front/vote/wap/css/active.all.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/vote/wap/css/animate.min.css">
    <link rel="stylesheet" href="{{static_front}}/static/front/vote/wap/css/minitip.css">
</head>
<body id="toTop">
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header">
    <img src="{{static_front}}/static/front/vote/wap/images/header-bg-m.jpg" width="100%" alt=""/>
    <div class="wrapper">
        <a class="btns-modal j-btns-modal" onclick="find()" title="投票查询"></a>
    </div>
</div>
<div class="content">
    <div class="wrapper">
        <div class="nav">
            <ul>
                <li>
                    <a href="{{.officialSite}}" target="_blank">
                        <i class="i-1"></i>
                        <span class="sp1">官网首页</span>
                    </a>
                </li>
                <li>
                    <a href="{{.custServ}}"
                       target="_blank">
                        <i class="i-3"></i>
                        <span class="sp1">在线客服</span>
                    </a>
                </li>
                <li>
                    <a href="{{.officialVip}}" target="_blank">
                        <i class="i-4"></i>
                        <span class="sp1">全民签到</span>
                    </a>
                </li>

                <li>
                    <a href="{{.officialPartner}}" target="_blank">
                        <i class="i-6"></i>
                        <span class="sp1">代理加盟</span>
                    </a>
                </li>
                <li>
                    <a href="{{.officialPromot}}" target="_blank">
                        <i class="i-7"></i>
                        <span class="sp1">优惠查询</span>
                    </a>
                </li>
            </ul>
        </div>
        <div class="listbox">
            <div class="notice">
                <h3>网站公告：</h3>
                <div class="marquee-box">
                    <marquee direction="left" id="view_annouVal" scrollamount="2" onmouseover="this.stop()"
                             onmouseout="this.start()">
                    {{.announcement}}
                    </marquee>
                </div>
            </div>

            <ul id="view_active">
            {{range $index, $v :=.List}}
                <li>
                    <img  style="width: 300px;height: 350px" src="{{$v.Img}}">
                    <div onclick="vote({{$v.Id}},{{$v.GameId}},{{$v.Name}})" class='po'>{{numberAdd $v.NumVote $v.NumAdjust}}</div>
                    <div class="txt">
                        <h1>【{{$v.Name}}】</h1>
                        <h2>{{$v.Detail}}</h2>
                    </div>
                </li>
            {{end}}
            </ul>
        </div>
    </div>
</div>
<div class="footer">
    <div class="links">
        <a href="{{.officialSite}}" target="_blank">关于我們</a><span>|</span>
        <a href="{{.officialSite}}" target="_blank">联络我們</a><span>|</span>
        <a href="{{.officialPartner}}" target="_blank">合作伙伴</a><span>|</span>
        <a href="{{.officialSite}}" target="_blank">常见问题</a>
    </div>
    <div class="copy">
        Copyright © {{.siteName}} Reserved
    </div>
</div>
<div class="tclogin">
    <input type="text" value="" class="user_name" id="user_name" placeholder="请输入平台会员账号">
    <input  id="alert" type="submit" value="登陆" class="tcsub">
</div>
<script type="text/javascript" src="{{static_front}}/static/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script>
    var voteid = "";
    var gameid = "";
    var votename = "";
    function vote(vid,gid,vname) {
        $("#alert").val("投票");
        voteid = vid;
        gameid = gid;
        votename =vname;
        layer.open({type: 1,
            title: false,
            closeBtn:true,
            shadeClose: true,
            skin:'layui-layer-nobg',
            content:$('.tclogin'),
            end: function(){$(".tcsub").unbind();}
        });
        $(".tcsub").click(function(){
            if($("#user_name").val()==""){
                layer.msg("会员帐号不能为空!");
                return false;
            } else{
                $.ajax({
                    url: '/vote/go',
                    dataType: 'json',
                    cache: false,
                    type: 'POST',
                    data: {gid:gameid,account: $("#user_name").val(),viId:voteid,viName:vname},
                    success: function (obj) {
                        switch(obj.code){
                            case 0:
                                layer.msg(obj.msg);
                                break;
                            case 1:
                                layer.closeAll();
                                layer.msg(obj.msg);
                                setTimeout(function(){
                                    window.location.reload();//刷新当前页面.
                                },2000);
                                break;
                            default:
                                break;
                        }
                    },
                    error: function(XMLHttpRequest, textStatus, errorThrown) {
                        var x = 1;
                        localStorage.clear();
                    }
                })
            }
        });
    };


    function find(){
        $("#alert").val("查询投票");
        layer.open({type: 1,
            title: false,
            closeBtn:true,
            shadeClose: true,
            skin:'layui-layer-nobg',
            content:$('.tclogin'),
            end: function(){$(".tcsub").unbind();}
        });
        $('.tcsub').click(function () {
            var account = $("#account").val();
            if($("#user_name").val()==""){
                layer.msg("会员帐号不能为空!~");
                return false;
            }
            var iload = layer.load();
            $.ajax({
                url: '{{urlfor "VoteApiController.Search"}}?gid=' + $("#gid").val() + '&account=' + $("#user_name").val(),
                type: "get",
                success: function (info) {
                    layer.closeAll();
                    if (info.code == 1) {
                        var html = '<div style="color: red">会员账号：' + $("#user_name").val();
                        for(var i=0;i<info.data.length;i++) {
                            html = html + '<hr>投票内容：' + info.data[i].viName
                                    + '<br>中奖状态：' + (info.data[i].isWin==0?'等待开奖':(info.data[i].isWin==1?'恭喜中奖':'很遗憾，未中奖'));
                            if(info.data[i].giftContent && info.data[i].giftContent!="") {
                                html = html + '<br>奖品内容：' + info.data[i].giftContent + '元'
                                        + '<br>派彩状态：' + (info.data[i].delevered==1?'已派彩':'等待派彩');
                            }
                            if(info.data[i].isWin==1 && info.data[i].giftContent=="") {
                                html = html + '<br><br>奖品派发中，敬请关注！';
                            }
                        }
                        html = html + '</div>';
                        layer.open({
                            title: '投票结果',
                            area: ['auto', '300px'],
                            content:html
                        });
                    } else {
                        layer.msg(info.msg, {icon: 2});
                    }
                }
            });
            return false;
        });
    }

</script>
</body>
</html>
