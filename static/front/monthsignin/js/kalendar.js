var _username = "";
if (localStorage.getItem("username") && localStorage.getItem("username") != "null") {
    _username = localStorage.getItem("username");
    checkUser();
}

var rec = new Array;
var mid = new Array;

var calUtil = {
    //当前日历显示的年、月、日
    showYear: 2019,
    showMonth: 1,
    showDays: 1,
    eventName: "load",
    //初始化日历
    init: function (signList) {
        calUtil.setMonthAndDay();
        calUtil.draw(signList);
        //事件
        calUtil.bindEnvent();
    },
    draw: function (signList) {
        //绑定日历
        var str = calUtil.drawCal(calUtil.showYear, calUtil.showMonth, signList);
        $("#calendar").html(str);
        //绑定日历表头
        // var myDate = new Date;
        // var date = myDate.getDate();
        // var calendarName = calUtil.showYear + "年" + calUtil.showMonth + "月" + date + "日";
        var calendarName = calUtil.showYear + "年" + calUtil.showMonth + "月";
        $(".calendar_month_span").html(calendarName);

        return calUtil.showMonth

    },
    //获取当前选择的年月
    setMonthAndDay: function () {
        switch (calUtil.eventName) {
            case "load":
                var current = new Date();
                calUtil.showYear = current.getFullYear();
                calUtil.showMonth = current.getMonth() + 1;
                break;
            case "prev":
                var nowMonth = $(".calendar_month_span").html().split("年")[1].split("月")[0];
                calUtil.showMonth = parseInt(nowMonth) - 1;
                if (calUtil.showMonth == 0) {
                    calUtil.showMonth = 12;
                    calUtil.showYear -= 1;
                }
                break;
            case "next":
                var nowMonth = $(".calendar_month_span").html().split("年")[1].split("月")[0];
                calUtil.showMonth = parseInt(nowMonth) + 1;
                if (calUtil.showMonth == 13) {
                    calUtil.showMonth = 1;
                    calUtil.showYear += 1;
                }
                break;
            case "today":
                var myDate = new Date();
                var month = myDate.getMonth() + 1;
                var nowMonth = $(".calendar_month_span").html().split("年")[1].split("月")[0];;
                calUtil.showMonth = month;
                break;
        }
    },
    getDaysInmonth: function (iMonth, iYear) {
        var dPrevDate = new Date(iYear, iMonth, 0);
        return dPrevDate.getDate();
    },
    bulidCal: function (iYear, iMonth) {
        var aMonth = new Array();
        aMonth[0] = new Array(7);
        aMonth[1] = new Array(7);
        aMonth[2] = new Array(7);
        aMonth[3] = new Array(7);
        aMonth[4] = new Array(7);
        aMonth[5] = new Array(7);
        aMonth[6] = new Array(7);
        var dCalDate = new Date(iYear, iMonth - 1, 1);
        var iDayOfFirst = dCalDate.getDay();
        var iDaysInMonth = calUtil.getDaysInmonth(iMonth, iYear);
        var iVarDate = 1;
        var d, w;
        aMonth[0][0] = "日";
        aMonth[0][1] = "一";
        aMonth[0][2] = "二";
        aMonth[0][3] = "三";
        aMonth[0][4] = "四";
        aMonth[0][5] = "五";
        aMonth[0][6] = "六";
        for (d = iDayOfFirst; d < 7; d++) {
            aMonth[1][d] = iVarDate;
            iVarDate++;
        }
        for (w = 2; w < 7; w++) {
            for (d = 0; d < 7; d++) {
                if (iVarDate <= iDaysInMonth) {
                    aMonth[w][d] = iVarDate;
                    iVarDate++;
                }
            }
        }
        return aMonth;
    },
    ifHasSigned: function (signList, day) {
        var signed = false;
        $.each(signList, function (index, item) {
            if (item.SignDay == day) {
                signed = true;
                return false;
            }
            return day;
        });
        return signed;
    },
    drawCal: function (iYear, iMonth, signList) {
        var htmlbtn = "<button class='nowSign btn btn-qiandao' onclick='nowSign(" + calUtil.showMonth + ")'>马上签到</button>";
        $(".qdList").html(htmlbtn);
        var login = '<div class="col-12 row login_tit m-0"><a class="vipSign text-left pl-4">会员登录</a><button class="btn col-2 login_close" onclick="closeLogin()">关闭</button></div><div class="col-12 p-0 text-center bg-light"><p class="bg-light"></p><input id="uid" class="text-center" type="text" placeholder="请输入会员账号" autofocus></div><div style="margin-bottom: 12px;" class="col-12 p-0 text-center bg-light"><p class="login_tips bg-light"></p><button class="login_btn btn btn-warning userLogin1" onclick="User(' + calUtil.showMonth + ')">立 即 登 录</button></div>';
        $(".login").html(login);
        var myMonth = calUtil.bulidCal(iYear, iMonth);
        var htmls = new Array();
        htmls.push("<div class='sign_main' id='sign_layer'>");
        htmls.push("<div class='sign_succ_calendar_title'>");
        htmls.push("<div class='calendar_month_next'>下月</div>");
        htmls.push("<div class='calendar_month_prev'>上月</div>");
        htmls.push("<div class='calendar_month_span'></div>");
        htmls.push("</div>");
        htmls.push("<div class='sign' id='sign_cal'><div class='div-container2' id='div-container2' style='display: none;'></div><b class='titleB'>点击日期查看奖品内容</b>");
        // htmls.push("<div class='sign' id='sign_cal'><div class='div-container2' id='div-container2' style='display: none;'></div><b class='titleB'>点击日期查看奖品内容或补签</b>");
        htmls.push("<table>");
        htmls.push("<tr>");
        htmls.push("<th>" + myMonth[0][0] + "</th>");
        htmls.push("<th>" + myMonth[0][1] + "</th>");
        htmls.push("<th>" + myMonth[0][2] + "</th>");
        htmls.push("<th>" + myMonth[0][3] + "</th>");
        htmls.push("<th>" + myMonth[0][4] + "</th>");
        htmls.push("<th>" + myMonth[0][5] + "</th>");
        htmls.push("<th>" + myMonth[0][6] + "</th>");
        htmls.push("</tr>");
        var d, w;
        for (w = 1; w < 7; w++) {
            htmls.push("<tr>");
            for (d = 0; d < 7; d++) {
                var ifHasSigned = calUtil.ifHasSigned(signList, myMonth[w][d]);
                if (ifHasSigned) {
                    htmls.push(
                        // "<td class='on'>" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " "
                        "<td  class='on'><button id='did" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "' class='dateDay btn btn-lg' style='background-color:transparent;' data-toggle='modal' data-target='#myModal" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "' onclick='query(" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "," + calUtil.showMonth + ")'><div id='dn" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "' class='dateNum'>" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "</div></button></td>");
                } else {
                    htmls.push(
                        "<td id='myMdl" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "' class='dateList'><button id='did" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "' class='dateDay btn btn-lg' style='background-color:transparent;' data-toggle='modal' data-target='#myModal" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "' onclick='query(" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "," + calUtil.showMonth + ")'><div id='dn" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "' class='dateNum'>" + (!isNaN(myMonth[w][d]) ? myMonth[w][d] : " ") + "</div></button></td>"
                    );
                }
            }
        }
        htmls.push("</table>");
        htmls.push("</div>");
        htmls.push("</div>");
        return htmls.join('');
    },
    bindEnvent: function () {
        $(".calendar_month_span").click(function () {
            var nowtime = new Date();
            var month = nowtime.getMonth() + 1;
            $.ajax({
                url: '/monthsignin/login',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {
                    gameid: $("#gid").val(),
                    account: _username,
                    month: month
                },
                success: function (obj) {
                    if (obj.code == 1) {
                        var rec = obj.data.received;
                        var sd = obj.data.signed;
                        setTimeout(() => {
                            if (obj.data.todaysign == 1) {
                                $('.nowSign').html('已签到');
                                $('.nowSign').css('background-color', 'rgb(155, 155, 155)');
                                $('.nowSign').css('opacity', '1');
                                $('.nowSign').attr("disabled", true);
                            }
                            if (sd != null) {
                                var sd2;
                                for (var i = 0; i < sd.length; i++) {
                                    sd2 = sd[i];
                                    $('#myMdl' + sd2.SignDay + '').css("background-color", "#dc7a14");
                                    $('#myModal' + sd2.SignDay + '').attr("disabled", true);
                                    if (sd2.Status == 1) {
                                        $('#dn' + sd2.SignDay + '').css('display', 'none');
                                        $('#did' + sd2.SignDay + '').html(bqimg);
                                        $('#did' + sd2.SignDay + '').css('margin', '0');
                                    }
                                }
                            }
                        }, 1);
                        clearTimeout(1);
                        if (rec != null) {
                            for (var i = 0; i < rec.length; i++) {
                                for (var j = 0; j < mid.length; j++) {
                                    if (rec[i] == mid[j]) {
                                        $('#mid' + mid[j] + '').html("已领取");
                                        $('#mid' + mid[j] + '').css("background", "rgb(110, 110, 110)");
                                        $('#mid' + mid[j] + '').attr("disabled", "true");
                                    }
                                }
                            }
                        }
                        var signList = obj.data.signed;
                        calUtil.eventName = "today";
                        calUtil.init(signList);

                    } else {
                        $(".login").css("display", "block");
                        $(".login").animate({
                            top: "30%"
                        }, 300);
                        $(".black_overlay").css("display", "block");
                    }
                }
            })
        })

        $(".calendar_month_prev").click(function () {
            $.ajax({
                url: '/monthsignin/login',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {
                    gameid: $("#gid").val(),
                    account: _username,
                    month: calUtil.showMonth - 1
                },
                success: function (obj) {
                    if (obj.code == 1) {
                        if (calUtil.showMonth == 1) {
                            layer.msg('已经不能再回到上一个月了');
                        } else {
                            var rec = obj.data.received;
                            var sd = obj.data.signed;
                            setTimeout(() => {
                                if (obj.data.todaysign == 1) {
                                    $('.nowSign').html('已签到');
                                    $('.nowSign').css('background-color', 'rgb(155, 155, 155)');
                                    $('.nowSign').css('opacity', '1');
                                    $('.nowSign').attr("disabled", true);
                                }
                                if (sd != null) {
                                    var sd2;
                                    for (var i = 0; i < sd.length; i++) {
                                        sd2 = sd[i];
                                        $('#myMdl' + sd2.SignDay + '').css("background-color", "#dc7a14");
                                        $('#myModal' + sd2.SignDay + '').attr("disabled", true);
                                        if (sd2.Status == 1) {
                                            $('#dn' + sd2.SignDay + '').css('display', 'none');
                                            $('#did' + sd2.SignDay + '').html(bqimg);
                                            $('#did' + sd2.SignDay + '').css('margin', '0');
                                        }
                                    }
                                }
                            }, 1);
                            clearTimeout(1);
                            if (rec != null) {
                                for (var i = 0; i < rec.length; i++) {
                                    for (var j = 0; j < mid.length; j++) {
                                        if (rec[i] == mid[j]) {
                                            $('#mid' + mid[j] + '').html("已领取");
                                            $('#mid' + mid[j] + '').css("background", "rgb(110, 110, 110)");
                                            $('#mid' + mid[j] + '').attr("disabled", "true");
                                        }
                                    }
                                }
                            }
                            var signList = obj.data.signed;
                            calUtil.eventName = "prev";
                            calUtil.init(signList);
                        }
                    } else {
                        $(".login").css("display", "block");
                        $(".login").animate({
                            top: "30%"
                        }, 300);
                        $(".black_overlay").css("display", "block");
                    }
                }
            })
        })

        $(".calendar_month_next").click(function () {
            $.ajax({
                url: '/monthsignin/login',
                dataType: 'json',
                cache: false,
                type: 'POST',
                data: {
                    gameid: $("#gid").val(),
                    account: _username,
                    month: calUtil.showMonth + 1
                },
                success: function (obj) {
                    if (obj.code == 1) {
                        if (calUtil.showMonth == 12) {
                            layer.msg('已经不能再去到下一个月了');
                        } else {
                            var rec = obj.data.received;
                            var sd = obj.data.signed;
                            setTimeout(() => {
                                if (obj.data.todaysign == 1) {
                                    $('.nowSign').html('已签到');
                                    $('.nowSign').css('background-color', 'rgb(155, 155, 155)');
                                    $('.nowSign').css('opacity', '1');
                                    $('.nowSign').attr("disabled", true);
                                }
                                if (sd != null) {
                                    var sd2
                                    for (var i = 0; i < sd.length; i++) {
                                        sd2 = sd[i];
                                        $('#myMdl' + sd2.SignDay + '').css("background-color", "#dc7a14");
                                        $('#myModal' + sd2.SignDay + '').attr("disabled", true);
                                        if (sd2.Status == 1) {
                                            $('#dn' + sd2.SignDay + '').css('display', 'none');
                                            $('#did' + sd2.SignDay + '').html(bqimg);
                                            $('#did' + sd2.SignDay + '').css('margin', '0');
                                        }
                                    }
                                }
                            }, 1);
                            clearTimeout(1);
                            if (rec != null) {
                                for (var i = 0; i < rec.length; i++) {
                                    for (var j = 0; j < mid.length; j++) {
                                        if (rec[i] == mid[j]) {
                                            $('#mid' + mid[j] + '').html("已领取");
                                            $('#mid' + mid[j] + '').css("background", "rgb(110, 110, 110)");
                                            $('#mid' + mid[j] + '').attr("disabled", "true");
                                        }
                                    }
                                }
                            }
                            var signList = obj.data.signed;
                            calUtil.eventName = "next";
                            calUtil.init(signList);
                        }
                    } else {
                        $(".login").css("display", "block");
                        $(".login").animate({
                            top: "30%"
                        }, 300);
                        $(".black_overlay").css("display", "block");
                    }
                }
            })
        })
    },
};

