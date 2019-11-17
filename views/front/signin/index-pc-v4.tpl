<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1"/>
    <meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate"/>
    <meta http-equiv="Pragma" content="no-cache"/>
    <meta http-equiv="Expires" content="0"/>
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/css/common-pc.css"/>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/signin/v4/css/style.css"/>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/signin/v4/css/responsive.css"/>
    <link type="text/css" rel="stylesheet" href="http://cdn.staticfile.org/twitter-bootstrap/3.1.1/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="{{static_front}}/static/front/live2d/css/live2d.css"/>
</head>
<body>
<div id="wrap" class="clearfix">
    <!-- <div id="wrapper-header">
           <div id="header" class="clearfix">
            <div class="mobile-menu-btn"></div>
            <div class="wrapper-slide-menu">
                <ul class="slide-menu">
                    <li><a href="{{.officialSite}}">官网首页</a></li>
                    <li><a href="{{.officialPromot}}">优惠活动</a></li>
                    <li><a href="{{.officialRegist}}">免费注册</a></li>
                    <li><a href="{{.custServ}}">在线客服</a></li>
                </ul>
            </div>
            <h1 id="logo"><a href="index.html"><img src="{{static_front}}/static/img/logo240x80.png" alt="{{.siteName}}"/></a></h1>
            <div id="menu">
                <ul class="clearfix">
                    <li class="navItem"><a href="{{.officialSite}}">官网首页</a></li>
                    <li class="navItem"><a href="{{.officialPromot}}">优惠活动</a></li>
                    <li class="navItem"><a href="{{.officialRegist}}">免费注册</a></li>
                    <li class="navItem"><a href="{{.custServ}}">在线客服</a></li>
                </ul>
            </div>
            <div id="langDeskTopMenu">
                <div id="langDeskTopOptionDiv"></div>
            </div>
        </div>
    </div> -->
    <div class="content event" id="contentEventDiv">
        <div class="eventMain">
            <div class="headd">
                <img src="{{static_front}}/static/front/signin/v4/images/top12.gif">
            </div>

            <div class="rankingSection">
                <div class="rankingButtonBar">
                {{if eq .gameStatus 2}}
                    <div class="rankinginput1"
                         style="background-image: url({{static_front}}/static/front/signin/v4/images/name.png);">
                        <input type="text" id="name" name="name" placeholder="请输入真实姓名">
                    </div>
                    <div class="rankinginput1">
                        <input type="text" id="mobile" name="mmobile" placeholder="请输入手机号码">
                    </div>
                {{end}}
                    <div class="rankinginput">
                        <input type="hidden" id="gid" value="{{.gameId}}">
                        <input type="text" id="account" name="account" placeholder="请输入会员账号"><br><br>
                        <div class="rankingBtn1">
                        {{if eq .gameStatus 2}}
                            <img onclick="carveup({{.gameId}})"
                                 src="{{static_front}}/static/front/signin/v4/images/signinguafen.png"
                                 style="cursor: pointer;">
                        {{else}}
                            <img id="rankDay1Btn" src="{{static_front}}/static/front/signin/v4/images/signin.png"
                                 style="cursor: pointer;">
                        {{end}}
                            <a href="{{.officialRegist}}">
                                <img id="rankDay1Btn"
                                     src="{{static_front}}/static/front/signin/v4/images/registered.png"
                                     style="cursor: pointer;">
                            </a>
                            <img id="querycode" src="{{static_front}}/static/front/signin/v4/images/querycode.png"
                                 style="cursor: pointer;">
                            <img id="addshare" class="commenttt commnet-open" src="{{static_front}}/static/front/signin/v4/images/comment.png"
                                 style="cursor: pointer;">

                        </div>
                    </div>
                    <div class="rankingBtn2" {{if eq .gameStatus 2}}style="display: none"{{end}}>
                        <a href="javascript:void(0);" class="rl_search">查看奖金记录&gt;&gt;</a>
                        <img id="addshare" class="commentt commnet-open" src="{{static_front}}/static/front/signin/v4/images/comment.png"
                             style="cursor: pointer;">
                        <a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="rl_search_mobile">查看奖金记录&gt;&gt;</a>
                    </div>
                </div>
                <div {{if eq .gameStatus  2}}
                style="display:none"{{end}} class="wrapper-feature-title" id="rankingImgTitle"><img id="imgTitle-1"
                                                                                                    src="{{static_front}}/static/front/signin/v4/images/top10.png">
                </div>
                <div {{if eq .gameStatus  2}} style="display:none"{{end}} id="eventRanking">
                    <div id="eventRankingTableDiv">
                        <div id="eventRankingTitleDiv">
                            <h1 id="eventRankingTitle" class="english">签到 <br class="rankingbr"/>奖金榜</h1></div>
                        <table id="eventRankingTable">
                            <thead>
                            <th class="ranking">排名</th>
                            <th class="amount">奖金(元)</th>
                            <th class="account">会员</th>
                            <th class="account">等级</th>
                            </thead>
                            <tbody>
                            {{range $i,$v := .rlList}}
                            <tr>
                            {{if lt $i 3}}
                                <td class="ranking enlarge"><img id="rankingMedal"
                                                                 src="{{static_front}}/static/front/signin/v4/images/no{{numberAdd $i 1}}.png"/>
                                </td>
                                <td class="amount enlarge">{{$v.GiftContent}}</td>
                                <td class="account enlarge">{{substr $v.Account 0 3}}***</td>
                                <td class="account enlarge">{{$v.GiftName}}</td>
                            {{else}}
                                <td class="ranking">{{numberAdd $i 1}}</td>
                                <td class="amount">{{$v.GiftContent}}</td>
                                <td class="account">{{substr $v.Account 0 3}}***</td>
                                <td class="account">{{$v.GiftName}}</td>
                            {{end}}
                            </tr>
                            {{end}}
                            <tr class="eventRankingTableBorder">
                                <td>
                                    <div class="rankingBorder"></div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div {{if eq .gameStatus  2}} style="display:none"{{end}} class="wrapper-feature-title" id="rankingImgTitle">
                    <img id="imgTitle-1" src="{{static_front}}/static/front/signin/v4/images/top11.png">
                </div>
                <div {{if eq .gameStatus  2}} style="display:none"{{end}} id="eventRanking">
                    <div id="eventRankingTableDiv">
                        <div id="eventRankingTitleDiv">
                            <h1 id="eventRankingTitle" class="english">签到 <br class="rankingbr"/>奖金榜</h1></div>
                        <table id="eventRankingTable">
                            <thead>
                            <th class="ranking">排名</th>
                            <th class="amount">奖金(元)</th>
                            <th class="account">会员</th>
                            <th class="account">翻倍</th>
                            </thead>
                            <tbody>
                            {{range $i,$v := .rlList1}}
                            <tr>
                            {{if lt $i 3}}
                                <td class="ranking enlarge"><img id="rankingMedal"
                                                                 src="{{static_front}}/static/front/signin/v4/images/no{{numberAdd $i 1}}.png"/>
                                </td>
                                <td class="amount enlarge">{{$v.GiftContent}}</td>
                                <td class="account enlarge">{{substr $v.Account 0 3}}***</td>
                                <td class="account enlarge">{{$v.GiftName}}</td>
                            {{else}}
                                <td class="ranking">{{numberAdd $i 1}}</td>
                                <td class="amount">{{$v.GiftContent}}</td>
                                <td class="account">{{substr $v.Account 0 3}}***</td>
                                <td class="account">{{$v.GiftName}}</td>
                            {{end}}
                            </tr>
                            {{end}}
                            <tr class="eventRankingTableBorder">
                                <td>
                                    <div class="rankingBorder"></div>
                                </td>
                            </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

            </div>
            <div {{if eq .gameStatus  2}}
            style="display:none"{{end}} class="wrapper-feature-title" id="rankingImgTitle"><img id="imgTitle-1"
                                                                                                src="{{static_front}}/static/front/signin/v4/images/top13.png">
            </div>
            <div {{if eq .gameStatus  2}} style="display:none"{{end}} id="eventRanking">
                <div id="eventRankingTableDiv">
                    <table id="eventRankingTable">
                        <tbody id="comment">

                        </tbody>
                    </table>
                    <div class="pagination" id="pagination1"></div>
                </div>
            </div>
        </div>
        <div id="ruleContainer">
            <div class="eventDiv" id="eventDiv-3">
                <div class="wrapper-event" id="wrapper-rule">
                    <div class="wrapper-rule-col-2">
                        <div class="wrapper-rule-broder" id="rulePanel">
                            <img class="ruleTitleImg"
                                 src="{{static_front}}/static/front/signin/v4/images/tx_rules.png"/>
                        {{str2html .gameRule}}
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- <div class="eventTxtContainer">
                <div class="eventTxt" id="eventTxt">
                    <img class="ruleTitleImg" src="/static/front/signin/v4/images/tx_resp.png"/>
                {{str2html .gameStatement}}
                </div> -->
    </div>
