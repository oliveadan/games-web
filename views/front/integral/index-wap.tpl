<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="viewport" content="width=device-width initial-scale=1.0 maximum-scale=1.0 user-scalable=yes"/>
	<title>{{.siteName}}-{{.gameDesc}}</title>
    <script src="{{static_front}}/static/front/integral/wap/js/respond.min.js"></script>
	<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/integral/wap/css/common.css">
</head>
<body>
    <header>
		<div>
			<ul id="accordion" class="accordion">
				<li>
					<div class="head-top link"><div class="logo"></div></div>
					<ul class="submenu">
						<li><a href="{{.officialSite}}" target="_blank">网站首页</a></li>
                		{{if .rechargeSite}}<li><a href="{{.rechargeSite}}" target="_blank">快速充值中心</a></li>{{end}}
                		{{if .officialPartner}}<li><a href="{{.officialPartner}}" target="_blank">合作经营</a></li>{{end}}
						{{if .officialRegist}}<li><a href="{{.officialRegist}}" target="_blank">免费注册</a></li>{{end}}
               		 	{{if .officialPromot}}<li><a href="{{.officialPromot}}" target="_blank">活动优惠</a></li>{{end}}
               		 	<li><a href="{{.custServ}}" target="_blank">在线客服</a></li>
					</ul>
				</li>
			</ul>
		</div>
        <div class="head-cnt"></div>
    </header>
	<div class="logined"><span>会员</span><strong id="username"></strong><span>当前积分</span><strong id="lotNums"></strong><button onclick="exit()" class="btn exit-btn">退出</button></div>   
    <div class="main">
        <div class="container">
			<input type="hidden" id="gid" value="{{.gameId}}">
            <div class="box-t1">
                <button class="btn-viewpoint">登录查看当前积分</button>
                <a href="{{urlfor "DoorController.Query" "gid" .gameId}}"><button class="btn-getflow">获取活动积分流程</button></a>
            </div>
            <div class="box box1">
                <div class="box-top">
                    <div class="title title1 js-goto2-offset">积分说明</div>
                    <div class="cnt cnt1">{{.announcement}}</div>
                    <div class="title title2 js-goto3-offset">积分兑换</div>
                    <div class="cnt cnt2">
                        <p>兑换之前，建议您先行查询现有的会员积分数，再选择要您要兑换的现金券。</p>
                        <ul>
							{{range $i, $v := .giftList}}
							<li style="background: url({{$v.Photo}}) no-repeat center;">
                               	<p><em>{{$v.Name}}</em>{{$v.Content}}</p>
                               	<span>{{$v.Seq}} 积分</span>
                               	<button class="btn-excharge" onClick="excharge({{$v.Id}})">立即兑换</button>
                            </li>
							{{end}}
                        </ul>
                    </div>
                    <div class="title title3">兑换时间</div>
                    <div class="cnt cnt3">北京时间每周五为会员积分兑换日，当天24小时均可进行兑换，所有现金券可重复兑换。</div>
                </div>
                <div class="box-btm"></div>
            </div>
            <div class="box-t2"></div>
            <div class="box box2">
                <div class="box-top">
                    <div class="cnt">
                        {{str2html .gameRule}}
                    </div>
                </div>
                <div class="box-btm"></div>
            </div>
        </div>
    </div>
    <footer>
        <div class="copyright">
            <p>©2017-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</p>
        </div>
    </footer>
	<div id="light" class="white_content">
		<div class="cxbox">
	        <div class="cxbox_bt">
	            <p>兑换记录查询</p>  
	            <a href="javascript:void(0)" style="color:#ffe681;text-decoration:none;" onClick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'" class="gban">
				X</a>
	        </div>
	        <div class="cxbox_bd"  style="color:#ffe681;margin-top: 50px;" >
	            <table width="480" border="0" cellpadding="0" cellspacing="0">
	              <tr class="ad">
	                <td>会员账号</td>
	                <td>兑换内容</td>
	                <td>兑换时间</td>
	                <td>是否派彩</td>
	              </tr>
				  <tbody id="query_content"></tbody>
	            </table>
				<div class="quotes" style="padding:10px 0px;"></div>
	        </div>
	    </div>
	</div>
	<div id="fade" class="black_overlay"></div>
    
	<div class="tclogin">
		<input type="text" value="" class="user_name" id="user_name" placeholder="请输入平台会员账号">
	    <input type="submit" value="登陆" class="tcsub">
	</div>
	<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
	<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
	<script>
	var _username="";
	if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){
		_username=localStorage.getItem("username");
		checkUser();
	}
	function checkUser() {
		$.ajax({
			url: '{{urlfor "DoorController.Login"}}',
			dataType: 'json',
			cache: false,
			type: 'POST',
			data: {gid:$("#gid").val(),account: _username},
			success: function (obj) {
				switch(obj.code){
					case 0:
						localStorage.clear();
						layer.msg(obj.msg);
						$('.logined').fadeOut();
						break;
					case 1:
						$("#username").text(_username);
						$('#lotNums').html(obj.data.lotteryNums);
						$('.logined').fadeIn();
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
	
    //积分兑换
    function excharge(giftid) {
        if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){
			_username=localStorage.getItem("username");
			layer.open({
				title: '提示',
	            shadeClose: true,
				icon: 3,
	            content: '<div style="color: #000;">是否确认兑换？</div>',
	            btn: ['确定', '取消'],
	            yes: function (index) {
	                $.ajax({
						url: '{{urlfor "IntegralApiController.Post"}}',
						dataType: 'json',
						cache: false,
						type: 'POST',
						data: {gid:$("#gid").val(),account: _username,giftid:giftid},
						success: function (obj) {
							switch(obj.code){
								case 1:
									layer.open({
										title: '兑换成功',
							            shadeClose: true,
										icon: 6,
									  	content: '<div style="color: #000;">'+(obj.msg?obj.msg:"兑换成功")+'</div>'
									});
									break;
								case 0:
									layer.open({
										title: '兑换失败',
							            shadeClose: true,
										icon: 5,
									  	content: '<div style="color: #000;">'+(obj.msg?obj.msg:"兑换失败")+'</div>'
									});
									break;
								default:
									break;
							}
						},
						error: function(XMLHttpRequest, textStatus, errorThrown) {
							layer.msg("请求异常，请刷新后重试");
						}
					})
	                layer.close(index);
	            }
	        });
		} else {
         	login();
       	}
    }
	//会员登陆 弹窗
    function login() {
        layer.open({type: 1, title: false,closeBtn:true,shadeClose: true,skin:'layui-layer-nobg',content:$('.tclogin'),end: function(){$(".tcsub").unbind();}});
    }

    $(function () {
		var Accordion = function(el, multiple) {
		this.el = el || {};
		this.multiple = multiple || false;

		// Variables privadas
		var links = this.el.find('.link');
		// Evento
		links.on('click', {el: this.el, multiple: this.multiple}, this.dropdown)
	}

	Accordion.prototype.dropdown = function(e) {
		var $el = e.data.el;
			$this = $(this),
			$next = $this.next();

		$next.slideToggle();
		$this.parent().toggleClass('open');

		if (!e.data.multiple) {
			$el.find('.submenu').not($next).slideUp().parent().removeClass('open');
		};
	}	

	var accordion = new Accordion($('#accordion'), false);

        //会员退出
        $('.exit-btn').click(function () {
            $.post('{{urlfor "DoorController.Logout"}}', function (result) {
			localStorage.clear();
                window.location.reload();
            });
        });

        //验证会员登陆
        $(".tcsub").click(function(){
			if($("#user_name").val()==""){
				layer.msg("会员帐号不能为空!");
				return false;
			}
            $.post('{{urlfor "DoorController.Login"}}', {gid: $('#gid').val(), account: $("#user_name").val()}, function (obj) {
		        switch(obj.code){
				case 0:
					localStorage.clear();
					layer.msg(obj.msg);
					break;
				case 1:
					$('.logined').fadeIn();
					_username =$("#user_name").val();
					localStorage.username =_username;
					$('#username').html(_username);
					$('#lotNums').html(obj.data.lotteryNums);
					layer.closeAll();
					layer.msg("登录成功");
					break;
				default:
					break;
			}
            });
        });

    // 查看积分
    $('.btn-viewpoint').click(function () {
           if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){			
			_username=localStorage.getItem("username");
			$.ajax({
				url: '{{urlfor "DoorController.Login"}}',
				dataType: 'json',
				cache: false,
				type: 'POST',
				data: {gid:$("#gid").val(),account: _username},
				success: function (obj) {
					switch(obj.code){
						case 0:
							localStorage.clear();
							layer.msg(obj.msg);
							login();
							break;
						case 1:
							$("#user_name").text(_username);
							layer.open({type: 1, title: false,closeBtn:true,shadeClose: true,skin:'layui-layer-nobg',content:'<div style="width:6rem; height:2rem; overflow:hidden; background-color: #532687; text-align: center; padding-top: 1rem;">您当前有<span>'+obj.data.lotteryNums+'</span>积分</div>',end: function(){$(".tcsub").unbind();}});
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
		} else {
            login();
        }
	});
});
</script>
</body>
</html>