// 轮播
var mySwiper = new Swiper('.swiper-container', {
    direction: 'horizontal',
    loop: true,
    autoplay: 3000,
    speed: 2500,
    // 分页器
    pagination: {
        el: '.swiper-pagination',
    },
    autoplayDisableOnInteraction: false,
});

//连续签到奖品
$.ajax({
    url: '/monthsignin/daygift',
    dataType: 'json',
    cache: false,
    type: 'POST',
    data: {
        gameid: $("#gid").val(),
        account: $("#uid").val(),
    },
    success: function (obj) {
        if (obj.code == 1) {
            var gifts = obj.data.gifts;
            if (gifts.length != 0) {
                var Html1 = '';
                var Htmls = '';
                for (var a = 0; a < gifts.length; a++) {
                    var Name = gifts[a].Name;
                    var Content = gifts[a].Content;
                    var Id = gifts[a].Id;
                    var photo = gifts[a].Photo;
                    Html1 = '<div class="clearfix borderb ptb10"><div class="col-xs-9 clearPadding"><div class="media"><a class="media-left pt3" href="javascript:void(0);"><img src="' + photo + '" style="width:30px;height:30px;"></a><div class="media-body"><div>' + Name + '</div><div class="text-muted font12">' + Content + '</div></div></div></div><div class="col-xs-3 clearPadding text-right pt2"><button id="mid' + Id + '" class="btn btn-lingqu" onclick="myid(' + Id + ')">领取</button></div></div>';
                    Htmls += Html1;
                    mid.push(Id);
                }
                $('.libaolist').append(Htmls);
            }
        }
    }
})

