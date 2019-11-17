$(".clocknav div").click(function(){
  var i= $(this).index();
  $(this).addClass("active").siblings().removeClass("active");
  $(".clockContent .cCon").eq(i).addClass("show").siblings().removeClass("show");
});

var $hand = $('.wheelpin');
var $wheelBig = $('.wheel');

function TimerSwitch(pic) {
       TimerRunning=true;
       var timer = setTimeout(function() { SwitchPic(pic) }, 4000);
     }
     function SwitchPic(pic) {
       pic.src = "pic2.jpg";
     }
$hand.click(function(){

  // setInterval(function(){
  //   $hand.addClass("chidden").next().removeClass("chidden");
  // },500);
  // setInterval(function(){
  //   $(".wheelpinPng").removeClass("chidden").next().addClass("chidden");
  // },500);
  $hand.addClass("chidden").next().removeClass("chidden");


  //prepare Your data array with img urls
  $.post("/home/Shuang11/drawStart.html",function(data){   
    if(data.Msg == 'true'){ 
        switch(data.randomVal){
          case '1':
            rotateFunc(1,20,'恭喜你抽中阳澄湖大闸蟹！');
            break;
          case '2':
            rotateFunc(2,65,'恭喜你抽中四轴无人机！');
            break;
          case '3':
            rotateFunc(3,-25,'恭喜你抽中特等奖 XPJ奢华游！');
            break;
          case '4':
            rotateFunc(4,108,'恭喜你抽中388彩金！');
            break;
          case '5':
            rotateFunc(5,150  ,'请再接再厉');
            break;
          case '6':
            rotateFunc(6,-70,'恭喜你抽中行车记录仪');
            break;
          case '7':
            rotateFunc(7,195,'恭喜你抽中 IphoneX 一台！');
            break;
          case '8':
            rotateFunc(7,245,'恭喜你抽中18元彩金！');
            break;

        }
        }else{
        alert('暂无抽奖资格！');
      }  
  });
  // $(this).off('click');
});

var rotateFunc = function(awards,angle,text){
  $wheelBig.stopRotate();
  $wheelBig.rotate({
    angle: 0,
    duration: 5000,
    animateTo: angle + 1440,
    callback: function(){
      // $(".wheelpinPng").removeClass("chidden").next().addClass("chidden");
      $(".wheelpinPng").removeClass("chidden").next().addClass("chidden");
      alert(text);
    }
  });
};


$(".tablehlder").scrollText({'duration': 2000});


$("#login").animatedModal({
  color: "rgba(0,0,0,0.5)",
  animationDuration: ".3s"
});

$("#dialogBox").animatedModal({
  modalTarget:"dialogBoxAnimated",
  color: "rgba(0,0,0,0.5)",
  animationDuration: ".3s"
});


$(".dialogNav a").click(function(){
  var i =$(this).index();
  $(this).addClass("active").siblings().removeClass("active");
  $(".dialogCon .tab").eq(i).removeClass("chidden").siblings().addClass("chidden");
});

// SMOOTH SCROLL SIDEBAR
(function($) {
    var element = $('.sidebar'),
        originalY = element.offset().top;
    var topMargin = 20;
    element.css('position', 'relative');
    $(window).on('scroll', function(event) {
        var scrollTop = $(window).scrollTop();
        element.stop(false, false).animate({
            top: scrollTop < originalY
                    ? 0
                    : scrollTop - originalY + topMargin
        }, 300);
    });
})(jQuery);

// SMOOTH SCROLL SIDEBAR
(function($) {
    var element = $('.sidebar2'),
        originalY = element.offset().top;
    var topMargin = 20;
    element.css('position', 'relative');
    $(window).on('scroll', function(event) {
        var scrollTop = $(window).scrollTop();
        element.stop(false, false).animate({
            top: scrollTop < originalY
                    ? 0
                    : scrollTop - originalY + topMargin
        }, 300);
    });
})(jQuery);


// SMOOTH sSCROLL
// Select all links with hashes
$('a[href*="#"]')
  // Remove links that don't actually link to anything
  .not('[href="#"]')
  .not('[href="#0"]')
  .click(function(event) {
    // On-page links
    if (
      location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '')
      &&
      location.hostname == this.hostname
    ) {
      // Figure out element to scroll to
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
      // Does a scroll target exist?
      if (target.length) {
        // Only prevent default if animation is actually gonna happen
        event.preventDefault();
        $('html, body').animate({
          scrollTop: target.offset().top
        }, 500, function() {
          // Callback after animation
          // Must change focus!
          var $target = $(target);
          $target.focus();
          if ($target.is(":focus")) { // Checking if the target was focused
            return false;
          } else {
            $target.attr('tabindex','-1'); // Adding tabindex for elements not focusable
            $target.focus(); // Set focus again
          };
        });
      }
    }
  });



  $(function(){
       //prepare Your data array with img urls
       var dataArray=new Array();
       dataArray[0]="../img/wheelpin.png";
       dataArray[1]="../img/wheelpin.gif";

       //start with id=0 after 5 seconds
       var thisId=0;

       window.setInterval(function(){
           $('#thisImg').attr('src',dataArray[thisId]);
           thisId++; //increment data array id
           if (thisId==1) thisId=0; //repeat from start
       },500);
   });
