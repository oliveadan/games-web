$(function () {
    $("#closeBtn,#noPrice-btn").on("click", function () {
        $(this).parent().parent().parent().fadeOut(50);
    })
	// 获奖信息调用
	scrollLeft();
    // 第一次点击掷筛骰子
    $("#throwDice").click(function(){
		if($("#loginAccount").text() == "") {
			//layer.msg("请先登录");
			document.getElementById('light1').style.display='block'; 
			document.getElementById('fade').style.display='block';
			return;
		}
		$("#levelgift").hide();
		if($("#accountStage").text()!=$("#currentStage").text()) {
			layer.open({
			  	title: '关卡提示',
			  	content: '请回到您所在关卡后再投掷',
				btn: ['回到我的关卡'],
				yes: function(index, layero){
					location.href = "/rich?gid="+$("#gid").val();
  				}
			});
			return;
		}
		if(isIE) {
    		$(this).fadeOut().siblings("#diceIcon").fadeIn(500);
		} else {
			$(this).fadeOut().siblings(".dicenewWrap").fadeIn();
		}
		$.post('/rich/dice', {
		   gid: $("#gid").val(),
		   account:$("#loginAccount").text()
		},
		function(res,status){
			if(res.code == 0) {
				layer.msg(res.msg);
				diceShow();
				return;
			}
	        var dice_num = res.data.diceNum;
	        var step_num = res.data.stepNum;
			$("#lotteryNums").text($("#lotteryNums").text()-1);
			
	        // 骰子动画
			var d;
			if(isIE) {
				d = diceroll(dice_num);
			} else {
				d = diceroll_new(dice_num);
			}
			d.then(function(data){
				console.log(data);
    			return kubaoMove(step_num);
    			//return runAsync2();
			}).then(function(data){
				console.log(data);
    			$("#accountStep").text(step_num);
				if(res.code == 1) {
					$("#priceMsg").text(res.data.gift);
					$("#zillion-winSack-wd").delay(1200).fadeIn(50);
				} else if(res.code == 2) {
					layer.msg("本次未中奖，大奖等着你，请再接再厉！",{icon:5,time:1800});
				}
				if($("#currentStage").text()!=res.data.stage){
					setTimeout(function () {
                        layer.msg("即将前往关卡"+res.data.stage+",您有过关奖励可领取");
                    }, 2500);
					setTimeout(function () {
                        location.href = location.href = "/rich?gid="+$("#gid").val();
                    }, 3000);
				}
				diceShow();
				$("#levelgift").show();

			});
		});
		
    });
    findDimensions();
    window.onresize = findDimensions;
});
// 获奖信息滚动
function scrollLeft() {
    var speed = 30;
    var scroll_begin = document.getElementById("scroll-start");
    var scroll_end = document.getElementById("scroll-end");
    var scroll_box = document.getElementById("scroll-box"); 
    scroll_end.innerHTML = scroll_begin.innerHTML;
    function Marquee() {
       if(scroll_box.scrollLeft >=1800){
           scroll_box.scrollLeft = 0;
       }
        if (scroll_end.offsetWidth <= scroll_box.scrollLeft) {
            scroll_box.scrollLeft -= scroll_begin.offsetWidth;
        }
        else
            scroll_box.scrollLeft++;
    }
    setInterval(Marquee, speed);
}
// 点击投骰子按钮消失后显示
function diceShow(){
    $("#throwDice").fadeIn();
	if(isIE) {
		$("#diceIcon").fadeOut();
	} else {
		$(".dicenewWrap").fadeOut();
	}
}
// 骰子动画
function diceroll(num){
	var def = $.Deferred();
    var dice = $("#diceIcon");
	dice.animate({marginLeft: '+2px'}, 100,function(){
		dice.addClass("dice_aimt");
	}).animate({marginTop:'-50px',marginLeft:'-70px'},200,function(){
       	dice.removeClass("dice_aimt");
   	})
	dice.attr("class","dice-icon");//清除上次动画后的点数
	// dice.css('cursor','default');
	dice.animate({marginTop:'-50px',marginLeft:'-70px'}, 100,function(){
		dice.addClass("dice_aimt");
	}).delay(200).animate({marginTop:'-50px',marginLeft:'-70px'},200,function(){
        dice.removeClass("dice_aimt").addClass("dice_aims");
    }).animate({marginTop:'-50px',marginLeft:'-70px'},200,function(){
        dice.removeClass("dice_aimt").addClass("dice_aims");
    }).animate({marginTop:'-50px',marginLeft:'-70px'},200,function(){
        dice.removeClass("dice_aimt").addClass("dice_aims");
    }).animate({marginTop:'-50px',marginLeft:'-70px'},200,function(){
		dice.removeClass("dice_aimt").addClass("dice_aims");
	}).delay(200).animate({opacity: 'show',},600,function(){
		dice.removeClass("dice_aims").addClass("dice_aime");
	}).delay(100).animate({marginLeft:'-45px',marginTop:'0px'},100,function(){
		dice.removeClass("dice_aime").addClass("dice_aim"+num);
	});
	setTimeout(function() {
		def.resolve(num);
	},3000);
	return def.promise();
}
var winWidth = 0;
var winHeight = 0;

