/**
* 1、依赖<script type="text/javascript" src="/static/front/layer-v3.1.1/layer.js"></script>
* 2、必须在用户登录后设置 localStorage.username
* 3、pc端必须包含样式，如:
.broadcast-win {
	background: url(/static/front/images/broadcast-win.png) no-repeat;
	background-size: cover;width: 438px;height: 500px;overflow: hidden;text-align: center;display:block;
}
.broadcast-msg {
	margin-top: 340px;font-size: 24px;color: #5e2b17;
}
.broadcast-msg span {
	color:#f63d3d;
}
.broadcast-win button {
	width: 200px;height: 45px;line-height: 45px;display: block;margin: 0 auto;margin-top: 30px;background: #f63d3d;border: none;border-radius: 20px;color: #fff;font-size: 24px;position: relative;cursor: pointer;
}
* 4、手机端必须包含样式，如:
.broadcast-win {
	background: url(/static/front/images/broadcast-win.png) no-repeat;
	background-size: cover;width: 5.5rem;height:6.27rem;overflow: hidden;text-align: center;display:block;
}
.broadcast-msg {
	margin-top: 4.3rem;color: #5e2b17;
}
.broadcast-msg span {
	color:#f63d3d;
}
.broadcast-win button {
	width: 3rem;height: 0.65rem;line-height: 0.65rem;display: block;margin: 0 auto;margin-top: 0.2rem;background: #f63d3d;border: none;border-radius: 0.1rem;color: #fff;font-size: 0.4rem;position: relative;cursor: pointer;
}
*/
$(document).ready(function () {
	if (window["WebSocket"]) {
		var isMobile = false;
		if(/Android|webOS|iPhone|iPod|BlackBerry/i.test(navigator.userAgent)) {
			isMobile = true;
		}
        var socket = new WebSocket("ws://" + document.location.host + "/ws/join");
        socket.onclose = function (evt) {
            console.log("ws close");
        };
		var index;
        socket.onmessage = function (evt) {
			var json = JSON.parse(evt.data);
			if(localStorage.getItem("username")&&localStorage.getItem("username")!="null"){
				if(localStorage.getItem("username")==json.account) {
					return; // 自己中奖，自己不再显示广播
				}
			}
			layer.close(index);
			var html = '<div class="broadcast-win">'
					+ '<div class="broadcast-msg">'+ '恭喜 '+json.account.substr(0,3)+'*** 参加'+json.game+'<br>获得大奖 <span>'+json.gift +'</span></div>'
				    + '<button class="layui-layer-close">马上参加</button>'
					+ '</div>';
			if(isMobile) {
				index = layer.open({
					type: 1, 
					zIndex: 100, 
					title: false,
					skin: 'layui-layer-nobg',
					shade: 0.7,
					closeBtn :false,
					shadeClose: true,
					//time: 5000,
					content: html
				});
			} else {
				index = layer.open({
					type: 1, 
					zIndex: 100, 
					title: false,
					area: ['438px'],
					skin: 'layui-layer-nobg',
					shade: 0.7,
					closeBtn :false,
					shadeClose: true,
					//time: 5000,
					content: html
				});
			}
        };
    } else {
        console.log("your browser does not support websocket!");
    }
});