//签到
function nowSign(a) {
    if (localStorage.username == undefined) {
        $(".login").css("display", "block");
        $(".login").animate({
            top: "30%"
        }, 300);
        $(".black_overlay").css("display", "block");
    } else {
        $.ajax({
            url: '/monthsignin/signin',
            dataType: 'json',
            cache: false,
            type: 'POST',
            data: {
                gameid: $("#gid").val(),
                account: _username,
                month: a
            },
            success: function (obj) {
                var nowtime = new Date();
                var month = nowtime.getMonth() + 1;
                if (month != a) {
                    layer.msg("请到本月列表下签到");
                } else {
                    if (obj.code == 1) {
                        document.getElementById('signdays').innerHTML = parseInt(document.getElementById('signdays').innerHTML) + 1;
                        $('.nowSign').html('已签到');
                        $('.nowSign').css('background-color', 'rgb(155, 155, 155)');
                        $('.nowSign').css('opacity', '1');
                        $('.nowSign').attr("disabled", true);
                        //获取今日时间
                        var myDate = new Date();
                        var date = myDate.getDate();
                        $('#myMdl' + date + '').css("background-color", "#dc7a14");
                        $('#myMdl' + date + '').attr("disabled", true);

                        var container = document.getElementById('div-container2');
                        container.style.display = "block";
                        $('.div-container2').html('<div class="div-child-container2"><div class="div-child2"><div class="div-title2">恭喜您签到成功，获得奖品</div><div class="div-title2">' + obj.data.giftname + '</div><div class="div-body2">' + obj.data.giftcontent + '</div><div class="div-img2"></div><div class="my-btn2"><button class="cancleBtn2" onclick="cancle2()">确定</button></div></div>')
                        if (obj.data.giftgiftphoto != "") {
                            $('.div-img2').html('<img class="awardImg2" src="' + obj.data.giftphoto + '" alt="">');
                        }
                    } else {
                        layer.msg(obj.msg);
                    }
                }
            }
        })
    }
}

