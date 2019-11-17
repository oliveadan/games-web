	var isClick = false;
	var bCode = "";
	var _username="";
	
	function exit(){
	 localStorage.clear();
	 window.location.reload();
	}
	function checkUser(){
	$.ajax({
		url: 'ajax.php?action=check',
		dataType: 'json',
		cache: false,
		type: 'POST',
		data: {username: _username},
		success: function (obj) {  
			switch(obj.stat){
				case '-1':
					alert('获取用户名失败！');
					break;
				case '-2':
					alert('用户未注册！');
					break;
				case '0':
					$('.logined').fadeIn();
					$('#username').html(obj.username);					
					$('#draw').html(obj.draw);
					break;
				default:
					break;
			}
		},
		error: function(XMLHttpRequest, textStatus, errorThrown) {
			var x = 1;
		}
	}) 
}	
	
	function checklogin(){	
		 if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){			
				_username=localStorage.getItem("username");
				startGame();
		}
		else{
			layer.open({type: 1, title: false,closeBtn:true,shadeClose: true,skin:'layui-layer-nobg',content:$('.tclogin'),area:["5.65rem"],end: function(){$(".tcsub").unbind();}});
				$(".tcsub").click(function(){
					if($("#user_name").val()==""){alert("输入会员帐号不能为空!");return false;}
					else{
					_username =$("#user_name").val();
					startGame();
					}								
				})			
		}

	}
	
	function startGame(){	
		if(isClick){
			return;
		}
		if(isture){
			return;
		}		
		isClick =  true;		
		$.ajax({
					url: 'bonus.php',
					dataType: 'json',
					cache: false,
					type: 'POST',
					data: {username: _username},
					success: function (obj) {
						switch (obj.stat) {
							case '-1':
								layer.msg('您输入的信息不能为空',{icon: 5,time:1800});
								$("#user_name").val("").focus();
								bCode = "";
								isClick = false;
								break;	
							case '-2':								
								layer.msg('您的帐号无法参与!',{icon: 5,time:1800});
								$("#user_name").val("").focus();
								bCode = "";
								isClick = false;
								break;
							case '-3':					
								layer.msg('您的帐号次数已经用完!',{icon: 5,time:1800});
								$("#user_name").val("").focus();
								bCode = "";
								isClick = false;
								break;
							case '-4':						
								layer.msg('当前时段未开启大转盘',{icon: 5,time:1800});
								bCode = "";
								isClick = false;
								break;
							case '5':						
								layer.msg(obj.msg,{icon: 5,time:1800});
								isClick = false;
								break;	
							case '0':
								layer.closeAll();
								$(".wintext").html("");
								var prize_name = obj.prize_name;
								var prize_id = obj.prize_id;
								var angle=-(prize_id-1)*36;
								rotateFunc(prize_id,angle,"恭喜您获得<b>"+prize_name+"</b>");							
								isClick = false;
								localStorage.username =_username;						
								checkUser();
								break;
							case '9':
								layer.closeAll();
								$(".wintext").html("");
								var prize_name = obj.prize_name;
								var prize_id = obj.prize_id;
								var angle=-(prize_id-1)*36;
								rotateFunc(prize_id,angle,"恭喜您获得<b>"+prize_name+"</b>");							
								isClick = false;
								localStorage.username =_username;
								checkUser();
								break;
							case '10':
								layer.closeAll();
								$(".wintext").html("");
								var msg = obj.desc;
								var prize_name = obj.prize_name;
								var prize_id = obj.prize_id;
								var angle=-(prize_id-1)*36;
								rotateFunc(prize_id,angle,"没有中奖，祝您"+msg);					
								isClick = false;
								localStorage.username =_username;
								checkUser();
								break;
							default:
								layer.msg(obj.msg,{icon: 5,time:1800});
								break;
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

			alert("输入会员帐号不能为空!");

			return false;

		}

		queryPage(1);
		
	}

var pagesize = 5;



function queryPage(page){

				$.ajax({

					url: 'ajax.php?action=querylist&p='+page+'&size='+pagesize,

					dataType: 'json',

					cache: false,

					data : {querycode:$("#querycode").val()},

					type: 'GET',

					success: function (obj) {

						if(obj.count != 0){

							var sHtml1 = "";
							
							var x = "";

							$.each(obj.data, function(i, award){

								x = (award.is_send == 1)?"<font color=yellow>已派彩</font>":"<font color=white>未派彩</font>";
							
							    sHtml1 +="<tr><td>"+award.prize_value+"</td><td>"+award.won_time+"</td><td>"+x+"</td></tr>";

							})

							var sPage = Paging(page,pagesize,obj.count,2,"queryPage",'','','上一页','下一页');

							$(".quotes").html(sPage);							

							$("#query_content").html(sHtml1);

						}else{

							$("#query_content").html("<tr><td colspan='3'>未找到相关信息</td></tr>");

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

	
