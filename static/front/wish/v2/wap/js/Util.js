var Util = {
    init: function() {
        var me = this;
        if (me.myBrowser()) {
            alert("请升级浏览器版本，或选择其它浏览器，浏览网站！");
        }
        if ($(window).height() > 980) {
            $('.panel:eq(1)').css({
                'height': $(window).height() - 478
            });
            $('.panel:eq(1)').css({
                'height': $(window).height()
            });
            $('.panel:eq(1)').css({
                'height': $(window).height()
            });
            $(".pic-1").height($(window).height());
            
        } else {
            $(".topHeadLogin").css("position", "fixed");
            
        }
        var $is = setInterval(me.myInterval, 2000);
        me.infoPis = $(".pis");
        me.closeTime = 2000;
        $(".addClassBg:even td").addClass("blue"); (function($) {
            $(window).load(function() {
                $("#content-1").mCustomScrollbar({
                    setTop: "0px"
                });
                $("#content-2").mCustomScrollbar({
                    setTop: "0px"
                });
                $("#content-3").mCustomScrollbar({
                    setTop: "0px"
                });
            });
        })(jQuery);
        var WinningDetails = setInterval(me.WinningDetailsText, 5000);
    },
    myBrowser: function() {
        var userAgent = navigator.userAgent;
        var isOpera = userAgent.indexOf("Opera") > -1;
        var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera;
        var isReturn = false;
        if (isIE) {
            var IE5 = IE55 = IE6 = IE7 = IE8 = false;
            var reIE = new RegExp("MSIE (\\d+\\.\\d+);");
            reIE.test(userAgent);
            var fIEVersion = parseFloat(RegExp["$1"]);
            IE55 = fIEVersion == 5.5;
            IE6 = fIEVersion == 6.0;
            IE7 = fIEVersion == 7.0;
            IE8 = fIEVersion == 8.0;
            if (IE55) {
                isReturn = true;
            }
            if (IE6) {
                isReturn = true;
            }
            if (IE7) {
                isReturn = true;
            }
            if (IE8) {
                isReturn = true;
            }
        }
        return isReturn;
    },
    WinningDetailsText: function() {
        var me = this;
        $.post("#",
        function(data) {
            $pisTexDom = $(".bottomPisText");
            $pisTexDom.html(data.msg).fadeIn("slow",
            function() {
                Util.delay(1000,
                function() {
                    $pisTexDom.fadeOut(3000);
                });
            });
        });
    },
    ChristmasAnimate: function() {
        var ChristmasNum = Util.ChristmasNum;
        if (ChristmasNum < 4) {
            $(".Christmas-anctinty img").eq(ChristmasNum).fadeIn(2000).siblings("img").fadeOut(2000);
        } else {
            Util.ChristmasNum = 0;
            $(".Christmas-anctinty img").fadeOut(2000);
        }
        Util.ChristmasNum++;
    },
    snowflakeAnimate: function() {
        $(".snowflakeList img").each(function(index, element) {
            var mar = index * 30,
            topmar = Math.floor(Math.random() * 500 + 1),
            randNum = Math.floor(Math.random() * 10 + 3);
            $(this).css({
                "left": mar + "px",
                "top": "-" + topmar + "px",
                "animation": "xuehua " + randNum + "s infinite",
                "-moz-animation": "xuehua " + randNum + "s infinite",
                "-webkit-animation": "xuehua " + randNum + "s infinite",
                "-o-animation": "xuehua " + randNum + "s infinite"
            });
        });
    },
    myInterval: function() {
        if ($(".giftList a").is('.shake-constant')) {
            $(".giftList a").removeClass("shake-constant");
        } else {
            $(".giftList a").addClass("shake-constant");
        }
    },
    tiaozhuan: function() {
        window.location.reload();
    },
    pegePic: function(picNum) {
        var me = this;
        if (picNum == 2) {
            if (!me.isDom(".ArmorGodContent")) {
                $(".ArmorGod").load("#",
                function() {
                    if ($("#timeEndDjs").length > 0) {
                        me.djs();
                    }
                });
            }
        } else if (picNum == 3) {
            if (!me.isDom(".Christmas-Content")) {
                $(".Christmas").load("#",
                function() {
                    me.snowflakeAnimate();
                    me.ChristmasNum = 0;
                    var ChristmasAnimateVar = setInterval(me.ChristmasAnimate, 3000);
                    $(".addClassBg:even td").addClass("blue");
                    $("#content-2").mCustomScrollbar({
                        setTop: "0px"
                    });
                });
            }
        }
    },
    isDom: function(element) {
        if ($(element).length > 0) {
            return true;
        } else {
            return false;
        }
    },
    hideCeng: function(className) {
        $(className).fadeOut();
        $(".bgCeng").fadeOut();
    },
    hoverHideCeng: function(className) {
        $(className).stop().hide();
    },
    delay: function(t, callback) {
        return window.setTimeout(function() {
            callback();
        },
        t);
    },
    showCeng: function(className) {
		var me = this;
        $(className).fadeIn();
        $(".bgCeng").fadeIn();
		me.WishingPageList();
    },
    hoverShowCeng: function(className) {
        $(className).stop().show();
    },
    emtypCenter: function(className) {
        $(className).empty();
    },
    removeHTMLTag: function(str) {
        str = str.replace(/<\/?[^>]*>/g, '');
        str = str.replace(/[ | ]*\n/g, '\n');
        str = str.replace(/ /ig, '');
        return str;
    },
    WishingSm: function() {
        var me = this;
        var WishingTextarea = $("textarea[name=WishingTextarea]").val();
        var account = $("#username").val();
        var mobile = $("#mobile").val();
        var gameId = $("#gameId").val();
		if (gameId == 0) {
            me.pis("活动获取失败，请刷新后重试！");
            return false;
        }
        if (WishingTextarea.length < 1) {
            me.pis("请填写愿望！");
            return false;
        }
        $.post("/wish", {
            content: WishingTextarea,
			account: account,
			mobile: mobile,
			gameId: gameId
        },
        function(data) {
            if (data.code > 0) {
				account = account || mobile
                $(".Wishing-ceng,.bgCeng").fadeOut();
                me.pis(data.msg);
                var userImg = "/static/front/wish/images/dh_01.png";
                $WishingNum = $(".Wishing li").length;
                var appendHtml = '<li class="WishingList-' + ($WishingNum) + ' shake">' + '<span>' + '<img src="' + userImg + '">' + '</span>' + '<h5>' + account + '</h5>' + '<p>' + WishingTextarea + '</p>' + '<a href="javascript:Util.ThumbsUp(' + data.code + ');" id="zan-' + data.code + '" title="赞一下" class="WishingList-zan">0</a>' + '</li>';
                $(".Wishing ul").append(appendHtml);
            } else {
                me.pis(data.msg);
            }
        });
    },
    pis: function(text) {
        var me = this;
        me.infoPis.html(text).fadeIn("slow",
        function() {
            me.delay(me.closeTime,
            function() {
                me.infoPis.fadeOut(1500);
            });
        });
    },
    Registration: function() {
        var me = this;
        $.post("#",
        function(data) {
            if (data.Msg == "true") {
                me.pis(data.randomVal);
            } else {
                me.pis(data.randomVal);
            }
        });
    },
    redDraw: function() {
        var me = this;
        $.post("#",
        function(data) {
            if (data.Msg == "true") {
                $("#randMoney").html(data.randomVal);
                $(".cengStyle").fadeIn();
            } else {
                me.pis(data.randomVal);
            }
        });
    },
    ChristmasGift: function() {
        //var me = this;
        //$.post("#",
        //function(data) {
        //    me.pis(data.randomVal);
        //});
    },
    ThumbsUp: function(ThumbsUpId) {
        var me = this;
        var GameId = $("#gameId").val();
        $.post("/thumbs", {
            wishId: ThumbsUpId,
			gameId: GameId
        },
        function(data) {
            if (data.code == "1") {
                me.pis(data.msg);
                $WishingListzan = parseInt($("#zan-" + ThumbsUpId).text());
                $("#zan-" + ThumbsUpId).html($WishingListzan + 1);
            } else {
                me.pis(data.msg);
            }
        });
    },
    Database: function(uid) {
        var me = this;
        $.post("#", {
            uid: uid
        },
        function(data) {
            if (data.Msg == "true") {
                $(".title-open").html("恭喜你开宝箱获得：" + data.dataVal["prizeTitle"] + "!");
                $("#xiangziImg").attr("src", data.prizeImg);
                if (uid == "2") {
                    var classify = "青铜宝箱";
                } else if (uid == "3") {
                    var classify = "白银宝箱";
                } else if (uid == "4") {
                    var classify = "黄金宝箱";
                } else if (uid == "5") {
                    var classify = "钻石宝箱";
                } else if (uid == "6") {
                    var classify = "赌王宝箱";
                }
                var htmlContentList = '<tr class="addClassBg">' + '<td>' + data.dataVal["prizeTitle"] + '</td>' + '<td>' + classify + '</td>' + '<td>' + data.dataVal["exchangeTime"] + '</td>' + '<td>未处理</td>' + '</tr>';
                $("#userTableList2").append(htmlContentList);
                $(".wrapper").fadeIn(function() {
                    me.awardAntine();
                });
            } else {
                me.pis(data.randomVal);
            }
        });
    },
    userLogin: function() {
        var me = this,
        $userName = $("input[name=username]").val(),
        $userPassword = $("input[name=password]").val(),
        $verify = $("input[name=verify]").val(),
        verifty = "ExtenalLogin",
        authCode = "";
        if ($userName.length < 1) {
            me.pis("填写账号！");
            return false;
        }
        if ($userPassword.length < 1) {
            me.pis("填写密码！");
            return false;
        }
        me.infoPis.html("登陆中,请稍后...").fadeIn();
        $.ajax({
            url: 'http://www.x993.com/user/DoExternalLoginJsonp.html?userName=' + $userName + '&password=' + $userPassword + '&verifty=' + verifty + '&authCode=' + authCode,
            dataType: "jsonp",
            jsonp: "jsonpcallback",
            cache: false,
            crossDomain: true,
            error: function(XMLHttpRequest, textStatus, errorThrown) {
                alert("请求数据时发生错误！" + textStatus);
                if (typeof failCallback === 'function') {
                    failCallback();
                }
                return false;
            },
            success: function(data) {
                if (data.success == false) {
                    alert(data.msg);
                    return false;
                }
                if (data.success == true) {
                    $.post("/index.php?s=/home/user/loginXpjjs.html", {
                        userName: $userName
                    },
                    function(data) {
                        if (data == 1) {
                            window.location.href = '/index.php?s=index.html';
                        } else {
                            alert(data);
                            me.infoPis.hide();
                        }
                    });
                }
            }
        });
        return false;
    },
    djs: function() {
        var $timeEndDjs = $("#timeEndDjs").attr("data-value"),
        $mius,
        $day,
        $yius,
        $timeEndDjss;
        if ($timeEndDjs > 60) {
            $mius = parseInt($timeEndDjs / 60);
            $timeEndDjss = $timeEndDjs - ($mius * 60);
        }
        if ($mius > 60) {
            $yius = parseInt($mius / 60);
            $mius = $mius - ($yius * 60);
        }
        if ($yius > 24) {
            $day = parseInt($yius / 24);
            $yius = $yius - ($day * 24);
        }
        $sysj = $day ? $day + "天": "";
        $sysj += $yius ? $yius + "时": "";
        $sysj += $mius ? $mius + "分": "";
        if ($timeEndDjss == 0) {
            $sysj += $timeEndDjss + "秒";
        } else {
            $sysj += $timeEndDjss ? $timeEndDjss + "秒": $timeEndDjs + "秒";
        }
        $("#timeEndDjs").html($sysj);
        $("#timeEndDjs").attr("data-value", $timeEndDjs - 1);
        $me = this;
        $dsq = setInterval($me.djs, 1000);
        if ($timeEndDjs <= 1) {
            $("#timeEndDjs").html("活动已结束");
            window.clearInterval($dsq);
        }
    },
    showShop: function(id, types) {
        var me = this;
        $.post("/index.php?s=ArticleShop.html", {
            id: id,
            types: types
        },
        function(data) {
            if (data.Msg == "true") {
                $("#ArticleShop .xq_title span").html(me.removeHTMLTag(data.randomVal[0].title));
                $("#ArticleShop .xq_Contents .xq_Contents_text").html(data.randomVal[0].Contents);
                $("input[name=quantity]").attr("value", "1");
                $("#Confirm").attr("href", "javascript:Util.shopArticle(" + data.randomVal[0].id + "," + types + ");");
                $("#ArticleShop").show();
                $(".bgCeng").fadeIn();
            } else {
                me.pis(data.randomVal);
            }
        });
    },
    shopArticle: function(id, types) {
        var me = this;
        var quantity = $("input[name=quantity]").val();
        $.post("/index.php?s=shopArticle.html", {
            id: id,
            quantity: quantity,
            types: types
        },
        function(data) {
            if (data.Msg == "true") {
                $("#ArticleShop").hide();
                me.pis(data.randomVal);
                var htmlContentAppend = '<tr>' + '<td class="blue">圣诞限定</td>' + '<td class="blue">' + data.dataVal["ArticleName"] + '</td>' + '<td class="blue">' + data.dataVal["quantity"] + '</td>' + '<td class="blue">' + data.dataVal["Successcode"] + '</td>' + '<td class="blue">' + data.dataVal["time"] + '</td>' + '<td class="blue"></td>' + '</tr>';
                $("#userTableList").append(htmlContentAppend);
                $(".bgCeng").fadeOut();
            } else {
                me.pis(data.randomVal);
            }
        });
    },
    deleteShop: function(id) {
        var me = this;
        $.post("/index.php?s=deleteShop.html", {
            id: id
        },
        function(data) {
            if (data.Msg == "true") {
                me.pis(data.randomVal);
                $("#myshoppingcart-" + id).empty();
            } else {
                me.pis(data.randomVal);
            }
        });
    },
    removeHTMLTag: function(str) {
        str = str.replace(/<\/?[^>]*>/g, '');
        str = str.replace(/[ | ]*\n/g, '\n');
        str = str.replace(/ /ig, '');
        return str;
    },
    awardAntine: function() {
        var that = $(".chest-close");
        that.addClass("shake");
        window.addEventListener("webkitAnimationEnd",
        function() {
            $(that).closest(".open-has").addClass("opened");
            setTimeout(function() {
                $(that).removeClass("show");
                $(that).closest(".mod-chest").find(".chest-open").addClass("show");
                setTimeout(function() {
                    $(".chest-open").addClass("blur");
                },
                500);
            },
            200)
        },
        false);
    },
    WishingPageList: function() {
        var me = this;
        var page = parseInt($("input[name=WishingPage]").val());
        var GameId = $("#gameId").val();
        $.post("/wishpage", {
			gameId: GameId,
            page: page
        },
        function(data) {
            if (data.length > 0) {
                $("input[name=WishingPage]").attr("value", page + 1);
                var htmlContent = "";
                var ifNum = 0;
                for (var i = 0; i < data.length; i++) {
                    if (ifNum < 1) {
                        var classblue = "class='blue'";
                        ifNum++;
                    } else {
                        var classblue = "";
                        ifNum = 0;
                    }
                    htmlContent += '<tr class="addClassBg WishingMoreListAppend">' + '<td ' + classblue + '>' + data[i].Account + '</td>' + '<td ' + classblue + '>' + data[i].Content + '</td>' + '<td ' + classblue + '>获得' + data[i].Thumbs + '个赞</td>' + '<td ' + classblue + '><a href="javascript:Util.ThumbsUp(' + data[i].Id + ');" class="WishingPageListZan">赞一下</a></td>' + '</tr>';
                }
                $(".WishingMoreListAppend:last").after(htmlContent);
            } else {
				$(".WishingPageListMore").html("没有更多了")
            }
        });
    }
}
Util.init();