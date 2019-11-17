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
            total = "<div>" + data.totalup.Account + "</div>"
                + "<div>" + data.totalup.Level + "</div>"
                + "<div style=\"width:20%\">" + data.totalup.TotalAmount + "</div>"
                + "<div style=\"width:10%\">" + data.totalup.TotalGift + "</div>"
                + "<div style=\"width:10%\">" + data.totalup.WeekSalary + "</div>"
                + "<div style=\"width:10%\">" + data.totalup.MonthSalary + "</div>"
                + "<div style=\"width:25%\">" + data.totalup.Balance + "</div>";
            //周信息
            var week = "";
            $.each(data.weekup, function (i, award) {
                x = "<div style=\"width:20%\">" + award.Account + "</div>"
                    + "<div style=\"width:20%\">" + award.WeekAmount + "</div>"
                    + "<div style=\"width:20%\">" + award.RiseAmount + "</div>"
                    + "<div style=\"width:35%\">" + award.Period + "</div>";
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