</div>
</div>
<div id="wrapper-footer">
    <div class="footer">
        <div class="inner"><p id="copyRightTxt">Copyright &copy;{{date .nowdt "Y"}} {{.siteName}} All rights
            reserved.</p></div>
    </div>
</div>
<div class="fries-wrapper" id="coinLayer"></div>
</div>
<!-- 中奖记录查询 开始 -->
<div id="rl_dialog" class="rldialog">
    <div class="rlbox">
        <div class="rlbox_bt">
            <span>输入会员账号查询</span>
            <a href="javascript:void(0);" class="rl_dialog_close">X</a>
        </div>
        <div class="rlbox_hy">
            <label style="display:contents;box-sizing:content-box;-webkit-box-sizing:content-box;">会员账号：</label><input name="rlquerycode" id="rlquerycode" type="text" value="" placeholder="请输入会员帐号">
            <button type="button" class="rl_searchbtn">查 询</button>
        </div>
        <div class="rlbox_bd">
            <table style="margin:20px auto" width="480" border="0" cellpadding="0" cellspacing="0">
                <tr class="ad">
                    <td>签到奖励</td>
                    <td>签到时间</td>
                    <td>是否派彩</td>
                </tr>
                <tbody id="rl_content"></tbody>
            </table>
            <div class="rl_pages"></div>
        </div>
    </div>
