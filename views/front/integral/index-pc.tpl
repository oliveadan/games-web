<!DOCTYPE html>
<html lang="zh-cn">
<head>
	<meta charset="utf-8">
	<meta HTTP-EQUIV="pragma" CONTENT="no-cache"> 
	<meta HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate"> 
	<meta HTTP-EQUIV="expires" CONTENT="0">
    <meta name="renderer" content="webkit">
	<meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="keywords" content="">
    <meta name="description" content="">
	<title>{{.siteName}}-{{.gameDesc}}</title>
	<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" href="{{static_front}}/static/front/integral/css/common.css">
    <!--[if lt IE 9]>
    <script src="//cdn.bootcss.com/html5shiv/r29/html5.min.js"></script>
    <![endif]-->
</head>
<body>
    <header>
        <div class="head-top">
            <div class="clearfix">
                <a href="{{.officialSite}}" target="_blank" class="top-a">网站首页</a>
                {{if .rechargeSite}}<a href="{{.rechargeSite}}" target="_blank" class="top-a">快速充值中心</a>{{end}}
                {{if .officialPartner}}<a href="{{.officialPartner}}" target="_blank" class="top-a">合作经营</a>{{end}}
                <a href="{{urlfor "IntegralApiController.Get"}}" target="_blank" class="top-a">积分商城</a>
                {{if .officialPromot}}<a href="{{.officialPromot}}" target="_blank" class="top-a">优惠活动</a>{{end}}
                {{if .officialRegist}}<a href="{{.officialRegist}}" target="_blank" class="top-a">免费注册</a>{{end}}
                <a href="{{.custServ}}" target="_blank" class="top-a">在线客服</a>
                <a href="#" target="_blank" class="js-select top-a">查看兑换记录</a>
                <a href="#" class="top-a last js-login">会员登录</a>
				<div class="top-div last logout-div">
					<span>会员</span><span id="username"></span>
					<a href="#" class="top-a last js-loginout">退出</a>
				</div>
            </div>
        </div>
        <div class="head-cnt js-goto1-offset">
            <div class="container" id="showHeader">
            </div>
        </div>
    </header>
    <div class="main">
        <div class="container">
			<input type="hidden" id="gid" value="{{.gameId}}">
            <div class="box-t1">
                <p>活动内容</p>
                <button class="btn-viewpoint">登录查看当前积分</button>
                <button class="btn-getflow">获取活动积分流程</button>
            </div>
            <div class="box box1">
                <div class="box-top">
                    <p class="tips">会员在{{.siteName}}进行存款，每一笔存款金额都将永久累计，并转换为积分，只要您有积分，即可任意选择您要兑换的商品，积分越多，可兑换的商品也越多，掌握时代的节奏，赶快邀请您的好友加入{{.siteName}}抱回超级大奖！</p>
                    <div class="title title1 js-goto2-offset">积分说明</div>
                    <div class="cnt cnt1">{{.announcement}}</div>
                    <div class="title title2 js-goto3-offset">积分兑换</div>
                    <div class="cnt cnt2">
                        <p>兑换之前，建议您先行查询现有的会员积分数，再选择要您要兑换的现金券。<a class="js-select" href="javascript:;">查看兑换记录 >></a></p>
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
            <div class="flow-box">
                <button class="btn-flow">点击查看活动流程</button>
                <p class="flow1">
                    <button class="btn-recharge js-getUrl">马上存款获取积分</button>
                    <span>系统将于北京时间每周四下午15点结算一周的累计存款，超出累计时间的积分将会累计到下一周进行结算。</span>
                </p>
                <p class="flow2"></p>
            </div>
            <div class="box-t2 js-goto4-offset">
                <p>活动细则</p>
            </div>
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
    <div class="cs-box">
        <ul>
            <li><a href="#" class="js-goto1">首页</a></li>
            <li><a href="#" class="js-goto2">积分说明</a></li>
            <li><a href="#" class="js-goto3">积分兑换</a></li>
            <li><a href="#" class="js-goto4">活动细则</a></li>
            <li><a href="#" class="js-showcs" data-url="{{.custServ}}">在线客服</a></li>
            <li><a href="#" class="js-gototop">TOP</a></li>
        </ul>
    </div>
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
    <script src="{{static_front}}/static/front/integral/js/common.min.js"></script>
    <script>
        var bgUrl1 = '/static/front/integral/images/header-bg1.jpg';
        var bgUrl2 = '/static/front/integral/images/header-bg2.jpg';
        var logoUrl = '/static/img/logo240x80.png';
    </script>
    <script src="{{static_front}}/static/front/integral/js/header-data.js"></script>
    <script src="{{static_front}}/static/front/integral/js/header.js"></script>
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
						$(".js-login").show();
						$(".logout-div").hide();
						break;
					case 1:
						$("#username").text(_username);
						$(".js-login").hide();
						$(".logout-div").show();
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
	</script>
    <script>
        $(function () {
            $('.js-getUrl').click(function () {
                window.open('{{or .rechargeSite .officialSite}}', '_blank');
            });
            //会员登陆 弹窗 获取验证码
            $('.js-login').click(function () {
                util.dialog({
                    title: '会员登录',
                    width: 400,
                    content: '<div id="loginDialog" class="login-dialog">\
              <ul class="ipt-w">\
                <li><input type="text" class="username" placeholder="请输入登录账号"></li>\
                <li>\
                  <input type="text" class="vcode" maxlength="6" placeholder="请输入验证码">\
                  {{create_captcha}}\
                </li>\
              </ul>\
                <div class="opt-w">\
                <a href="{{.officialSite}}" target="_blank">立即注册</a>\
              </div>\
              <div class="btn-w"><button id = "login-btn" class="btn btn-ok yellow">立即登录</button></div>\
            </div>',
                    loaded: function () {
                        // login logic processing
                    }
                });
            });

            //会员退出
            $('.js-loginout').click(function () {
                $.post('{{urlfor "DoorController.Logout"}}', function (result) {
					localStorage.clear();
                    window.location.reload();
                });
            });

            //验证会员登陆
            $('body').on('click', '#login-btn', function () {
                $.post('{{urlfor "DoorController.LoginCpt"}}', {gid: $('#gid').val(), account: $('.username').val(), captcha_id: $(":input[name='captcha_id']").val(),captcha: $('.vcode').val() }, function (result) {
                    switch(result.code){
						case 0:
							localStorage.clear();
							util.notify(result.msg);
							break;
						case 1:
							localStorage.username = $('.username').val();
							util.notify(result.msg);
							setTimeout(function(){
								util.closeDialog();
								window.location.reload();
							},1000);
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
									$(".js-login").show();
									$(".logout-div").hide();
									$('.js-login').click();
									break;
								case 1:
									$("#username").text(_username);
									$(".js-login").hide();
									$(".logout-div").show();
									util.dialog({
										title: '查看积分',
				                    	width: 400,
										height: 200,
				                    	content: '<div class="integral-review">您当前有<span>'+obj.data.lotteryNums+'</span>积分</div>',
				                    	loaded: function () {
				                        // login logic processing
				                    	}
									});
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
                	$('.js-login').click();
                }
            });
			
            // 活动流程
            $('.btn-getflow').click(function () {
                if ($('.btn-flow').hasClass('btn-hide')) {
                    $('.btn-flow').trigger('click');
                } else {
                    util.gotoTop({
                        el: '.btn-flow',
                        time: 500
                    });
                }
            });
            $('.btn-flow').click(function () {
                $(this).toggleClass('btn-hide');
                $('.flow-box').toggleClass('flow-hide');
                if (!$(this).hasClass('btn-hide')) {
                    util.gotoTop({
                        el: '.btn-flow',
                        time: 500
                    });
                }
            });
            // cs box
            $(window).scroll(function () {
                var topVal = $(this).scrollTop(),
                  csBox = $('.cs-box');
                if (topVal > 750) {
                    var tmpVal = topVal + ($(this).height() - csBox.outerHeight()) * 0.5;
                    csBox.css({
                        top: tmpVal + 'px'
                    });
                } else {
                    csBox.css({
                        top: '750px'
                    });
                }
            });
            $('.js-goto1').click(function () {
                util.gotoTop({
                    el: '.js-goto1-offset',
                    time: 500
                });
            });
            $('.js-goto2').click(function () {
                util.gotoTop({
                    el: '.js-goto2-offset',
                    time: 500
                });
            });
            $('.js-goto3').click(function () {
                util.gotoTop({
                    el: '.js-goto3-offset',
                    time: 500
                });
            });
            $('.js-goto4').click(function () {
                util.gotoTop({
                    el: '.js-goto4-offset',
                    time: 500
                });
            });
            $('.js-showcs').on('click', function () {
                var o = $('<a href="' + $(this).attr('data-url') + '" target="_blank">&nbsp;</a>').appendTo($('body'));
                o[0].click();
                o.remove();
            });
            $('.js-gototop').on('click', function () {
                util.gotoTop();
            });

            $('.js-select').click(function () {
                if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){			
					_username=localStorage.getItem("username");
					showList(1);
				} else {
                	$('.js-login').click();
                }
            });
        });

        //积分兑换
        function excharge(giftid) {
            if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){			
				_username=localStorage.getItem("username");
				$.ajax({
					url: '{{urlfor "IntegralApiController.Post"}}',
					dataType: 'json',
					cache: false,
					type: 'POST',
					data: {gid:$("#gid").val(),account: _username,giftid:giftid},
					success: function (obj) {
						util.dialog({
						title: obj.code==1?"兑换成功":"兑换失败",
                   		width: 400,
						height: 200,
                   		content: '<div class="integral-review">'+obj.msg+'</div>',
                   		loaded: function () {
                    	   // login logic processing
                   		}
					});
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					util.dialog({
						title: '系统错误',
                   		width: 400,
						height: 200,
                   		content: '<div class="integral-review">请求异常，请刷新后重试</div>',
                   		loaded: function () {
                    	   // login logic processing
                   		}
					});
				}
				}) 
			} else {
             	$('.js-login').click();
           	}
        }
		
        function showList(page) {
			var pagesize = 5;
            $.post('{{urlfor "LotteryController.LotteryQuery"}}', {
				gid:$("#gid").val(),
				account:_username,
				page:page,
				pagesize:pagesize
			}, function (res) {
                var strHTML = '';
                var data = res.data.list;
                if (res.data.total > 0) {
                    for (i = 0; i < data.length; i++) {
                        strHTML += '<tr>';
                        strHTML += '<td>' + data[i].account + '</td>';
                        strHTML += '<td>' + data[i].gift + '</td>';
                        strHTML += '<td>' + data[i].createDate + '</td>';
                        strHTML += '<td>' + (data[i].delivered==1?"已派彩":"未派彩") + '</td>';
						var sPage = Paging(page,pagesize,res.data.total,2,"showList",'','','上一页','下一页');
						$(".quotes").html(sPage);
                        $('#query_content').html(strHTML);
                    }
                } else {
                    strHTML += '<tr><td colspan="4">暂无兑换记录</td></tr>';
                    $('#query_content').html(strHTML);
                }
				$("#light").show();
				$("#fade").show();
            });
        }
		
	function Paging(pageNum,pageSize,totalCount,skipCount,fuctionName,currentStyleName,currentUseLink,preText,nextText,firstText,lastText){
	    var returnValue = "";
	    var begin = 1;
	    var end = 1;
	    var totalpage = Math.floor(totalCount / pageSize);
	    if(totalCount % pageSize >0){
	        totalpage ++;
	    }	   
	    if(preText == null){
	        firstText = "prev";
	    }
	    if(nextText == null){
	        nextText = "next";
	    }
	    begin = pageNum - skipCount;
	    end = pageNum + skipCount;
	    if(begin <= 0){
	        end = end - begin +1;
	        begin = 1;
	    }
	    if(end > totalpage){
	        end = totalpage;
	    }
	    for(count = begin;count <= end;count ++){
	        if(currentUseLink){ 
	            if(count == pageNum){
	                returnValue += "<a class=\""+currentStyleName+"\" href=\"javascript:void(0);\" onclick=\""+fuctionName+"("+count.toString()+");\">"+count.toString()+"</a> ";
	            }
	            else{
	                returnValue += "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";
	            }
	        }
	        else {
	            if (count == pageNum) {
	                returnValue += "<span class=\""+currentStyleName+"\">"+count.toString()+"</span> ";
	            }
	            else{           
	                returnValue += "<a href=\"javascript:void(0);\" onclick=\""+fuctionName+"("+count.toString()+");\">"+count.toString()+"</a> ";}
	            }
	        }
	        if(pageNum - skipCount >1){
	            returnValue = " ... "+returnValue;
	        }
	        if(pageNum + skipCount < totalpage){
	            returnValue = returnValue + " ... ";
	        }
	        if(pageNum > 1){
	            returnValue = "<a href=\"javascript:void(0);\" onclick=\""+fuctionName+"("+(pageNum - 1).toString()+");\"> " + preText + "</a> " + returnValue;
	        }
	        if(pageNum < totalpage){
	            returnValue = returnValue + " <a href=\"javascript:void(0);\" onclick=\""+fuctionName+"("+(pageNum+1).toString()+");\">" + nextText + "</a>";
	        }
	        if(firstText!= null){
	            if(pageNum >1){
	                returnValue = "<a href=\"javascript:void(0);\" onclick=\""+fuctionName+"(1);\">" + firstText + "</a> " + returnValue;}
	        }
	        if(lastText !=null){
	            if(pageNum < totalpage){
	                returnValue = returnValue + " " + " <a href=\"javascript:void(0);\" onclick=\""+fuctionName+"("+totalpage.toString()+");\">" + lastText + "</a>";}
	        }
	        return returnValue;
	}
    </script>
</body>
</html>