//登录
function User(a) {
    $.ajax({
        url: '/monthsignin/login',
        dataType: 'json',
        cache: false,
        type: 'POST',
        data: {
            gameid: $("#gid").val(),
            account: $("#uid").val(),
            month: a
        },
        success: function (obj) {
            switch (obj.code) {
                case 0:
                    localStorage.clear();
                    layer.msg(obj.msg);
                    break;
                case 1:
                    $('.sds').css('display', 'block');
                    $('.tddml').css('display', 'block');
                    setTimeout(() => {
                        $('.dml').html(obj.data.Bet);
                        $('.signdays').html(obj.data.sumdays);
                    }, 100);
                    clearTimeout(100);
                    _username = $("#uid").val();
                    localStorage.username = _username;
                    var rec = obj.data.received;
                    var sd = obj.data.signed;

                    setTimeout(() => {
                        if (obj.data.todaysign == 1) {
                            $('.nowSign').html('已签到');
                            $('.nowSign').css('background-color', 'rgb(155, 155, 155)');
                            $('.nowSign').css('opacity', '1');
                            $('.nowSign').attr("disabled", true);
                        }
                        if (sd != null) {
                            var sd2;
                            for (var j = 0; j < sd.length; j++) {
                                sd2 = sd[j];
                                if (sd2.Status == 1) {
                                    $('#dn' + sd2.SignDay + '').css('display', 'none');
                                    $('#did' + sd2.SignDay + '').html(bqimg);
                                    $('#did' + sd2.SignDay + '').css('margin', '0');
                                }
                            }
                        }
                    }, 10);
                    clearTimeout(10);

                    if (rec != null) {
                        for (var i = 0; i < rec.length; i++) {
                            for (var j = 0; j < mid.length; j++) {
                                if (rec[i] == mid[j]) {
                                    $('#mid' + mid[j] + '').html("已领取");
                                    $('#mid' + mid[j] + '').css("background", "rgb(110, 110, 110)");
                                    $('#mid' + mid[j] + '').attr("disabled", "true");
                                }
                            }
                        }
                    }
                    var SignList = obj.data.signed;
                    calUtil.init(SignList);
                    $(".login_tips").css("color", "green");
                    $(".login_tips").css("margin", "20px 0");
                    $(".login_tips").text("√ 恭喜您，登录成功！");
                    $(".cont").css("opacity", "1");
                    setTimeout(() => {
                        $(".login").css("display", "none");
                        $(".cont").css("opacity", "1");
                    }, 700);
                    clearTimeout(700);
                    $(".user_grade").css("display", "block");
                    $(".uid").text(_username);
                    $(".grade").text(obj.data.lotteryNums);
                    $(".black_overlay").css("display", "none");
                    $(".userLogin2").css("display", "none");
                    $(".jfsm").hide();
                    $("#uid").css("display", "none");
                    $(".login_btn").css("display", "none");
                    $(".registTips").css("display", "none");
                    $(".logout_btn").css("display", "block");
                    break;
                default:
                    break;
            }
        },
    })
}

