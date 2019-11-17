// -- 轮播 -----------------------------
// $(document).ready(function () {
//     var mySwiper = new Swiper('.swiper-container', {
//         autoplay: true,
//         loop: true, // 循环模式选项
//         // 如果需要分页器
//         pagination: {
//             el: '.swiper-pagination',
//         },

//         // 如果需要前进后退按钮
//         navigation: {
//             nextEl: '.swiper-button-next',
//             prevEl: '.swiper-button-prev',
//         },

//         // 如果需要滚动条
//         scrollbar: {
//             // el: '.swiper-scrollbar',
//         },

//     })
// })
// -- 菜单------------------------------------
//会员验证
var _username = "";
if (localStorage.getItem("username") && localStorage.getItem("username") != "null") {
    _username = localStorage.getItem("username");
    console.log(_username);
    checkUser();
}
function checkUser() {
    $.ajax({
        url: '/login',
        dataType: 'json',
        cache: false,
        type: 'POST',
        data: {gid: $("#gid").val(), account: _username},
        success: function (obj) {
            switch (obj.code) {
                case 0:
                    localStorage.clear();
                    layer.msg(obj.msg);
                    break;
                case 1:
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
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var x = 1;
            localStorage.clear();
        }
    })
}
var open = 1;
$("#menuBtn").on("click", function () {
    if (open) {
        $(".menu").fadeIn();
        $(".menu").css("display", "block");
        open = 0;
    } else {
        $(".menu").css("display", "none");
        open = 1;
    }
});
$("#menuBtn1").on("click", function () {
    if (open) {
        $(".menu").fadeIn("show");
        $(".menu").css("display", "block");
        open = 0;
    } else {
        $(".menu").css("display", "none");
        open = 1;
    }
});
// -- 登录框 ----------------------------
//弹框
function login() {
    $(".login").css("display", "block");
    $(".login").animate({
        top:"30%"
    },300);
    $(".black_overlay").css("display", "block");
}
//进行登录
$(".userLogin").on("click", function () {
    if (_username === "") {
        login();
    } else {
        $(".login").css("display", "block");
        $(".cont").css("opacity", "0.1");
        $(".login_tips").text("会员：‘" + user.uid + "’  ，您已经登录了哦！");
    }
});
//匹配 ID
$(".userLogin1").on("click", function () {
    if (!$("#uid").val()) {
        $(".login_tips").css("color", "red");
        $(".login_tips").text("x 错误：账号不能为空！");
        setTimeout(() => {
            $(".login_tips").text("");
        }, 700);
        clearTimeout(700);
    } else {
        $.post('/login', {
            gid: $('#gid').val(),
            account: $("#uid").val()
        }, function (obj) {
            switch (obj.code) {
                case 0:
                    localStorage.clear();
                    layer.msg(obj.msg);
                    break;
                case 1:
                    _username = $("#uid").val();
                    localStorage.username = _username;
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
        });
    }
})
//关闭登录框
$(".login_close").on("click", function () {
    $(".login").css("display", "none");
    $(".cont").css("opacity", "1");
    $(".black_overlay").css("display", "none");
})

//兑换礼品
var list = $(".list span");
var list_btn = $(".list button");
var allNum = [];

//兑换结果弹框
function res(result) {
    var resbox = $(".res_box");
    if (result) {
        resbox.fadeIn();
        $(".res_success").show();
        $(".res_err").hide();
        $(".black_overlay1").show()
    } else {
        resbox.fadeIn();
        $(".res_success").hide();
        $(".res_err").show()
        $(".black_overlay1").show()
    }
}
//兑换结果
function  excharge(giftid,fen) {
    if (_username === "" ) {
        login();
    } else {
        layer.open({
            title: '提示',
            shadeClose: true,
            icon: 3,
            content: '<div style="color: #000;">是否确认兑换？</div>',
            btn: ['确定', '取消'],
            yes: function (index) {
                $.ajax({
                    url: '/integral',
                    dataType: 'json',
                    cache: false,
                    type: 'POST',
                    data: {gid: $("#gid").val(), account: _username, giftid: giftid},
                    success: function (obj) {
                        switch (obj.code) {
                            case 1:
                                $("#fen").text($("#fen").text()-fen);
                                layer.open({
                                    title: '兑换成功',
                                    shadeClose: true,
                                    icon: 6,
                                    content: '<div style="color: #000;">' + (obj.msg ? obj.msg : "兑换成功") + '</div>'
                                });
                                break;
                            case 0:
                                layer.open({
                                    title: '兑换失败',
                                    shadeClose: true,
                                    icon: 5,
                                    content: '<div style="color: #000;">' + (obj.msg ? obj.msg : "兑换失败") + '</div>'
                                });
                                break;
                            default:
                                break;
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        layer.msg("请求异常，请刷新后重试");
                    }
                });
                layer.close(index);
            }
        });
       /* var this_grade = ($(this).parent().prev().children("span").text() - 0);
        if (user.grade < this_grade) {
            res(false)
        } else {
            user.grade -= this_grade;
            $(".grade").text(user.grade);
            res(true);
        }*/
    }
};
//兑换弹框关闭
$(".res_close").on("click", function () {
    $(".res_box").hide();
    $(".black_overlay1").hide()
});
//用户退出
$(".logout_btn1").on("click", function () {
    $.post('/logout', function (result) {
        localStorage.clear();
        window.location.reload();
    });
});
//积分规则
$(".jf_rule").on("click", function () {
    $(".cont").css("display", "none");
    $(".jilu_list").css("display", "none");
    $(".userLogin").css("display", "none");
    $(".rule").css("display", "block");
    $(".list").css("display", "inline-block");
    $(".userLogin2").css("display", "inline-block");
    if (user.isLogin) {
        $(".userLogin2").css("display", "none");
    }
});
//礼品列表
$(".list").on("click", function () {
    $(".rule").css("display", "none");
    // $(".list").css("display", "none");
    $(".jilu_list").css("display", "none");
    $(".cont").css("display", "block");
});
//兑换记录
$(".jilu").on("click", function () {
    if (user.isLogin) {
        $(".cont").css("display", "none");
        $(".userLogin").css("display", "none");
        $(".rule").css("display", "none");
        $(".list").css("display", "inline-block");
        $(".jilu_list").css("display", "block");
        $(".userLogin2").css("display", "none");
    } else {
        login()
    }
});

//礼品类别
var list_xj = $("ul .xianjin");
var list_sw = $(".shiwu");
var list_hf = $(".huafei");
var list_ly = $(".lvyou");
var more = $(".more");
var all = $("#all");
//显示w全部
$("#all").on("click", function () {
    list_hf.show();
    list_sw.show();
    list_xj.show();
    list_ly.show();
});
//显示现金券
$("#btn_xj").on("click", function () {
    list_hf.hide();
    list_sw.hide();
    list_ly.hide();
    list_xj.show();
    all.removeClass("active");

});
//显示话费券
$("#btn_hf").on("click", function () {
    list_xj.hide();
    list_sw.hide();
    list_ly.hide();
    list_hf.show();
    all.removeClass("active");

});
//显示实物券
$("#btn_sw").on("click", function () {
    list_hf.hide();
    list_xj.hide();
    list_ly.hide();
    list_sw.show();
    all.removeClass("active");

});
//显示旅游券
$("#btn_ly").on("click", function () {
    list_hf.hide();
    list_sw.hide();
    list_xj.hide();
    list_ly.show();
    all.removeClass("active");

});
//保持选中效果
var list_btn1 = $(".cont .btn-group button");
$(list_btn1).on("click", function () {
for (var bb = 0; bb < list_btn1.length; bb++) {
        $(list_btn1[bb]).css("background", "transparent");
        $(list_btn1[bb]).css("color", "#007bff");
        if($(this).css("background-color")!="#007bff"){
            $(this).css("background", "#007bff");
            $(this).css("color", "#fff");
        }
    }
});
