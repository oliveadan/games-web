$("#signin").click(function () {
    var account = $("#account").val();
    if (account == "") {
        layer.msg("请输入会员账号");
        return;
    }
    $("#signin").attr("disabled", true);
    $.ajax({
        url: '/signin',
        dataType: 'json',
        cache: false,
        type: 'POST',
        data: {"gid": $("#gid").val(), "account": account},
        success: function (obj) {
            if (obj.code != 1) {
                $("#signin").attr("disabled", false);
            }
            if (obj.code == 0) {
                $("#rankDay1Btn").show();
                layer.msg(obj.msg);
            } else if (obj.code == 2) {
                $("#rankDay1Btn").show();
                bool = true;
                layer.msg(obj.msg);
            } else if (obj.code == 1) {
                bool = true;
                var html = '';
                if (obj.data.hasOwnProperty("giftContent")) {
                    html = '<div>恭喜您获得</div>';
                    html = html + '</br>';
                    html = html + '<span style="font-size:37px;color: red">' + obj.data.giftContent + '&nbsp;元</span>';
                    $("#content").text(obj.data.giftContent + '元')
                }
                var level = "";
                if (obj.data.force1 < 0) {
                    level = '<div><span style="color:orangered">您以达到最大等级</span></div>'
                } else {
                    level = '<div>到<span style="color:red">' + obj.data.nextlevlelNme + '</span>还需<span style="color:red;">&nbsp;' + obj.data.force1 + obj.data.unit + '</span></div>'
                }
                html = html + level;
                if (obj.data.hasOwnProperty("gift")) {
                    html = html + '</br>';
                    html = html + '<span style="font-weight: bolder;font-size:20px;color:#6C187C;" >' + obj.data.gift + '</span>';
                    $("#other").text("恭喜您额外获得：" + obj.data.gift)
                    $("#levelname").text("您当前的签到等级为:" + obj.data.levelName)
                }
                window.location = "#qiandao";
            }
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            layer.msg("请求异常，请稍后再试", {icon: 2});
        }
    })
});

$("#query").click(function () {
    if ($("#account").val() == "") {
        layer.msg("请输入会员账号");
        return false;
    }
    queryPage(1);
});
var pagesize = 5;

function queryPage(page) {
    $.ajax({
        url: '/frontshare/lotteryquery',
        dataType: 'json',
        cache: false,
        data: {
            gid: $("#gid").val(),
            account: $("#account").val(),
            page: page,
            pagesize: pagesize
        },
        type: 'POST',
        success: function (res) {
            if (res.code == 1) {
                var sHtml1 = "";
                var x = "";
                if (res.data.total > 0) {
                    $.each(res.data.list, function (i, award) {
                        x = (award.delivered == 1) ? "<font color=yellow>已派彩</font>" : "<font color=white>未派彩</font>";
                        sHtml1 += "<tr><td>" + award.gift + "</td><td>" + award.createDate + "</td><td>" + x + "</td></tr>";
                    })
                    var sPage = Paging(page, pagesize, res.data.total, 2, "queryPage", '', '', '上一页', '下一页');
                    $(".rl_pages").html(sPage);
                    $("#rl_content").html(sHtml1);
                } else {
                    $("#rl_content").html("<tr><td colspan='3'>没有中奖记录</td></tr>");
                }
            } else {
                layer.msg(res.msg);
            }
            window.location = "#chaxun"
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var x = 1;
        }
    })
}

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
            } else {
                returnValue += "<a href=\"javascript:void(0);\" onclick=\"" + fuctionName + "(" + count.toString() + ");\">" + count.toString() + "</a> ";
            }
        } else {
            if (count == pageNum) {
                returnValue += "<span class=\"" + currentStyleName + "\">" + count.toString() + "</span> ";
            } else {
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
