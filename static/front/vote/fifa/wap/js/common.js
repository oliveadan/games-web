		$(function(){
			$(window).scroll(function(){
				//fn.navFixed()
			})
		});
		var fn = {
			navFixed : function(){
				if ($(".js_nav_scrollfixed")[0]) {
			        var _ = $(".js_nav_scrollfixed");
			        var holder = $('.mainnav_holder');
			        var scrollTop = $(window).scrollTop();
			        if (scrollTop>320) {
			        	holder.show()
			        	_.addClass('main_nav_fixed')
			        }else{
			        	holder.hide()
			        	_.removeClass('main_nav_fixed')
			        }

			    }
			},
			countDay: function(date){
				
				var starttime = new Date(date);
				var J_date = $('.J_date');
				var day = 0;
				var nowtime = new Date();
				var time = starttime - nowtime;
				if (time>0) {
				    day = parseInt(time / 1000 / 60 / 60 / 24)
				    return fn.formatDate(day)
				}else{
					return '000'
				}
			},
			showNum: function(data, height){
				if(!height) {
					height = 197;
				}
				var n = data
				var it = $(".J_date i");
				var len = String(n).length;
				for(var i=0;i<len;i++){
					if(it.length<=i){
						$(".J_date").append("<i></i>");
					}
					var num=String(n).charAt(i);
					var y = -parseInt(num) * height;
					var obj = $(".J_date i").eq(i);
					
					obj.animate({
						backgroundPosition :'(0 '+String(y)+'px)' 
						}, 1100,'swing',function(){}
					);
				}
			},
			formatDate: function(n){
				var len = String(n).length,
					str;
				if (len<2) {
					str = '00'+n;
				}else if(len<3){
					str = '0'+n
				}else{
					str = n
				}
				return str;
			},
			showLoginPop: function(){
				$('.J_loginPop,.J_mask').show()
			},
			closeLoginPop: function(){
				$('.J_loginPop,.J_mask').hide()
			},
			changeBgFocus: function(){
				var i = $('.js_bg_focus li.current').index();
				var l = $('.js_bg_focus li').length-1;
				setInterval(function(){
					if (i>=l) {i = 0;}else{i++}
					$('.js_bg_focus li').removeClass('current').eq(i).addClass('current')
				},12e4)
			},
			prompt_bix:function(msg){
				var html='<div>'+msg+'<div>';
			}
		}

		//fn.navFixed()
		//fn.changeBgFocus()
		

		
