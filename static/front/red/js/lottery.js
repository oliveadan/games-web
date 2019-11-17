	var isClick = false;	
    var resultPid = 0;
	var resultMsg = "";
	var isChai = false;
	var Timerr;
	var bCode = "";
	
	$(function(){
		//new Marquee("marquee_rule",0,1,700,120,60,0,0);
		
		$(".js_close_dialog").click(function(){
			$(".iDialog").hide();
			$(".iDialogLayout").hide();
		})
		
	})
	


	//关闭红包
	function closebox(){
		$('#login_box').hide();
		$('#hongbao_back').hide();
	}
	
	//关闭红包层
	function close_hongbao(){
		isChai = false;
		$('#hongbao_result').find('.w2').html('恭喜发财，大吉大利!');
		$('#hongbao_open').hide();
		$('#hongbao_result').hide();
		$('#hongbao_back').hide();
		$("#hongbao_open").removeClass("out");
		$("#hongbao_result").removeClass("in").hide();
	}
	
	//关闭登录框
	function closebox(){
		$('#login_box').hide();
		$('#hongbao_back').hide();
	}
	
	
	//检查用户帐号
	function checkUser(){
		var _username = $("#username").val();
		if(_username == ""){
			layer.msg("会员帐号不能为空!");
			return false;
		}
		$.ajax({
					url: '/login',
					dataType: 'json',
					cache: false,
					type: 'POST',
					data: {gid:$("#gid").val(),account: _username},
					success: function (obj) { 
						switch(obj.code){
								case 0:
									localStorage.clear();
									layer.msg(obj.msg);
									break;
								case 1:
                                    localStorage.username =_username;
									$('#lotteryNums').text(obj.data.lotteryNums);
									$('#hongbao_open').show();
									$('#hongbao_back').show();
									break;
								default:
									layer.msg('网络错误,请稍后再抽奖');
									break;
							}
					},
					error: function(XMLHttpRequest, textStatus, errorThrown) {
							var x = 1;
							localStorage.clear();
					}
		});
	}
	
	function startGame(){
		if(isClick){
			return;
		}
		var _username = $("#username").val();
		if(_username == ""){
			layer.msg("会员帐号不能为空!");
			return false;
		}
		isClick =  true;		
		$.ajax({
			url: '/frontshare/lottery',
			dataType: 'json',
			cache: false,
			type: 'POST',
			data: {gid:$("#gid").val(),account: _username},
					success: function (obj) {
						switch (obj.code) {
							case 0:
								layer.msg(obj.msg);
								bCode = "";
								isClick = false;
								break;
							case 1:
								$('#hongbao_open').addClass("shake");
								$('#lotteryNums').text($('#lotteryNums').text()-1);
								setTimeout(function(){
									$('#hongbao_open').removeClass("shake");
									var phone =  $("#phone").val();
								  if(phone === "phone" && obj.data.photo !="") {
								        $(".reward-b").css("margin-top","1.4rem");
                                        $('#hongbao_result').find('.w3').html("<img src="+obj.data.photo+">");
                                        $('#hongbao_result').find('.w2').html(obj.data.gift);
									}else if(obj.data.photo !="" ){
                                        console.log(obj);
                                        $('.w1').css("display","none");
                                        $('.w4').css("display","none");
                                        $('#hongbao_result').find('.w3').html("<img src="+obj.data.photo+">");
                                        $('#hongbao_result').find('.w2').html(obj.data.gift);
                                    }else{
                                        $('#hongbao_result').find('.w3').html(obj.data.gift);

                                    }

									$("#hongbao_open").addClass("out").fadeOut();
									$("#hongbao_result").fadeIn().addClass("in");
									
									isClick = false;
								},2000);					
								break;
							case 2:
								$('#hongbao_open').addClass("shake");
								$('#lotteryNums').text($('#lotteryNums').text()-1);
								setTimeout(function(){
									$('#hongbao_open').removeClass("shake");
									$('#hongbao_result').find('.w2').html(obj.msg);
									$('#hongbao_result').find('.w3').html('00.00<em>元</em>');
                                    $('.w1').css("display","block");
                                    $('.w4').css("display","block");


									$("#hongbao_open").addClass("out").fadeOut();
									$("#hongbao_result").fadeIn().addClass("in");
									
									isClick = false;
								},2000);	
								break;
							default:
								layer.msg(obj.msg);
								break;
							}
						},
						failure: function () {
							//api请求失败处理
						},
						error: function(XMLHttpRequest, textStatus, errorThrown) {
								var x = 1;
								alert('网络故障,请联系管理员');
						}
				 })
		
	}
	
function queryBtn(){
	var _bonuscode = $("#querycode").val();
	if(_bonuscode == ""){
		layer.msg("会员帐号不能为空!");
		return false;
	}
	queryPage(1);
}

var pagesize = 5;

function queryPage(page){
	$.ajax({
		url: '/frontshare/lotteryquery',
		dataType: 'json',
		cache: false,
		data : {
			gid:$("#gid").val(),
			account:$("#querycode").val(),
			page:page,
			pagesize:pagesize
		},
		type: 'POST',
		success: function (res) {
			if(res.code == 1){
				var sHtml1 = "";
				var x = "";
				if(res.data.total>0) {
					$.each(res.data.list, function(i, award){
						x = (award.delivered == 1)?"<font color=yellow>已派彩</font>":"<font color=white>未派彩</font>";
					    sHtml1 +="<tr><td>"+award.gift+"</td><td>"+award.createDate+"</td><td>"+x+"</td></tr>";
					})
					var sPage = Paging(page,pagesize,res.data.total,2,"queryPage",'','','上一页','下一页');
					$(".quotes").html(sPage);							
					$("#query_content").html(sHtml1);
				} else {
					$("#query_content").html("<tr><td colspan='3'>没有中奖记录</td></tr>");
				}
			} else {
				layer.msg(res.msg);
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var x = 1;
		}
	})
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

	
