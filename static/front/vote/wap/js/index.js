var buteNameBean = "";
var inputMsg="";
var inputNameList="";
var msg="";
var pageSize = 6;//每页行数 
var currentPage=1;
var flag=true;
var rightactivehtml="";
var applyHtml="";
var applyshowHtml="";
$(function() {
	var html = "";
	var activehtml = "";
	var annouVal = "";
	var annouValHtml = "";
	$
			.ajax({
				type : "POST",
				async : false,
				url : "/vns/baseAction.do",
				data : {
					ctrl_action : "applyAction",
					ctrl_method : "queryUnEditTeams"
				},
				success : function(data) {
					var len = data.length;

					var status = "";
					var userjk = "";
					for ( var i = 0; i < len; i++) {

						if (data[i].status == 0) {
							status = "<font color=blue>等待审核</font>";
						} else if (data[i].status == 1) {
							status = "成功办理";
						} else if (data[i].status == 2) {
							status = "<font color=red>已拒绝</font>";
						}
						if (data[i].account.length >= 4) {
							userjk = data[i].account.substr(0, 4)
									+ "***";
						} else {
							userjk = data[i].account;
						}
						var k = data[i].activeName;
						
						var topHtml = "<li><div class='col-1'>恭喜:<span class='spa-1'>"
							+ userjk
							+ "</span> </div>"
							+ "<div class='col-2'>"+status+"<span class='spa-2'>"+data[i].activeName + "</span></div></li>";
					    html += topHtml;
						
					}
					$("#view_apply").html(html);
					jQuery(".mod-nav").slide({mainCell:".bd ul",autoPlay:true,effect:"topMarquee",vis:6,interTime:50,trigger:"click"});
				},
				dataType : "json"
			});
	
	

	 //悬浮广告
	  var duilian = $("div.duilian");
	  var duilian_close = $("a.duilian_close");

	  var screen_w = screen.width;
	  if(screen_w>1024){duilian.show();}
	  $(window).scroll(function(){
	    var scrollTop = $(window).scrollTop();
	    duilian.stop().animate({top:scrollTop+160});
	  });
	  duilian_close.click(function(){
	    $(this).parent().hide();
	    return false;
	  });
	//unslider
	  var unslider01 = $('#s01').unslider({
	    dots: true
	  }),
	  data01 = unslider01.data('unslider');

	  $('.unslider-arrow04').click(function() {
	        var fn = this.className.split(' ')[1];
	        data01[fn]();
	    });

	  $(".slider-close").click(function(){
	    $('#s01').hide();
	  })
	

});
//弹出1
function showDetail() {
	  var bgObj=document.getElementById("bgDiv");
	    bgObj.style.width = document.body.offsetWidth + "px";
	    bgObj.style.height = document.body.offsetHeight + "px";

	    var msgObj=document.getElementById("msgDiv");
	    msgObj.style.marginTop = -300 +  document.documentElement.scrollTop + "px";

	    document.getElementById("msgShut").onclick = function(){
	    bgObj.style.display = msgObj.style.display = "none";
	    }
	    msgObj.style.display = bgObj.style.display = "block";
	    // msgDetail.innerHTML=""
}
$(function() {
	  $('.j-btns-modal').click(function(){
		    showDetail();
		    $("#account").val("");
		    $('#modal-1').show();
		    $('#modal-2').hide();
		    $('#modal-3').hide();
		  });

		  $('.j-btn-submit').click(function(){
			  if ($("#account").val() == "") {
					alert('请填写会员帐号');
					return false;
				}
				if ($("#search_activeName").val() == "") {
					alert('请选择查询项目!');
					return false;
				}
				searchApplyList(currentPage);
		    $('#modal-1').hide();
		    $('#modal-2').show();
		    $('#modal-3').hide();
		  });

		  $('.j-btn').click(function(){
		    showDetail();
		    $('#modal-3').show();
		    $('#modal-1').hide();
		    $('#modal-2').hide();
		  });

		  $('.j-btn-back').click(function(){
		    $('#msgDiv,#bgDiv').hide();
		  });


});
function searchApplyList(currentPage) {
	 var strongList= "";
	  var countHtml;
	$
			.ajax({
				type : "POST",
				async : false,
				url : "/vns/baseAction.do",
				data : {
					ctrl_action : "applyAction",
					ctrl_method : "queryCurUserInfo",
					activeId : $("#search_activeName").val(),
					account : $("#account").val(),
					page:currentPage,
					rows:pageSize
				},
				success : function(data) {
					var len = data.rows.length;
					var dataList=data.rows;
					var total=data.total;
					var row=Math.ceil(total/pageSize);
					for ( var i = 1; i <= row; i++){
						
						var strongRef="";
						
					    strongRef="<a href='#' onclick='searchApplyList("+i+")'>"+i+"</a>";
					
						strongList += strongRef;
					   
					}
					$("#pageHtml").html(strongList);
					$("#applyMsg").html("");
					$("#applyMsg")
							.append(
									"<tr><td>会员账号</td><td>申请时间</td><td>审核状态</td><td>回复信息</td>");
					if (len == 0) {
						$("#applyMsg").append(
								"<tr> <td colspan=4>未查询到信息</td></tr>");

					}
					var status = "";
					for ( var i = 0; i < len; i++) {
						if (dataList[i].status == 0) {
							status = "<font color=blue>等待审核</font>";
						} else if (dataList[i].status == 1) {
							status = "<font color=green>已通过</font>";
						} else if (dataList[i].status == 2) {
							status = "<font color=red>已拒绝</font>";
						}
						$("#applyMsg").append(
								"<tr><td>" + dataList[i].account + "</td><td>"
										+ dataList[i].addTime + "</td><td>"
										+ status + "</td><td><span class='tip' title='" + dataList[i].tips + "'>点击查看</span></td></tr>");
						$('.tip').miniTip({'className':'green'});
					}

				},
				dataType : "json"
			});
}


