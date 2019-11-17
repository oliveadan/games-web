<!DOCTYPE html>
<html lang="zh-cn">
<head>
<meta charset="utf-8">
<meta http-equiv="x-ua-compatible" content="ie=edge">
<title>{{.siteName}}-{{.gameDesc}}</title>
<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
<link rel="stylesheet" href="{{static_front}}/static/front/tiger/css/reset.css">
<link rel="stylesheet" href="{{static_front}}/static/front/tiger/css/animate.min.css">
<link rel="stylesheet" href="{{static_front}}/static/front/tiger/css/style.css">
</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="header">
	<div class="headercon w1000">
		<a class="logo" href='{{urlfor "TigerApiController.Get"}}'></a>
		<div class="menu">
    			<ul>    				
    				<li><a target="_blank" href="{{.officialSite}}"><i class="i1"></i><p>官方首页</p></a></li>
    				<li><a  href="javascript:;" onClick="document.getElementById('light').style.display='block'; document.getElementById('fade').style.display='block'"><i class="i8"></i><p>中奖查询</p></a></li>
    				<li><a target="_blank" href="{{.officialRegist}}"><i class="i5"></i><p>免费注册</p></a></li>
    				<li class="last"><a target="_blank" href="{{.custServ}}"><i class="i6"></i><p>在线客服</p></a></li>
    			</ul>
		</div>
	</div>
</div>
<div class="main">
	<div class="logined"><span>会员 <b id="username">user</b></span><span>还有<b id="draw">0</b>次机会</span><a  href="javascript:;" onclick="exit()" class="qdbtn">退出</a></div>
	<div class="w1000">
		<div class="main-num-box">
        	<div class="num_mask"></div>
	        <div class="num_box">
	            <div class="num"></div>
	            <div class="num"></div>
	            <div class="num"></div>
	            <div class="slot-btn"></div>
	        </div>
    	</div>
		<div class="con con1">
         	   <div class="w1000">
         	   	<div class="winlist">
         	   	<ul>
					{{range $i, $v := .rlList}}
						<li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span>获得<em>{{$v.gift}}</em></li>
					{{end}}               
			 </ul>
			 </div>
         	   </div>
         </div>
           <div class="con con2">
         	   <div class="w1000">
             	 <div class="title">活动详情</div>
                	{{str2html .gameRule}}
			</div>
          </div>
  <div class="con con3">
		<div class="w1000">
     		<div class="title">活动细则</div>
				<p>
				     {{str2html .gameStatement}}
				</p>
     		</div>
           </div>
	</div>
</div>

<div class="footer"><div class="copyright">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div></div>

<div class="tclogin">
	<input type="text" value="" class="user_name" id="user_name" placeholder="请输入平台会员账号">
    <input type="submit" value="登陆" class="tcsub">
</div>
<div class="tcwin">
	<div class="wintext"></div>
    <button class="layui-layer-close makesure">确定</button>
</div>

<!--底部 结束-->
<div id="light" class="white_content">
	<div class="cxbox">
        <div class="cxbox_bt">
            <p>输入会员账号查询</p>  
            <a href="javascript:void(0)" style="color:#ffe681;text-decoration:none;" onClick="document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'" class="gban">
			X</a>
        </div>
    <div class="cxbox_hy">
            <p>会员账号：</p>  <input name="querycode" id="querycode" type="text" value="" placeholder="输入帐号"> <a href="javascript:;" onClick="queryBtn()">
			查 询</a>
        </div>
        <div class="cxbox_bd"  style="color:#ffe681;" >
            <table width="480" border="0" cellpadding="0" cellspacing="0">
              <tr class="ad">
                <td>中奖金额</td>
                <td>中奖时间</td>
                <td>是否派彩</td>
              </tr>
			  <tbody id="query_content"></tbody>
            </table>
			<div class="quotes" style="padding:10px 0px;"></div>
        </div>
    </div>
</div>
<div id="fade" class="black_overlay"></div>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.SuperSlide.2.1.1.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/tiger/js/lottery.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/tiger/js/animateBackground-plugin.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/tiger/js/easing.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/broadcast.js"></script>
<script>
function autoScroll(obj){  
	$(obj).find("ul").animate({  
		marginTop : "-50px"  
	},500,function(){  
		$(this).css({marginTop : "0px"}).find("li:lt(2)").appendTo(this);  
	})  
}  
$(function(){  
setInterval('autoScroll(".winlist")',3000);
})
</script>
<script>
if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){
	_username=localStorage.getItem("username");
	checkUser();
}
var u = 265;
$(function(){
    $('.slot-btn').click(function(){
		checklogin();
    }); 
});
var isture = 0;
function numsShow(result,state) {
	isture = true;
    $(".num").css('background-position', '11px 0');
	if(result.length==1) {
		result = '00'+result;
	} else if(result.length==2) {
		result = '0'+result;
	}
    var num_arr = result.split('');
    $(".num").each(function(index){
        var _num = $(this);
        var yPos = (u*60) - (u*num_arr[index]);
        setTimeout(function(){
            _num.animate({ 
                backgroundPosition: '11px ' + yPos + 'px'
            },{
                duration: 3000+index*3000,
                easing: "easeInOutCirc",
                complete: function(){
                    if(index==2) {
						if(state==2){layer.msg("很遗憾，没有中奖，再来一次吧！",{icon:5,time:1800});isture = false;}
						if(state==1){layer.open({type: 1, zIndex: 100, title: false,area: ['438px'],skin: 'layui-layer-nobg',shade: 0.7,closeBtn :true,shadeClose: true,content: $('.tcwin')});isture = false;}
			
					}
                }
            });
        }, index * 300);
    });
}
</script>
</body>
</html>