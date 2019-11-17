$(document).ready(function(){
	var i = 0;
	window.setInterval(function(){
		if(i < 2){
			i++;
			$(".focus_body li").eq(i).addClass("current").siblings().removeClass("current")
		}else{
			i=0;
			$(".focus_body li").eq(i).addClass("current").siblings().removeClass("current")
		}
		
	},5000);
	
	$(window).scroll(function(){
		var sc = $(window).scrollTop();
		if(sc > 200){
			$(".js_nav_scrollfixed").addClass("main_nav_fixed");
			$(".mainnav_holder").show();
		}else{
			$(".js_nav_scrollfixed").removeClass("main_nav_fixed");
			$(".mainnav_holder").hide();
		}
	});
	
	
})