function findDimensions() {//函数：获取尺寸
    //获取窗口宽度
	if(window.innerWidth)
		winWidth = window.innerWidth;
	else if((document.body) && (document.body.clientWidth))
		winWidth = document.body.clientWidth;
	//获取窗口高度
	if(window.innerHeight)
		winHeight = window.innerHeight;
	else if((document.body) && (document.body.clientHeight))
		winHeight = document.body.clientHeight;
	//通过深入Document内部对body进行检测，获取窗口大小
	if(document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth) {
		winHeight = parseInt(document.documentElement.clientHeight);
		winWidth = parseInt(document.documentElement.clientWidth);
	}
}
//调用函数，获取数值
function kubaoMove(step) {
	var def = $.Deferred();
	if(step==0) {
		//initiaStep();
		return;
	}
    var grid_li = $(".go-grid-game li");
    var grid_num = $(".go-grid-game li").eq(step-1);
    var spareX = ((winWidth - 1200)/2) - 5;
        if(winWidth<1200){
            $("#kuBao-icon").animate({
            top: grid_num.offset().top - 100,
            left: grid_num.offset().left -5  
            }, 800)
    }else{
            $("#kuBao-icon").animate({
                top: grid_num.offset().top - 100,
                left: grid_num.offset().left - spareX
            }, 800)
    }
    $("#startPoint").animate({
        left:110
    },1000)
	setTimeout(function() {
		def.resolve(step);
	}, 1500);
	return def.promise();
}
// 恢复初始
function initiaStep(){
    $("#startPoint").animate({
    	left:165
    },500)
    $("#kuBao-icon").animate({
        top: 337,
        left: 63 
    }, 800)
}
// 判断格子位置

// 以下是新版的骰子效果
var keyframes = {
    '1': [{
        transform: 'rotate3d(1, 1, 1, 0deg) rotateX(-270deg) scale3d(1, 1, 1)'
    }, {
        transform: 'rotate3d(1, 1, 1, 360deg) rotateX(90deg) scale3d(1, 1, 1)'
    }],
    '2': [{
        transform: 'rotate3d(1, 1, 1, 0deg) rotateX(-90deg) scale3d(1, 1, 1)'
    }, {
        transform: 'rotate3d(1, 1, 1, 360deg) rotateX(270deg) scale3d(1, 1, 1)'
    }],
    '3': [{
        transform: 'rotate3d(1, 1, 1, 0deg) rotateY(0deg) scale3d(1, 1, 1)'
    }, {
        transform: 'rotate3d(1, 1, 1, 360deg) rotateY(360deg) scale3d(1, 1, 1)'
    }],
    '4': [{
        transform: 'rotate3d(1, 1, 1, 0deg) rotateX(-180deg) scale3d(1, 1, 1)'
    }, {
        transform: 'rotate3d(1, 1, 1, 360deg) rotateX(180deg) scale3d(1, 1, 1)'
    }],
    '5': [{
        transform: 'rotate3d(1, 1, 1, 0deg) rotateX(-90deg) rotateY(-30deg) rotateZ(-90deg) scale3d(1, 1, 1)'
    }, {
        transform: 'rotate3d(1, 1, 1, 360deg) rotateX(-90deg) rotateY(-30deg) rotateZ(270deg) scale3d(1, 1, 1)'
    }],
    '6': [{
        transform: 'rotate3d(1, 1, 1, 0deg) rotateX(-90deg) rotateY(0deg) rotateZ(-270deg) scale3d(1, 1, 1)'
    }, {
        transform: 'rotate3d(1, 1, 1, 360deg) rotateX(-90deg) rotateY(0deg) rotateZ(90deg) scale3d(1, 1, 1)'
    }]
}
var animationConfig = {
    duration: 200,
    iterations: 10,
    fill: 'forwards', //当动画完成后，保持最后一个属性值（在最后一个关键帧中定义）
};
//动画配置结束
//旋转函数
function diceroll_new(number) {
	var def = $.Deferred();
	var diceWrap = document.querySelector('.dicenewWrap');
    var timeout = null;
    var diceAnimate = diceWrap.animate(
        keyframes[number],
        animationConfig
    );
    var startTime = new Date().getTime();

    function playbackRate() {
        diceAnimate.playbackRate *= 0.93;
        timeout = setTimeout(playbackRate, 200);
        if (diceAnimate.playbackRate <= 0.3) {
            clearTimeout(timeout);
        }
    }
   	playbackRate();
	setTimeout(function() {
		def.resolve(number);
	}, 4500)
	return def.promise();
}