 var gid = "";
function queryBtn() {
    var _bonuscode = $("#querycode").val();
    if (_bonuscode == "") {
        layer.msg("会员帐号不能为空!");
        return false;
    }
    gid = $("#gid").val();
    queryPage(1);
    console.log(gid)
}

var pagesize = 5;

function queryPage(page) {
    $.ajax({
        url: '/frontshare/lotteryquery',
        dataType: 'json',
        cache: false,
        data: {
            gid: gid,
            account: $("#querycode").val(),
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
                    $(".quotes").html(sPage);
                    $("#query_content").html(sHtml1);
                } else {
                    $("#query_content").html("<tr><td colspan='3'>没有中奖记录</td></tr>");
                }
            } else {
                layer.msg(res.msg);
            }
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
