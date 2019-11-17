<!DOCTYPE html>
<html>
<head>
<title>{{.siteName}}-{{.gameDesc}}</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="renderer" content="webkit">
<meta name="viewport"  content="width=device-width,user-scalable=no">
<link rel="stylesheet" rev="stylesheet" href="{{static_front}}/static/front/luckyfree/wap/css/reset.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="{{static_front}}/static/front/luckyfree/wap/css/global.css" type="text/css" />
<link rel="stylesheet" rev="stylesheet" href="{{static_front}}/static/front/luckyfree/wap/css/index.css" type="text/css" />

</head>
<body>
<input type="hidden" id="gid" value="{{.gameId}}">
<div class="loading">
		<span class="loadingfa xuanzhuan"><em class="fa fa-spinner"></em></span>
	</div>
<!-- id=innerbox 标签外面 不放任何标签  为自适应标签   -->
<div class="bgx" id="innerbox">
	<div class="top">
		<div class="logo fl">
                <img src="{{static_front}}/static/img/logo240x80.png" alt="" />
        </div>
		<div class="nvbx">
			<a href="{{.officialRegist}}" class="">
                <img src="{{static_front}}/static/front/luckyfree/wap/images/dian.png" class="vm" alt="" /> 免费注册</a>
			<a href="{{urlfor "DoorController.Query" "gid" .gameId}}" class="" >
                <img src="{{static_front}}/static/front/luckyfree/wap/images/dian.png" class="vm" alt="" /> 中奖查询</a>
			<a href="{{.custServ}}" class="">
                <img src="{{static_front}}/static/front/luckyfree/wap/images/dian.png" class="vm" alt="" /> 在线客服</a>
		</div>
		<div class="cl"></div>
	</div>

	<div class="cshooci" id="login-status">
		<span onclick="showLogin();">点击登录</span>
	</div>
	<div class="wiishz">
		<div class="jiangbx">
			<div class="jiangbxin" id="lottery">
				{{range $i, $v := .gifts1}}
					<a class="lottery-unit lottery-unit-{{if eq $v.Seq 1 }}0{{else if eq $v.Seq 2}}1 {{else if eq $v.Seq 3}}2{{else if eq $v.Seq 4}}3{{else if eq $v.Seq 5}}9{{end}}
					jiam jiam{{$v.Seq}}"><img src="{{$v.Photo}}" alt=""></a>
				{{end}}
					<a href="#" class="jiam jiam6"><span class="csinx btn-choujiang">点击登录</span></a>
				{{range $i, $v := .gifts2}}
					<a class="lottery-unit lottery-unit-{{if eq $v.Seq 7 }}4{{else if eq $v.Seq 8}}8 {{else if eq $v.Seq 9}}7{{else if eq $v.Seq 10}}6{{else if eq $v.Seq 6}}5{{end}}
				   jiam jiam{{if eq $v.Seq 6 }}11{{else}}{{$v.Seq}}{{end}}"><img src="{{$v.Photo}}" alt=""></a>
				{{end}}
			</div>
		</div>
	</div>
	<div class="cl h33"></div>
	<div class="cl h84"></div>
	<div class="cp">Copyright ©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div>
</div>



    <!-- 登录窗口 -->
    <div class="tanbx" style="display:none" id="window-login">
		<div class="tawinbx">
			<div class="tanentou">请先登陆</div>
			<a href="javasript:;" onClick="closeLogin();" class="closex" ></a>
			<div class="lells">会员账号：  <input id="username" type="text" class="sahsibopt" value="" />
				<a href="javascript:;" onclick="login();" class="pl8" >
					<img src="{{static_front}}/static/front/luckyfree/wap/images/login.png" class="vm" alt="" />
				</a>
			</div>
		</div>
	</div>


<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/luckyfree/wap/js/global.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/luckyfree/wap/js/demo.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/luckyfree/wap/js/index.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/luckyfree/wap/js/lucky.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/layer-v3.1.1/layer.js"></script>
<script>
    $(function () {
        username2 = localStorage.getItem("username");
        if (username2 != null){
            var str = "";
            str = '您还有'+'<span class="huang">'+{{.lotteryNums}}+'</span>'+'次抽奖机会'+'</br>';
            var exit = "";
            exit = '<a href="javascript:(0);" onclick="exit()">'+'退出'+'</a>';
            $('.btn-choujiang').html('-1抽奖次数');
            $("#login-status").html(str+exit);
        }
    });
</script>
</body>
</html>
