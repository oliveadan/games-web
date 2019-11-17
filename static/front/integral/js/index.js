var bCode = '';
function exit() {
    localStorage.clear();
    window.location.reload();
}

function logDiv() {
    if ($('#user').html() != '') {
        return;
    }
    $(".dialog").show();
    $(".tc_box").show().animate({"top": ($(window).height() - $(".tc_box").height()) / 2});
}

function ShowIntegral() {
    if ($('#user').html() != '') {
        layer.open({
            title:"当前积分",
            content:'<div style="text-align: center">'+"您当前有"+localStorage.getItem("lotteryNums")+"分"+'</div>'
        })
    }else {
        $(".dialog").show();
        $(".tc_box").show().animate({"top": ($(window).height() - $(".tc_box").height()) / 2});
    }
}

function listDiv() {
    if ($('#user').html() == '') {
        logDiv();
        return;
    }
    showList(1);
    $('#listBox').find('.dialog-box').show();
    $('#listBox').find('.dialog-mask').show();
    $('#listBox').show();
}


function change(_id) {
    if ($('#user').html() == '') {
        logDiv();
        return;
    }
    layer.confirm('您确定要兑换这个礼品吗？', {
        btn: ['确定', '取消'] //按钮
    }, function () {
        $.ajax({
            url: '/integral',
            dataType: 'json',
            cache: false,
            data:  {
                gid:$("#gid").val(),
                account: _username,
                giftid:_id},
            type: 'POST',
            success: function (obj) {
                if (obj.code ==1){
                    layer.open({
                        title: "兑换成功",
                        content:obj.msg
                    })
                }else {
                    layer.open({
                        title: "兑换失败",
                        content:obj.msg
                    })
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var x = 1
            }
        })
    }, function () {
        layer.closeAll();
    });
}
function showList(pageIndex) {
    $.ajax({
        url: '/frontshare/lotteryquery',
        dataType: 'json',
        cache: false,
        data: {
            gid:$("#gid").val(),
            account:_username,
        },
        type: 'POST',
        beforeSend: function () {
            layer.load();
        },
        success: function (obj) {
            layer.closeAll('loading');
                console.log(obj)
                var strHTML = '<tr><th>会员账号</th><th>兑换内容</th><th>兑换时间</th><th>是否派彩</th></tr>';
                var data = obj.data.list;
                if (obj.data.total > 0) {
                    for (i = 0; i < data.length; i++) {
                        strHTML += '<tr>';
                        strHTML += '<td>' + data[i].account + '</td>';
                        strHTML += '<td>' + data[i].gift + '</td>';
                        strHTML += '<td>' + data[i].createDate + '</td>';
                        if (data[i].delivered == 1) {
                            strHTML += '<td>未派彩</td>';
                        } else {
                            strHTML += '<td style="color:#ff0000">已派彩</td>';
                        }
                    }
                    $('.js-show').html(strHTML);
                    var sPage = Paging(pageIndex, 6, obj.data.total, 2, "showList", '', '', '上一页', '下一页');
                    $(".quotes").html(sPage);
                } else {
                    strHTML += '<tr><td colspan="7">暂无兑换记录</td></tr>';
                    $('.js-show').html(strHTML);
                }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var x = 1
        }
    })

}

$(function () {
    $('.dialog-mask').click(function () {
        $(this).parent().hide();
    });
    $('#imgcode').click(function () {
        $('#imgcode').attr('src', 'includes/imgcode.php?r=' + Math.random());
    });
    if (localStorage.getItem("username") && localStorage.getItem("username") != "null") {
        _username = localStorage.getItem("username");
        checkUser();
    }
    function checkUser() {
        $.ajax({
            url: '/login',
            dataType: 'json',
            cache: false,
            type: 'POST',
            data: {gid:$("#gid").val(),account: _username},
            success: function (obj) {
                console.log(obj)
                switch(obj.code){
                    case 0:
                        localStorage.clear();
                        layer.msg(obj.msg);
                        break;
                    case 1:
                        $('#islogin').show();
                        $('#user').html(_username);
                        $('#draw').html(obj.data.lotteryNums);

                        $('#login_li').hide();
                        $(".dialog").hide();
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

    $("#login-btn").click(function () {
        if ($('#username').val() == '') {
            layer.msg('请输入会员账号!', {icon: 2});
            return false;
        }
        if ($('#verycode').val() == '') {
            layer.msg('请输入验证码!', {icon: 2});
            return false;
        }
        $.ajax({
            url: '/logincpt',
            dataType: 'json',
            cache: false,
            data: {
                gid: $('#gid').val(),
                account: $('#username').val(),
                captcha_id: $(":input[name='captcha_id']").val(),
                captcha: $(":input[name='captcha']").val()
            },
            type: 'POST',
            beforeSend: function () {
                layer.load();
            },
            success: function (obj) {
                layer.closeAll('loading');
                switch (obj.code) {
                    case 0:
                        localStorage.clear();
                        layer.msg(obj.msg);
                        break;
                    case 1:
                        localStorage.username = $('#username').val();
                        localStorage.lotteryNums = obj.data.lotteryNums
                        layer.msg(obj.msg);
                        setTimeout(function(){
                            window.location.reload();
                        },1000);
                        break;
                    default:
                        break;
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                var x = 1;
            }
        })
    })
});


function Paging(pageNum, pageSize, totalCount, skipCount, fuctionName, currentStyleName, currentUseLink, preText, nextText, firstText, lastText) {
    var returnValue = "";
    var begin = 1;
    var end = 1;
    var totalpage = Math.floor(totalCount / pageSize);
    if (totalCount % pageSize > 0) {
        totalpage++;
    }
    if (preText == null) {
        firstText = "prev";
    }
    if (nextText == null) {
        nextText = "next";
    }
    begin = pageNum - skipCount;
    end = pageNum + skipCount;
    if (begin <= 0) {
        end = end - begin + 1;
        begin = 1;
    }
    if (end > totalpage) {
        end = totalpage;
    }
    for (count = begin; count <= end; count++) {
        if (currentUseLink) {
            if (count == pageNum) {
                returnValue += "<a class=\"" + currentStyleName + "\" href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";
            }
            else {
                returnValue += "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";
            }
        }
        else {
            if (count == pageNum) {
                returnValue += "<span class=\"" + currentStyleName + "\">" + count.toString() + "</span> ";
            }
            else {
                returnValue += "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";
            }
        }
    }
    if (pageNum - skipCount > 1) {
        returnValue = " ... " + returnValue;
    }
    if (pageNum + skipCount < totalpage) {
        returnValue = returnValue + " ... ";
    }
    if (pageNum > 1) {
        returnValue = "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + (pageNum - 1).toString() + ");\"> " + preText + "</a> " + returnValue;
    }
    if (pageNum < totalpage) {
        returnValue = returnValue + " <a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + (pageNum + 1).toString() + ");\">" + nextText + "</a>";
    }

    if (firstText != null) {
        if (pageNum > 1) {
            returnValue = "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(1);\">" + firstText + "</a> " + returnValue;
        }
    }

    if (lastText != null) {
        if (pageNum < totalpage) {
            returnValue = returnValue + " " + " <a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + totalpage.toString() + ");\">" + lastText + "</a>";
        }
    }
    return returnValue;
}