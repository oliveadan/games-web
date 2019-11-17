<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes" />
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="/static/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="/static/front/vote/fifa/wap/css/style.css">
<script src="/static/front/vote/fifa/js/jquery.js" type="text/javascript"></script>
<script src="/static/front/vote/fifa/js/index.js" type="text/javascript"></script>
</head>
<body>
<div class="header">
		<div class="fl">
			<a href='{{urlfor "FifaApiController.Get"}}'>世界杯首页</a><a href="http://www.fifa.com/worldcup/" target="_blank">俄罗斯官网</a>
			<a class="t-green" href='{{.officialSite}}' target="_blank">{{.siteName}}</a>
		</div>
</div>
<div class="cup">
	<img src="/static/front/vote/fifa/images/cup.png" alt="">
</div>
<div class="mainnav_holder" style="display:none">
</div>
<div class="main_nav js_nav_scrollfixed">
	<ul>
			<li><a href='{{urlfor "FifaApiController.Teams" "gid" .gameId}}'>球队总汇</a></li>
			<li><a href='{{urlfor "FifaApiController.Vote" "gid" .gameId}}' style="color:red; font-size:20px; font-weight:700;">立即投票</a></li>
			<li><a href="http://www.24zbw.com/live/zuqiu/shijiebei/" target="_blank">世界杯直播</a></li>
		</ul>
</div>
<div class="bg_focus js_bg_focus">
	<div class="focus_body">
		<ul class="tutu"> 
			<li class="bg_1 current"></li>
			<li class="bg_2"></li>
			<li class="bg_3"></li>
		</ul>
	</div>
</div>
<div class="container">
	<div class="vote-table">
		<table>
            <tr style="font-weight:700;">
                <td>名称</td>
                <td>当前票数</td>
                <td>奖池金额</td>
            </tr>
			{{range $i,$v := .voteItemList}}
            <tr>
                <td>{{$v.Name}}</td>
                <td>{{numberAdd $v.NumVote $v.NumAdjust}}</td>
				<td>{{map_get $.prizeMap $v.Id}}</td>
            </tr>
			{{end}}
        </table>
	</div>
	<div class="form-div">
		<div class="votetips">
			<p>人人皆可参与，会员请填写会员账号，非会员请填写手机号，否则无法到账。</p>
			<p>立即投票，支持您心中的王者！</p>
		</div>
		<form id="submitForm">
			<input type="hidden" name="gid" id="gid" value="{{.gameId}}">
			<input type="hidden" name="viName" id="viName" value="">
			<input type="text" name="account" id="account" placeholder="请输入会员账号或手机号">
			<select name="viId" id="viId" class="select">
				{{range $i,$v := .voteItemList}}
                <option value="{{$v.Id}}">{{$v.Name}}</option>
				{{end}}
            </select>
			<button type="button" class="submit-btn">投票</button>
		</form>
		<div class="vote-search">已投过票了？<button type="button" class="search-btn">查询结果</button></div>
	</div>
     <div class="Field_num">
           <div class="main_bg">
             <link rel="stylesheet" rev="stylesheet" href="/static/front/vote/fifa/wap/css/comm.css" type="text/css" />
             <!-- tab切换开始-->
             <script>
                $(document).ready(function() {
                    $('#wrapper_tab a').click(function() {
                        if ($(this).attr('class') != $('#wrapper_tab').attr('class') ) {
                            $('#wrapper_tab').attr('class',$(this).attr('class'));
                        }
                        return false;
                    });
                });
             </script>
             <div class="detail_box clearfix">
                <div id="wrapper_tab" class="tab1 tab_link">
	<div class="tab_tit">
		<a href="javascript:void(0)" class="tab1 tab_link">活动详情</a>
		<a href="javascript:void(0)" class="tab2 tab_link">活动细则</a>
	</div>
	<style>
		.clearfix li img{
			width:140px;height:90px
		}
	</style>
	<div class="tab1 tab_body" style="padding: 20px 20px;color: #fff;font-size:16px;">
		{{str2html .gameRule}}
	</div>
	<div class="tab2 tab_body" style="padding: 20px 20px;color: #fff;font-size:16px;">
		{{str2html .gameStatement}}
	</div>
	<div class="clear">
	</div>
</div>
    </div>
            <div class="count">
				<div class="conitm">
					<a href='{{or .officialRegist .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon2.png" alt="" /></a>
					<a href='{{or .rechargeSite .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon1.png" alt="" /></a>
					<a href='{{or .custServ .officialSite}}' class="" ><img src="/static/front/vote/fifa/images/ficon3.png" alt="" /></a>
				</div>
             </div>
           </div>
     </div>
     
   </div>

<div class="J_mask">
</div>
<script src="/static/front/layer-v3.1.1/layer.js"></script>
<script>
$(function () {
	$('.submit-btn').click(function () {
        var account = $("#account").val();
        if (account == "") {
            layer.msg('会员账号不能为空!', {icon: 2});
            return false;
        }
		$("#viName").val($("#viId").find("option:selected").text());
        layer.confirm('确认投票？', {icon: 3, title:'提示'}, function(index){
            var iload = layer.load();
            $.ajax({
                url: '{{urlfor "VoteApiController.VoteGo"}}',
                type: "post",
                data: $("#submitForm").serialize(),
                success: function (info) {
                    layer.close(iload);
                    if (info.code === 1) {
                        layer.alert(info.msg, {icon: 1});
                    } else {
                        layer.alert(info.msg, {icon: 2});
                    }
                }
            });
            layer.close(index);
        });
        return false;
    });
	$('.search-btn').click(function () {
        var account = $("#account").val();
        if (account == "") {
            layer.msg('请输入会员账号或手机号!', {icon: 2});
            return false;
        }
        var iload = layer.load();
        $.ajax({
            url: '{{urlfor "VoteApiController.Search"}}?gid=' + $("#gid").val() + '&account=' + account,
            type: "get",
            success: function (info) {
                layer.close(iload);
                if (info.code == 1) {
					var html = '<div>会员账号：' + account;
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
});
</script>
</body>
</html>