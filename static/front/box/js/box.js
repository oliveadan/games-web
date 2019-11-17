$(function() {

    //開寶箱
    // $('.allboxs img').click(function() {
    //     var boxName = $(this).attr('class').slice(4, 6);
    //     $.ajax({
    //         type: "post",
    //         url: "js/url.json",
    //         success: function(data) {
    //             var src = data.src;
    //             $('.barrier').css("display", "block").append('<img class="box' + boxName + '" src="images/' + boxName + '.gif" alt=""><div class="board"><div class="board-top"><img src="images/board-title.png"></div><div class="board-cont"><p>尊敬的会员<br>恭喜您获得以下礼品</p><img src="' + src + '"></div><div class="close-btn"></div></div>');
    //             setTimeout(function() {
    //                 $('.board').addClass('open');
    //             }, 1500);
    //             setTimeout(function() {
    //                 $('.box' + boxName).attr('src', "");
    //             }, 2000);
    //         }
    //     })

    // });


    $('body').on('click', '.close-btn', function() {
        location.reload();
        // $('.barrier').remove();
        // $('body').append("<div class='barrier'></div>");
    });



    //Marquee
    $('#marquee2').kxbdSuperMarquee({
        isMarquee: true,
        isEqual: false,
        scrollDelay: 20,
        controlBtn: {
            up: '#goUM',
            down: '#goDM'
        },
        direction: 'up'
    });


    $('.snowfall-flakes').on('click', function() {
        $('#redBagRain').modal('show');
    });


    $("#gethongbao").click(function() {
        $('#redBagRain').modal('hide');
    });



    var WW = $(window).width();
    if (WW < 425) {
        var WH = $(window).height();
        var CH = WH - 306;
        $(".content").css("height", CH + "px");
    }

    // 切換畫面
    var _default = 1,
        $block = $('#abgne-block'),
        $tabs = $block.find('.nav'),
        $tabsLi = $tabs.find('li'),
        $tab_content = $block.find('.tab_content'),
        $tab_contentLi = $tab_content.find('li.tab'),
        _width = $tab_content.width();


    $tabsLi.hover(function() {
        var $this = $(this);

        if ($this.hasClass('active')) return;

        $this.toggleClass('hover');
    }).click(function() {
        var $active = $tabsLi.filter('.active').removeClass('active'),
            _activeIndex = $active.index(),
            $this = $(this).addClass('active').removeClass('hover'),
            _index = $this.index(),
            isNext = _index > _activeIndex;

        if (_activeIndex == _index) return;

        $tab_contentLi.eq(_activeIndex).stop().animate({
            left: isNext ? -_width : _width
        }).end().eq(_index).css('left', isNext ? _width : -_width).stop().animate({
            left: 0,
            opacity: 1
        });

        if (WW > 425) {
            if (_index == 1 || _index == 0) {
                var divH = $tab_contentLi.eq(_index).find("div:first").height();
                $(".content").css("height", divH + 100);
            } else {
                $(".content").css("height", '500px');
            }
        }

        var contentH = $(".content").height();
        var dqmainH = contentH + 860;
        $('.dqmain').css('height', dqmainH + 'px');


    });

    $tabsLi.eq(_default).addClass('active');
    $tab_contentLi.eq(_default).siblings().css({
        left: _width,
        opacity: 0
    });



});