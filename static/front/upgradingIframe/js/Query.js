// 弹出
function showDetail() {
    var _user = $("#search1").val();
    if (_user == "") {
        alert('会员帐号不能为空!');
        return;
    }
    $.ajax({
        url: '/upgrading/query',
        dataType: 'json',
        cache: false,
        data: {
            account: $("#search1").val()
        },
        type: 'Get',
        success: function (data) {
            //总信息
            var total = "";
            total = "<div class='tot0'>" + data.totalup.Account + "</div>"
                + "<div class='tot1'>" + data.totalup.Level + "</div>"
                + "<div class='tot2'>" + data.totalup.TotalAmount + "</div>"
                // + "<div style=\"width:110px\">" + data.totalup.TotalGift + "</div>"
                + "<div class='tot3'>" + data.totalup.WeekSalary + "</div>"
                + "<div class='tot4'>" + data.totalup.MonthSalary + "</div>"
                + "<div class='tot5'>" + data.totalup.Balance + "</div>";
            //周信息
            var week = "";
            $.each(data.weekup, function (i, award) {
                x = "<div class='tot6'>" + award.Account + "</div>"
                    + "<div class='tot7'>" + award.WeekAmount + "</div>"
                    + "<div class='tot8'>" + award.RiseAmount + "</div>"
                    + "<div class='tot9'>" + award.Period + "</div>";
                week += x;
            });
            if (data.totalup.TotalAmount != 0) {
                $("#totalup").html(total);
            }
            if (data.weekup.length != 0) {
                $("#weekup").html(week)
                str = "共"+data.weekup.length+"条"
                $("#countweek").text(str)
            }
        }
    });
    $('body #show').show();
};
$('#close').click(function () {
    $(this).parent().parent().hide();
});