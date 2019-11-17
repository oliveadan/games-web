
	// 返回顶部
	$(window).scroll(function() {
       var top1 = $(this).scrollTop();
       if (top1>200) {
        $(".go-top").stop().fadeIn();
       }else{
        $(".go-top").stop().fadeOut();
       }
    });
    $(".go-top").click(function(){
        $("body , html").animate({scrollTop:0},300);
    });
	// 查询中奖记录

	$(".rl_search").click(function() {
		$("#rl_dialog").show();
		$("#rl_fade").show();
	});
	$(".rl_dialog_close").click(function() {
		$("#rl_dialog").hide();
		$("#rl_fade").hide();
	});
	$(".rl_searchbtn").click(function() {
		if($("#rlquerycode").val() == ""){
			layer.msg("会员帐号不能为空!", {icon: 2});
			return false;
		}
		queryPage(1);
	});
    var pagesize = 5;


	function queryPage(page){
		$.ajax({
			url: '/frontshare/lotteryquery',
			dataType: 'json',
			cache: false,
			data : {
				gid:$("#gid").val(),
				account:$("#rlquerycode").val(),
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
						$(".rl_pages").html(sPage);							
						$("#rl_content").html(sHtml1);
					} else {
						$("#rl_content").html("<tr><td colspan='3'>没有中奖记录</td></tr>");
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
	            } else{
	                returnValue += "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";
	            }
	        } else {
	            if (count == pageNum) {
	                returnValue += "<span class=\""+currentStyleName+"\">"+count.toString()+"</span> ";
	            } else{           
	                returnValue += "<a href=\"javascript:void(0);\" onclick=\""+fuctionName+"("+count.toString()+");\">"+count.toString()+"</a> ";
				}
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
                returnValue = "<a href=\"javascript:void(0);\" onclick=\""+fuctionName+"(1);\">" + firstText + "</a> " + returnValue;
			}
        }
        if(lastText !=null){
            if(pageNum < totalpage){
                returnValue = returnValue + " " + " <a href=\"javascript:void(0);\" onclick=\""+fuctionName+"("+totalpage.toString()+");\">" + lastText + "</a>";
			}
        }
        return returnValue;
	}