function getModerName(showval) {
	getmoderInputName(showval);
	showDetail();
	$('#modal-1').hide();
	$('#modal-2').hide();
	$('#modal-3').show();

}
function getActive(){
    var objS = document.getElementById("search_activeName");
    var grade = objS.options[objS.selectedIndex].text;
    $("#activeName").html(grade); 
   }    
function getmoderInputName(showval) {
	isflag = true;
	var activehtml = "";
	$("#activeId").val(showval);
	inputMsg="";

	$
			.ajax({
				type : "POST",
				async : false,
				url : "/vns/baseAction.do",
				data : {
					ctrl_action : "activeAction",
					ctrl_method : "queryByAttribuName",
					id : showval
				},
				success : function(data) {
					buteLen = data.length;
					var attrib = "attrib";
					var butename = "";
					var bute_name;
					var inputName;
					var topHtml;
					buteNameBean = "";
					for ( var i = 0; i < buteLen; i++) {
					//	attrib = attrib + i;
						bute_name = data[i].butename + "：";
						buteNameBean += data[i].butename + ",";
						inputMsg+=data[i].butename+",";
						placeInput="请填写您的"+data[i].butename;
						if (data[i].butetype == 5) {
							inputName = "<input id='"
									+ attrib
									+ "'  type='text' placeholder='"+placeInput+"' class='Wdate' style='float:left;width:300px;height:36px;padding:0 5px;border:0;color:#000;font-size:14px;' onfocus='WdatePicker({dateFmt:\"yyyy-MM-dd HH:mm:ss\",alwaysUseStartDate:true})'>";
						} else if (data[i].butetype == 2) {
							inputName = "<input class='ipt'  placeholder='"+placeInput+"' type='text' id='"
									+ attrib + "'  ";
						} else {
							inputName = "<input class='ipt' placeholder='"+placeInput+"' type='text' id='"
									+ attrib + "'  ";
						}

						var topHtml = "<li ><label for=''>" + bute_name
								+ "</label>" + inputName + "</li>";
						activehtml += topHtml;
					}
					
                    var applyzt="<li><label for=''>申请主题：</label> <div class='cont'><b class='fc-yellow' id='detailActiveName'></b></div></li>";
					var attrihtml = "<li> <label for=''>会员帐号：</label><input class='ipt' type='text' name='apply_account' id='apply_account' placeholder='请填写会员账号'  ></li>";
					var yzmhtml = "<li><label for=''>验证码：</label><div class='yzmbox'> <input class='ipt' type='text' name='cfCode' id='cfCode' placeholder='请填写验证码' ><img class='yzmimg' id='verifycode' src='/vns/verifyCodeAction.do' onerror='this.style.display='none''/></div></li>";
					
					var buttomhtml = " <li><label for=''></label><button  class='btn-submit2' type='button'  id='save_button'  name='save_button' /></li>";
					 
					$("#attribuConfig").html(
							applyzt+attrihtml + activehtml + yzmhtml + buttomhtml);
					
				},
				dataType : "json"
			});
	$.ajax({
		type : "POST",
		async : false,
		url : "/vns/baseAction.do",
		data : {
			ctrl_action : "activeAction",
			ctrl_method : "queryByActiveName",
			id : showval
		},
		success : function(data) {
			var len = data.length;
			if (len > 0) {
				var rft="detail.html?id="+showval;
				var detailHtml= "&nbsp;&nbsp;&nbsp;&nbsp;<a  href='"+rft+"' target='_blank'>查看详情</a>";
				
				$("#detailActiveName").html(data[0].activeName+  detailHtml);

			}

		},
		dataType : "json"
	});
	$("#verifycode").click(function() {
		var rand = parseInt(Math.random() * (100 - 0 + 1));
		var src = $("#verifycode").attr("src");
		$("#verifycode").attr("src", src + "?" + rand);
	});
	$('.j-btns-modal').click(function() {
		$("#account").val("");
		showDetail();
		$('#modal-1').show();
		$('#modal-2').hide();
		$('#modal-3').hide();
	});
	$("#save_button").click(function() {
		inputNameList="";
		msg="";
		var str = $("#apply_account").val();
		if (str == "") {
			alert("会员账号不为空！");
			return false;
		}
		var regu = "^[ ]+$";
		var re = new RegExp(regu);
		if (re.test(str) == true) {
			alert("会员账号不为空！");
			return false;
		}
		getElements("accountform");
		if (flag){
			flag=false;
		$.ajax({
			type : "POST",
			url : "/vns/baseAction.do",
			data : {
				ctrl_action : "applyAction",
				ctrl_method : "applySaveMold",
				activeId : $("#activeId").val(),
				account : $("#apply_account").val(),
				cfCode : $("#cfCode").val(),
				amount : inputNameList,
				buteNameList : buteNameBean

			},
			success : function(data) {
				if (data.code == "02") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code == "01") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code == "001") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code == "002") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code == "003") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code == "004") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code == "005") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code == "0003") {
					flag=true;
					alert(data.desc);
					return false;
				} else if (data.code == "0004") {
					flag=true;
					alert(data.desc);
					return false;
				} else if (data.code == "0005") {
					flag=true;
					alert(data.desc);
					return false;
				} else if (data.code == "0008") {
					flag=true;
					alert(data.desc);
					return false;
				} else if (data.code=="0006") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code=="0007") {
					flag=true;
					alert(data.desc);
					return false;
				}else if (data.code=="0009") {
					   flag=true;
						alert(data.desc);
						return false;
				}else {
					alert("操作成功");
					window.location.reload(true);
				}

			},
			ajaxError : function(data) {
				flag=true;
				alert("服务出错");
			},
			dataType : "json"
		});
		}
	});

}
function Trim(str) {
	return str.replace(/(^\s*)|(\s*$)/g, "");
}
function fun(){
	var name=document.getElementsByTagName("input");
	for(var i=0;i<name.length;i++)
	{
	  alert(name[i].id);
	}
 
}

function getElements(formId) {  
	
    var form = document.getElementById(formId);
     msg = inputMsg.split(",");
    var tagElements = form.getElementsByTagName('input');  
    var vnsname="";
    for (var j = 2; j < tagElements.length-1; j++){ 
    	
    	if (tagElements[j].value==""){
    		vnsname=" ";
    		var str = tagElements[j].value;
   			var regu = "^[ ]+$";
   			var re = new RegExp(regu);
   			if (re.test(str) == true) {
   				vnsname=" ";
   			}
    	}else{
    		vnsname=tagElements[j].value;
    		
    	}
     
    	inputNameList+=vnsname+",";
    	
    } 

    
}   
  