//每日奖品查询
function query(a, b) {
    if (localStorage.username == undefined) {
        $(".login").css("display", "block");
        $(".login").animate({
            top: "30%"
        }, 300);
        $(".black_overlay").css("display", "block");
    } else {
        $.ajax({
            url: '/monthsignin/querygift',
            dataType: 'json',
            cache: false,
            type: 'POST',
            data: {
                gameid: $("#gid").val(),
                account: _username,
                day: a,
                month: b
            },
            success: function (obj) {
                if (obj.code == 1) {
                    var container = document.getElementById('div-container');
                    container.style.display = "block";
                    if (obj.data.showenable == 0) {
                        $('.div-title').html('敬请期待');
                        $('.div-title').css('margin', '50px');
                        $('.div-img').css('margin-bottom', '0px');
                        $('.div-body').css('display', 'none');
                        $('.div-foot').css('display', 'none');
                    } else {
                        $('.div-title').html(obj.data.giftname);
                        $('.div-body').html(obj.data.giftcontent);
                        $('.div-foot').html('存款' + obj.data.bet + '可签到')
                        $('.div-body').css('display', 'block');
                        $('.div-foot').css('display', 'block');
                        $('.div-title').css('margin', '15px');
                        $('.div-img').css('margin-bottom', '35px');
                    }
                    if (obj.data.giftgiftphoto != "") {
                        $('.div-img').html('<img class="awardImg" src="' + obj.data.giftphoto + '" alt="">');
                    }
                    if (obj.data.signenable == 1) {
                        $('.bq').html('<button class="bqBtn" onclick="buqian(' + a + ',' + b + ')">补签</button>');
                        $('.bq').css('display', 'block');
                    } else {
                        $('.bq').css('display', 'none');
                    }
                } else {
                    layer.msg(obj.msg);
                }
            }
        })
    }
}