</div>
<div id="rl_fade" class="rldialog_zz"></div>
<!--中奖弹窗-->
<div class="tcwin">
    <div class="wintext"></div>
    <div class="wintext1"></div>
    <div class="wintext2"></div>
    <button class="layui-layer-close makesure">确定</button>
</div>
<!--添加评论弹窗-->
<div class="addshare" style="display: none;width:300px;height: 200px">
    &nbsp<textarea id="Content"style="height:180px;width: 282px"></textarea></br>
    <input type="hidden" id="GameId" value="{{.gameId}}">
</div>
<!-- 中奖记录查询 结束 -->
<!-- 返回顶部 开始 -->
<a href="javaScript:void(0);" class="go-top" style="display: inline;"><img
        src="{{static_front}}/static/front/img/gotop.svg"></a>
<!-- 返回顶部 结束 -->
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/common.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jqPaginator.js"></script>
<script>
    $(function () {
        var bool = false;
        $(".mobile-menu-btn").click(function () {
            if ($(".slide-menu").is(":hidden")) {
                $(".slide-menu").show();
            } else {
                $(".slide-menu").hide();
            }
        });
        $("#rankDay1Btn").click(function () {
            if (bool) {
                showMessage("您今天已经签到过了哦~", 3000);
                return
            }
            var account = $("#account").val();
            if (account == "") {

                //layer.msg("请输入会员账号", {icon: 2});
                showMessage("您忘记输入会员账号了", 3000);
                return;
            }
            $.ajax({
                url: '{{urlfor "SigninApiController.Post"}}',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {"gid": $("#gid").val(), "account": account},
                beforeSend: function () {
                    $("#rankDay1Btn").hide();
                },
                success: function (obj) {
                    console.log(obj)
                    if (obj.code == 0) {
                        showMessage(obj.msg, 3000);
                    } else if (obj.code == 2) {
                        $("#rankDay1Btn").show();
                        bool = true;
                        showMessage(obj.msg, 3000);
                    } else if (obj.code == 1) {
                        bool = true;
                        $(".wintext").html("恭喜您获得<b>" + obj.data.giftContent + "元</b>");
                        $(".wintext1").html("到下一级还需要<b>" + obj.data.force1 + obj.data.unit + "</b>");
                        if(obj.data.hasOwnProperty('gift')){
                            $(".wintext2").html("<b>" + obj.data.gift + "</b>");
                        }
                        layer.open(
                                {
                                type: 1,
                                zIndex: 100,
                                title: false,
                                area: ['300px','400px'],
                                skin: 'layui-layer-nobg',
                                shade: 0.7,
                                closeBtn: true,
                                shadeClose: true,
                                content: $('.tcwin')
                                });
                        showMessage("恭喜您签到成功！", 5000);
                    } else if (obj.code == 3) {
                        html = '<div>恭喜您获得<span style="color:red;">&nbsp;' + obj.data.giftContent + '&nbsp;元</span></div>';
                        showMessage(html, 5000);
                        var register = '<a style="color:red" href="{{.officialRegist}}">点击进行注册</a>';
                        html = html + '<div><span style="color:blue">注册会员账号，签到可得更多彩金</span><br>' + register + '</div>';
                        layer.alert(html, {title: obj.msg, icon: 6});
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    showMessage("哎呀，服务器开小差了，请稍后再试吧~", 3000);
                }
            })
        });
    });
</script>
<script>
    //查询邀请码
    $("#querycode").click(function () {
        var account = $("#account").val();
        if (account == "") {
            //layer.msg("请输入会员账号", {icon: 2});
            showMessage("亲爱的，您忘记输入会员账号了~~~", 3000);
            return;
        }
        $.ajax({
            url: '{{urlfor "DoorController.QueryInvitationCode"}}',
            dataType: 'json',
            cache: false,
            type: 'Post',
            data: {'account': account},
            success: function (obj) {
                if (obj.code == 0) {
                    showMessage(obj.msg, 3000);
                } else {
                    html = '<div>您的邀请码为<span style="color:red;">&nbsp;' + obj.msg + '&nbsp;</span></div>';
                    layer.alert(html, {title: "",});
                    showMessage("您的邀请码是:" + obj.msg, 3000);
                }
            }
        })
    })
</script>
<script>
    //添加评论内容
    $(".commnet-open").click(function () {
        var account = $("#account").val();
        if (account == "") {
            //layer.msg("请输入会员账号", {icon: 2});
            showMessage("亲爱的，您忘记输入会员账号了~~~", 3000);
            return;
        }
        layer.open({
            type: 1,
            title: '请输入留言内容',
            area:['300px'],
            content: $('.addshare'),
            btnAlign: 'c',
            btn: ['提交'],
            yes: function () {
                $.ajax({
                    url: '/add/share',
                    async: false,
                    data: {'account': account, 'content': $("#Content").val(), 'gameid': $("#GameId").val(),},
                    type: 'Post',
                    //指定请求成功后执行的回调函数;
                    success: function (data) {
                        if (data.code === 1) {
                            $("#Content").val("");
                            layer.closeAll();
                            layer.msg(data.msg)
                        } else {
                            layer.closeAll();
                            layer.msg(data.msg);
                        }
                    },
                    error: function () {
                        alert("error");
                    },
                });
            }
        });
    });
</script>
<script>
    function carveup(id) {
        var account = $("#account").val();
        var mobile = $("#mobile").val();
        var name = $("#name").val();
        if (account == "") {
            showMessage("请输入会员账号！", 3000);
            return;
        }
        if (mobile == "") {
            showMessage("请输入手机号码！", 3000);
            return;
        }
        if (name == "") {
            showMessage("请输入真实姓名！", 3000);
            return;
        }
        $.ajax({
            url: '{{urlfor "SigninCarveUPApiController.Post"}}',
            type: "post",
            data: {"id": id, "account": account, "mobile": mobile, "name": name},
            success: function (info) {
                if (info.code === 1) {
                    location.href = info.url;
                } else {
                    showMessage(info.msg, 3000);
                }
            },
        });
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/live2d-widget@3.0.5/lib/L2Dwidget.min.js"></script>
<script type="text/javascript">
    var width, height;
    if (document.body.clientWidth < 800) {
        width = 80;
        height = 160;
    } else {
        width = 150;
        height = 300;
    }
    L2Dwidget.init({
        model: {
            jsonPath: "https://cdn.jsdelivr.net/npm/live2d-widget-model-miku@1.0.5/assets/miku.model.json",
        },
        display: {
            width: width,
            height: height,
            position: "left",
            vOffset: 0
        },
        mobile: {
            motion: 1
        },
        react: {
            opacityDefault: 1,
            opacityOnHover: .5,
            myFunc: function (t) {
                console.log("111111")
            }
        },
    });
</script>
<!--评论区进行分页-->
<script type="text/javascript">
    $.jqPaginator('#pagination1', {
        totalPages: 1,
        visiblePages: 3,
        currentPage: 1,
        prev: '<li class="prev"><a href="javascript:;">上一页</a></li>',
        next: '<li class="next"><a href="javascript:;">下一页</a></li>',
        onPageChange: function (num, type) {
            search(num);
        }

    });
    function search(pageIndex) {
        var str = "";
        $.ajax({
            url: '/signin/page',
            type: "post",
            data: {"page": pageIndex, "gid": {{.gameid}},},
            success: function (data) {
                if (data.total > 0) {
                    $('#pagination1').jqPaginator('option', {
                        totalPages: Math.ceil(data.total / 10)
                    });
                }
                if (data.commentlist.length > 0) {
                    var tag = "";
                    for (var i = 0; i < data.commentlist.length; i++) {
                        var time1 = new Date(data.commentlist[i].CreateDate).Format("yyyy-MM-dd HH:mm:ss");
                        //添加标签
                        switch (data.commentlist[i].Tag) {
                            case 1:
                                tag = "{{static_front}}/static/front/signin/v4/images/tag1.png";
                                break;
                            case 2:
                                tag = "{{static_front}}/static/front/signin/v4/images/tag2.png";
                                break;
                            case 3:
                                tag = "{{static_front}}/static/front/signin/v4/images/tag3.png";
                                break;
                            case 9:
                                tag = "{{static_front}}/static/front/signin/v4/images/tag4.png";
                                break;
                            default:
                                tag = "{{static_front}}/static/front/signin/v4/images/tag1.png";
                        }
                        str += '<tr><td class="comment"><img src=' + tag + '>'+'<font style="color: red;">&nbsp&nbsp&nbsp' + data.commentlist[i].Account +'</font><font style="font-size: 15px;">'+'&nbsp&nbsp留言时间：' + time1 +'</font></td></tr>'
                                +'<tr><td class="comment">'+ data.commentlist[i].Content +'</td></tr>'
                    }
                    $("#comment").html(str)
                } else {
                    $("#comment").html("暂无评论……");
                    $('#pagination1').jqPaginator('option', {
                        totalPages: 1
                    });
                    $('#pagination1').hide();
                }
            },
        });
    };

    Date.prototype.Format = function (fmt) { //author: meizz
        var o = {
            "M+": this.getMonth() + 1, //月份
            "d+": this.getDate(), //日
            "H+": this.getHours(), //小时
            "m+": this.getMinutes(), //分
            "s+": this.getSeconds(), //秒
            "q+": Math.floor((this.getMonth() + 3) / 3), //季度
            "S": this.getMilliseconds() //毫秒
        };
        if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
        for (var k in o)
            if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
        return fmt;
    }
</script>

<div id="landlord">
    <div class="message" style="opacity:0"></div>
</div>
<script type="text/javascript">
    var message_Path = '{{static_front}}/static/front/live2d/';
    var siteName = '{{.siteName}}';
</script>
<script type="text/javascript" src="{{static_front}}/static/front/live2d/js/message.js"></script>
</body>
</html>
