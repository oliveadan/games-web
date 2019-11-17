var buteNameBean="";
var pageSize = 6;//每页行数 
var currentPage=1;
var inputMsg="";
var inputNameList="";
var msg="";
var flag=true;
var html="";
//弹出1
function showDetail() {
  var bgObj=document.getElementById("bgDiv");
  bgObj.style.width = document.body.offsetWidth + "px";
  bgObj.style.height = document.body.offsetHeight + "px";

  var msgObj=document.getElementById("msgDiv");
  msgObj.style.marginTop = -300 +  document.documentElement.scrollTop + "px";

  document.getElementById("msgShut").onclick = function(){
  bgObj.style.display = msgObj.style.display = "none";
  };
  msgObj.style.display = bgObj.style.display = "block";
  // msgDetail.innerHTML=""
}
$(function(){
    $('.j-btns-modal').click(function(){
    $("#account").val("");
    showDetail();
     $('#modal-1').show();
     
      getSelect();
      $('#modal-2').hide();
      
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
      
    });



    $('.j-btn-back').click(function(){
      $('#msgDiv,#bgDiv').hide();
    });
  

  });
$(function() {
       var annouVal="";
       var html = "";
        var activehtml = "";
        var thisURL = document.URL;  
        thisURL=thisURL.replace("#",""); 
        var buteLen="";
  	  var  getval ="";
  	   var showval= "";
  	   var stausFlag=0;
  	 if(thisURL.indexOf("?") > 0 ){
  	    getval =thisURL.split('?')[1];  
  	   }
   	 if(thisURL.indexOf("?") > 0 ){
 		  showval= getval.split("=")[1];
 		 
 		//  showval=showval.split("&")[0]; 
 		  if(showval.indexOf("&&") > 0 ){
               getval =thisURL.split('&&')[1];  		  
 	  		  showval=getval.split("=")[1];
 			  stausFlag=2;  
 		  }
 		  if(showval.indexOf("&") > 0 ){
 	  		  getval =thisURL.split('&')[1];
 	  		  showval=getval.split("=")[1]; 
 	  		  stausFlag=1; 
 	  	 }
 		  
 		  
 	   }
   	 if (stausFlag==2){
		  document.getElementById("accountform").style.display="none";
	   }else{
		 document.getElementById("accountform").style.display=""; 
	   }
  	 var applyAllName;
  	$("#activeId").val(showval);
  
     
      $.ajax({
			type : "POST",
			async : false,
			url : "/vns/baseAction.do",
			data : {
				ctrl_action : "activeAction",
				ctrl_method : "queryByActiveName",
				id :showval
			},
			success : function(data) {
				var len = data.length;
				if (len>0){
					 $("#activeContent").html(data[0].activeContent);
					 $("#queryActiveName").html(data[0].activeName);
					 $("#activeName").html(data[0].activeName);
					 
				}
			   
				

			},
			dataType : "json"
		});
    
      getmoderInputName(showval);
      
      $("#verifycode").click(function(){
			var rand = parseInt(Math.random() * (100 - 0 + 1));  
			var src=$("#verifycode").attr("src");    
			$("#verifycode").attr("src",src+"?"+rand);
		});
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
					
					var topHtml = "会员：<span>"+userjk+"</span>"+status+"<span>"+data[i].activeName + "</span>";
							
					html += topHtml;
				}
				$("#view_apply").html(html);

			},
			dataType : "json"
		});
      
       });

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
									+ "'  type='text' placeholder='"+placeInput+"' class='Wdate' style='float:left;width:250px;height:36px;padding:0 5px;border:0;color:#000;font-size:14px;' onfocus='WdatePicker({dateFmt:\"yyyy-MM-dd HH:mm:ss\",alwaysUseStartDate:true})'>";
						} else {
							inputName = "<input class='ipt' placeholder='"+placeInput+"' type='text' id='"
									+ attrib + "'  ";
						}

						var topHtml = "<li ><label for=''>" + bute_name
								+ "</label>" + inputName + "</li>";
						activehtml += topHtml;
					}
					

					var attrihtml = "<li> <label for=''>会员帐号：</label><input class='ipt' type='text' name='apply_account' id='apply_account' placeholder='请填写会员账号'  ></li>";
					var yzmhtml = "<li><label for=''>验证码：</label><div class='yzmbox'> <input class='ipt' type='text' name='cfCode' id='cfCode' placeholder='请填写验证码' ><img class='yzmimg' id='verifycode' src='/vns/verifyCodeAction.do' onerror='this.style.display='none''/></div></li>";
					var buttomhtml = " <li><label></label><button  class='btn-sub' type='button'  id='save_button'  name='save_button'>提交申请</button></li>";
				
					$("#attribuConfig").html(
							attrihtml + activehtml + yzmhtml + buttomhtml);
					 
				},
				dataType : "json"
			});
	
	$("#verifycode").click(function() {
		var rand = parseInt(Math.random() * (100 - 0 + 1));
		var src = $("#verifycode").attr("src");
		$("#verifycode").attr("src", src + "?" + rand);
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

		if (Trim(str).length < 4) {
			alert("您输入会员账号不规范！");
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

  function Trim(str)
  { 
      return str.replace(/(^\s*)|(\s*$)/g, ""); 
    }
 
  function getSelect(){
	  document.getElementById("search_activeName").innerHTML = "";
      $.ajax({
			type : "POST",
			async : false,
			url : "/vns/baseAction.do",
			data : {
				ctrl_action : "activeAction",
				ctrl_method : "queryUnEditTeams"
			},
			success : function(data) {
				var len = data.length;
				var sel = document.getElementById("search_activeName");
				
				for ( var i = 0; i < len; i++) {
					var option = document.createElement('option');
					option.value = data[i].id;
					option.text = data[i].activeName;
					sel.options.add(option);
					
				}

			},
			dataType : "json"
		});
      }      
  function getActive(){
      var objS = document.getElementById("search_activeName");
      var grade = objS.options[objS.selectedIndex].text;
      $("#queryActiveName").html(grade); 
     }    
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
  function getElements(formId) {  
	    
	    var form = document.getElementById(formId);
	     msg = inputMsg.split(",");
	     var vnsname="";
	    var tagElements = form.getElementsByTagName('input');    
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
  
  
  function getmoderName(showval) {
	 
		isflag = true;
		var activehtml = "";
		inputMsg="";
		

		$
				.ajax({
					type : "POST",
					async : false,
					url : "/vns/baseAction.do",
					data : {
						ctrl_action : "activeAction",
						ctrl_method : "queryByAttribuName",
						id : $("#activeId").val()
					},
					success : function(data) {
						buteLen = data.length;
						var attrib = "attribmo";
						var butename = "";
						var bute_name;
						var inputName;
						var topHtml;
						buteNameBean = "";
						placeInput="";
						for ( var i = 0; i < buteLen; i++) {
						//	attrib = attrib + i;
							bute_name = data[i].butename + "：";
							buteNameBean += data[i].butename + ",";
							inputMsg+=data[i].butename+",";
							placeInput="请填写您的"+data[i].butename;
							
							if (data[i].butetype == 5) {
								inputName = "<input id='"
										+ attrib
										+ "'  type='text' placeholder='"+placeInput+"' class='Wdate' style='float:left;width:250px;height:36px;padding:0 5px;border:0;color:#000;font-size:14px;' onfocus='WdatePicker({dateFmt:\"yyyy-MM-dd HH:mm:ss\",alwaysUseStartDate:true})'>";
							} else {
								inputName = "<input class='ipt' placeholder='"+placeInput+"' type='text' id='"
										+ attrib + "'  ";
							}

							var topHtml = "<li ><label for=''>" + bute_name
									+ "</label>" + inputName + "</li>";
							activehtml += topHtml;
						}
						

						var attrihtml = "<li> <label for=''>会员帐号：</label><input class='ipt' type='text' name='mode_account' id='mode_account' placeholder='请填写会员账号'  ></li>";
						var yzmhtml = "<li><label for=''>验证码：</label><div class='yzmbox'> <input class='ipt' type='text' name='modeCode' id='modeCode' placeholder='请填写验证码' ><img class='yzmimg' id='verifycode' src='/vns/verifyCodeAction.do' onerror='this.style.display='none''/></div></li>";
						var buttomhtml = " <li><button  class='btn-submit2' type='button'  id='mode_button'  name='mode_button'></button><button  class='btn-search j-btns-modal' type='button'  id='search_button'  name='search_button'></button></li>";
					
						$("#activeMode").html(
								attrihtml + activehtml + yzmhtml + buttomhtml);
						 
					},
					dataType : "json"
				});
		 $('.j-btns-modal').click(function(){
			    $("#account").val("");
			      showDetail();
			      getSelect();
			      $('#modal-1').show();
			      $('#modal-2').hide();
			      
			    });
		$("#verifycode").click(function() {
			var rand = parseInt(Math.random() * (100 - 0 + 1));
			var src = $("#verifycode").attr("src");
			$("#verifycode").attr("src", src + "?" + rand);
		});
		
		$("#mode_button").click(function() {
			inputNameList="";
			msg="";
			var str = $("#mode_account").val();
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
			if (Trim(str).length < 4) {
				alert("您输入会员账号不规范！");
				return false;
			}
			getModeElements("modeform");
			if (flag){
				 flag=false;
			$.ajax({
				type : "POST",
				url : "/vns/baseAction.do",
				data : {
					ctrl_action : "applyAction",
					ctrl_method : "applySaveMold",
					activeId : $("#activeId").val(),
					account : $("#mode_account").val(),
					cfCode : $("#modeCode").val(),
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
  function getModeElements(formId) {  
	    var form = document.getElementById(formId);
	     msg = inputMsg.split(",");
	     var vnsname="";
	    var tagElements = form.getElementsByTagName('input');    
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
  
  