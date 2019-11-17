<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>澳门银河</title>
    <link href="{{static_front}}/static/front/vote/css/css.css" rel="stylesheet">
    <link href="{{static_front}}/static/front/vote/css/index.css" rel="stylesheet">
</head>
<body>
<!--top-->
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header01">
    <div class="headercon w1000">
        <a class="logo"></a>
        <div class="menu">
            <ul>
                <li><a target="_blank" href="{{.officialSite}}"><i class="i1"></i><p>官方首页</p></a></li>
                <li><a  href="javascript:;" onClick="find()"><i class="i8"></i><p>查询投票</p></a></li>
                <li><a target="_blank" href="{{.officialRegist}}"><i class="i5"></i><p>免费注册</p></a></li>
            </ul>
        </div>
    </div>
</div>
<div class="top">
    <div class="txt"> </div>
    <div class="landing fr">
        <div class="pb-head pb-head-home">
            <div class="user-center" id="_userlogin1">
                <div class="login-register"> </div>
                <script language="javascript" type="text/javascript">CheckLogin1();</script>
            </div>
        </div>
    </div>
</div>
<div class="main1 container">
    <div class="box2">
        <ul class="clear">
            {{range $i,$v := .List}}
                <li>
                    <img  src="{{$v.Img}}">
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
<div class="main1 container">
    <div class="title clear hans">
        <img src="{{static_front}}/static/front/vote/images/huodongxize.png"></font>
    </div>
    <br>
    <div class="hans2" >
    {{str2html .gameRule}}
    </div>
    <div class="box1 clear"> </div>
    <div class="box2"> </div>
</div>
<div class="weina">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div>
<div class="tclogin">
    <input type="text" value="" class="user_name" id="user_name" placeholder="请输入平台会员账号">
    <input id="alert" type="submit" value="投票" class="tcsub">
</div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
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