//补签
function buqian(a, b) {
    $.ajax({
        url: '/monthsignin/retroactive',
        dataType: 'json',
        cache: false,
        type: 'POST',
        data: {
            gameid: $("#gid").val(),
            account: _username,
            day: a,
            month: b
        },
        success: function (obj) {
            var container = document.getElementById('div-container');
            container.style.display = "none";
            if (obj.code == 1) {
                document.getElementById('signdays').innerHTML = parseInt(document.getElementById('signdays').innerHTML) + 1;

                layer.msg(obj.msg);
                $('#dn' + a + '').css('display', 'none');
                $('#did' + a + '').html(bqimg);
                $('#did' + a + '').css('margin', '0');
                $('#myMdl' + a + '').css('background-color', '#dc7a14');
                if (obj.data.giftgiftphoto != "") {
                    $('.div-img').html('<img class="awardImg" src="' + obj.data.giftphoto + '" alt="">');
                }
            } else {
                layer.msg(obj.msg);
            }
        }
    })
}

function cancle() {
    var container = document.getElementById('div-container');
    container.style.display = "none";
}

function cancle2() {
    var container = document.getElementById('div-container2');
    container.style.display = "none";
}

//连续签到领奖
function myid(i) {
    if (localStorage.username == undefined) {
        $(".login").css("display", "block");
        $(".login").animate({
            top: "30%"
        }, 300);
        $(".black_overlay").css("display", "block");
    } else {
        $.ajax({
            url: '/monthsignin/getdaygift',
            dataType: 'json',
            cache: false,
            type: 'POST',
            data: {
                gameid: $("#gid").val(),
                account: _username,
                giftId: i,
            },
            success: function (obj) {
                if (obj.code == 1) {
                    layer.msg(obj.msg);
                    $('#mid' + i + '').html("已领取");
                    $('#mid' + i + '').css("background", "rgb(110, 110, 110)");
                    $('#mid' + i + '').attr("disabled", "true");
                } else {
                    layer.msg(obj.msg);
                }
            }
        })
    }
}

