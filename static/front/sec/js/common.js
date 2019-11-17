$(".clocknav div").click(function(){
  var i= $(this).index();
  $(this).addClass("active").siblings().removeClass("active");
  $(".clockContent .cCon").eq(i).addClass("show").siblings().removeClass("show");
});

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

