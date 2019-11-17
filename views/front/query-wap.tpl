<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes" />
<title>活动记录查询</title>
<link rel="shortcut icon" href="/static/img/favicon.ico" type="image/x-icon">
<link rel="apple-touch-icon" href="app.png">
<link rel="stylesheet" href="/static/front/query/style.css">
<link rel="stylesheet" href="/static/front/query/skin-red.css">
</head>
<body>
	<input type="hidden" id="gid" value="{{.gameId}}">
	<div class="headerseat"></div>
    <div class="header" id="header">
        <a href="javascript:history.go(-1);" class="back"></a>
        <a href="{{urlfor "DoorController.Get"}}" class="logo"></a>	
    </div>
    <div id="content" class="content">
        <div class="query">
			<input type="text" class="input" id="username" placeholder="请输入会员账号">
			<input type="button" class="button" onClick="query(0)" value="查询">
		</div>
		<div class="split"></div>
		<div id="detail" class="detail">
		</div>
		<div class="mo">
			<a id="more" href="javascript:;"  onClick="query(1)" class="more">点击查看更多</a>
			<div id="nomore" class="nomore">没有更多了~</div>
		</div>
    </div>
<script src="/static/front/query/respond.min.js"></script>
<script type="text/javascript" src="/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="/static/front/layer-v3.1.1/layer.js"></script>
<script>
var page = 1;
var pagesize = 5;
function query(type){
    var _username = $("#username").val();
    if(_username ==""){
        alert("请输入会员账号!");
        return false;
    }
	if(type==0) {
		page = 1;
		$("#detail").html("");
	}
    $.ajax({
		url: '{{urlfor "LotteryController.LotteryQuery"}}',
		dataType: 'json',
		cache: false,
		type: 'POST',
		data: {gid:$("#gid").val(),account: _username,page:page,pagesize:pagesize},
		success: function (res) {
			switch(res.code){
				case 0:
					layer.msg(res.msg);
					break;
				case 1:
					var html = "";
					$.each(res.data.list, function(i, obj){
						html += '<section class="section clearfix">'
								+'	<div class="gift">'
								+'		<span>'+obj.gift+'</span>'
								+'	</div>'
								+'	<div class="time">'
								+'		<span>'+obj.createDate+'</span>'
								+'		<span class="status'+obj.delivered+'">'+(obj.delivered==1?'已派彩':'未派彩')+'</span>'
								+'	</div>'
								+'</section>';
					})
					$("#detail").append(html);
					if(page*pagesize>=res.data.total) {
						$("#more").hide();
						$("#nomore").show();
					} else {
						page++;
						$("#more").css('display','inline-block');
						$("#nomore").hide();
					}
					
					break;
				default:
					break;
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var x = 1;
		}
	});
}
</script>
</body>
</html>