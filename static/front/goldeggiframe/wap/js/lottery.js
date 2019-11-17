	var isClick = false;
	var bCode = "";
	var _username="";
	
function exit(){
	$.ajax({
		url: '/logout',
		dataType: 'json',
		cache: false,
		type: 'GET',
		success: function (obj) {
			localStorage.clear();
 			window.location.reload();
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var x = 1;
		}
	})
}

function checkUser() {
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
					$('.logined').fadeIn();
					$('#username').html(_username);					
					$('#draw').html(obj.data.lotteryNums);
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
function checklogin(obj){
	var _this = obj;
	if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){			
		_username=localStorage.getItem("username");
		startGame(_this);
	} else{
		layer.open({type: 1, title: false,closeBtn:true,shadeClose: true,skin:'layui-layer-nobg',content:$('.tclogin'),end: function(){$(".tcsub").unbind();}});
		$(".tcsub").click(function(){
			if($("#user_name").val()==""){
				layer.msg("会员帐号不能为空!");
				return false;
			} else{
				$.ajax({
					url: '/login',
					dataType: 'json',
					cache: false,
					type: 'POST',
					data: {gid:$("#gid").val(),account: $("#user_name").val()},
					success: function (obj) {
						switch(obj.code){
							case 0:
								layer.msg(obj.msg);
								break;
							case 1:
								$('.logined').fadeIn();
								_username =$("#user_name").val();
								localStorage.username =_username;
								$('#username').html(_username);					
								$('#draw').html(obj.data.lotteryNums);
								startGame(_this);
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
		})			
	}
}
	
	function startGame(obj){	
		var _this = obj;
		if(isClick){
			return;
		}
		if(isture){
			return;
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
							layer.closeAll();
							var prize_name = obj.data.gift;
							var prize_id = obj.data.seq;
							if(obj.data.photo !=""){
							$(".picture").html("<img src="+obj.data.photo+">");
							$(".tcwin").css({"background":"url(static/front/goldegg/images/tcwin1.png) no-repeat","background-size":"cover"})
                            }
							$(".wintext").html("恭喜您获得<b>"+prize_name+"</b>");
							isClick = false;
							$('#draw').html($('#draw').text()-1);
							eggClick(_this,0);
							break;
						case 2:
							layer.closeAll();
							$(".wintext").html("");
							isClick = false;
							$('#draw').html($('#draw').text()-1);
							eggClick(_this,10);
							break;
						default:
							layer.msg(obj.msg,{icon: 5,time:1800});
							}
						},
						failure: function () {
							//api请求失败处理
						},
						error: function(XMLHttpRequest, textStatus, errorThrown) {
								var x = 1;
								layer.msg('网络故障,请联系管理员',{icon: 5,time:1800});
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

	
