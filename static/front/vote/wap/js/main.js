// DOM Ready
$(function(){

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

  // 弹出1
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

  $('.j-btns-modal').click(function(){
    showDetail();
    $('#modal-1').show();
    $('#modal-2').hide();
    $('#modal-3').hide();
  })

  $('.j-btn-submit').click(function(){
    $('#modal-1').hide();
    $('#modal-2').show();
    $('#modal-3').hide();
  })

  $('.j-btn').click(function(){
    showDetail();
    $('#modal-3').show();
    $('#modal-1').hide();
    $('#modal-2').hide();
  })

  $('.j-btn-back').click(function(){
    $('#msgDiv,#bgDiv').hide();
  })

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


})