function login() {
    $(".login").css("display", "block");
    $(".login").animate({
        top: "30%"
    }, 300);
    $(".black_overlay").css("display", "block");
}

function dtl() {
    var container = document.getElementById('div-container3');
    container.style.display = "block";
}

function cancle3() {
    var container = document.getElementById('div-container3');
    container.style.display = "none";
}

//退出
$(".logout_btn1").on("click", function () {
    $.ajax({
        url: '/monthsignin/logout',
        dataType: 'json',
        cache: false,
        type: 'POST',
        data: {},
        success: function (obj) {
            localStorage.clear();
            window.location.reload();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var x = 1;
        }
    })
});

//关闭登录框
function closeLogin() {
    $(".login").css("display", "none");
    $(".cont").css("opacity", "1");
    $(".black_overlay").css("display", "none");
}

//浏览器本地缓存
function checkUser() {
    var nowtime = new Date();
    var month = nowtime.getMonth() + 1;
    $.ajax({
        url: '/monthsignin/login',
        dataType: 'json',
        cache: false,
        type: 'POST',
        data: {
            gameid: $("#gid").val(),
            account: _username,
            month: month
        },
        success: function (obj) {
            switch (obj.code) {
                case 0:
                    localStorage.clear();
                    layer.msg(obj.msg);
                    break;
                case 1:
                    $('.tddml').css('display', 'block');
                    $('.sds').css('display', 'block');
                    setTimeout(() => {
                        $('.on').css('background-color', '#dc7a14');
                        $('.dml').html(obj.data.Bet);
                        $('.signdays').html(obj.data.sumdays);
                    }, 100);
                    clearTimeout(100);
                    var rec = obj.data.received;
                    var sd = obj.data.signed;
                    setTimeout(() => {
                        if (obj.data.todaysign == 1) {
                            $('.nowSign').html('已签到');
                            $('.nowSign').css('background-color', 'rgb(155, 155, 155)');
                            $('.nowSign').css('opacity', '1');
                            $('.nowSign').attr("disabled", true);
                        }
                        if (sd != null) {
                            var sd2;
                            for (var j = 0; j < sd.length; j++) {
                                sd2 = sd[j];
                                if (sd2.Status == 1) {
                                    $('#dn' + sd2.SignDay + '').css('display', 'none');
                                    $('#did' + sd2.SignDay + '').html(bqimg);
                                    $('#did' + sd2.SignDay + '').css('margin', '0');
                                }
                            }
                        }
                    }, 100);
                    clearTimeout(100);
                    setTimeout(() => {
                        if (rec != null) {
                            for (var i = 0; i < rec.length; i++) {
                                for (var j = 0; j < mid.length; j++) {
                                    if (rec[i] == mid[j]) {
                                        $('#mid' + mid[j] + '').html("已领取");
                                        $('#mid' + mid[j] + '').css("background", "rgb(110, 110, 110)");
                                        $('#mid' + mid[j] + '').attr("disabled", "true");
                                    }
                                }
                            }
                        }
                    }, 100);
                    clearTimeout(100);
                    var SignList = obj.data.signed;
                    calUtil.init(SignList);
                    $(".login_tips").css("color", "green");
                    $(".login_tips").text("√ 恭喜您，登录成功！");
                    $(".cont").css("opacity", "1");
                    setTimeout(() => {
                        $(".login").css("display", "none");
                        $(".cont").css("opacity", "1");
                    }, 700);
                    clearTimeout(700);
                    $(".user_grade").css("display", "block");
                    $(".uid").text(_username);
                    $(".grade").text(obj.data.lotteryNums);
                    $(".black_overlay").css("display", "none");
                    $(".userLogin2").css("display", "none");
                    $(".jfsm").hide();
                    $("#uid").css("display", "none");
                    $(".login_btn").css("display", "none");
                    $(".registTips").css("display", "none");
                    $(".logout_btn").css("display", "block");
                    break;
                default:
                    break;
            }
        }
    })
}