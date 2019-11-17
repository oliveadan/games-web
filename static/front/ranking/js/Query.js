//弹窗查询
function showDetail(){
    if ($("#checkaccount").val() == ""){
        alert("请输入会员账号");
        return;
    }
    $.ajax({
        url:'/ranking/accountquery',
        dataType :'json',
        cache: false,
        data:{
            gameid : $("#gameid").val(),
            account : $("#checkaccount").val()
        },
        type:'Get',
        success:function (data) {
            //总榜
            var total = "";
            //周榜
            var week  = "";
            //月榜
            var month = "";
            //周榜条数
            var wcount =data.weeks.length;
            var weekcount = "共有"+wcount+"条";
            //月榜信息
            var mcount =data.months.length;
            var monthcount = "共有"+mcount+"条";
            //拼接总榜信息
            var deliver = "";
            deliver = (data.total.delivered == 1) ? "<font color=red>已派彩</font>" : "<font color=#9acd32>未派彩</font>";
            Prize = (data.total.Prize == "") ? "<font >无</font>" : "<font >"+data.total.Prize+"</font>";
            if(data.total.Amount === 0 && data.total.Seq === 0){
                total = "<div style=\"width:20%\">"+data.account+"</div>"+"<div style=\"width:20%\">"+"无"+"</div>"+"<div style=\"width:20%\">"+"未进入排名"+"</div>"+"<div style=\"width:20%\">"+"无"+"</div>"+"<div style=\"width:20%\">"+"无"+"</div>";
            }else{
                total = "<div style=\"width:20%\">"+data.total.Account+"</div>"+"<div style=\"width:20%\">"+data.total.Amount+"</div>"+"<div style=\"width:20%\">"+data.total.Seq+"</div>"+"<div style=\"width:20%\">"+Prize+"</div>"+"<div style=\"width:20%\">"+deliver+"</div>";
            };
            $("#total").html(total);
            //拼接周榜信息
            if(data.weeks.length==0){
                week = "<div style=\"width:16%\">"+data.account+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>"+"</div>"+"<div style=\"width:20%\">"+"无"+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>";

            }else $.each(data.weeks,function (i,award) {
                var deliver1 = "";
                deliver1 = (award.Delivered == 1) ? "<font color=red>已派彩</font>" : "<font color=#9acd32>未派彩</font>";
                Prize = (award.Prize == "") ? "<font >无</font>" : "<font >"+award.Prize+"</font>";
                x = "<div style=\"width:16%\">"+award.Account+"</div>"+"<div style=\"width:16%\">"+award.Amount+"</div>"+"<div style=\"width:16%\">"+award.Seq+"</div>"+"</div>"+"<div style=\"width:20%\">"+award.PeriodString+"</div>"+"<div style=\"width:16%\">"+Prize+"</div>"+"<div style=\"width:16%\">"+deliver1+"</div>";
                week += x
            });
            $("#week").html(week);
            $("#weekpages").html(weekcount);
            //拼接月榜信息
            if(data.months.length==0){
                month = "<div style=\"width:16%\">"+data.account+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>"+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>"+"<div style=\"width:20%\">"+"无"+"</div>"+"</div>"+"<div style=\"width:16%\">"+"无"+"</div>";
            }else $.each(data.months,function (i,award) {
                var deliver1 = ""
                deliver1 = (award.Delivered == 1) ? "<font color=red>已派彩</font>" : "<font color=#9acd32>未派彩</font>";
                Prize = (award.Prize == "") ? "<font >无</font>" : "<font >"+award.Prize+"</font>";
                j = "<div style=\"width:16%\">"+award.Account+"</div>"+"<div style=\"width:16%\">"+award.Amount+"</div>"+"<div style=\"width:16%\">"+award.Seq+"</div>"+"</div>"+"<div style=\"width:20%\">"+award.Period+"月份"+"</div>"+"<div style=\"width:16%\">"+Prize+"</div>"+"<div style=\"width:16%\">"+deliver1+"</div>";
                month += j;
            });
            $("#month").html(month);
            $("#monthpages").html(monthcount);
        }
    });
    var bgObj=document.getElementById("show");
    bgObj.style.display ="block"
};

//周排行榜查询
function WeekQuery(){
    $.ajax({
        url:'/ranking/query',
        dataType:'json',
        cache: false,
        data :{
            gameid : $("#gameid").val(),
            rankingType : 0,
            period : $("#Weekperiod").val()
        },
        type:'Get',
        success:function(data){
            var a ="";
            var index=1;
            $.each(data.list,function(i,award){
                x = "<tr>"+"<td style=\"width:33%\">"+award.Account+"</td>"+"<td style=\"width:33%\">"+award.Amount+"</td>"+"<td style=\"width:33%\">"+award.Seq+"</td>"+"</tr>";
                a += x;
            })
            $("#Weektr").html(a);
            var ranktype = 1;
            goPage(index,15,ranktype);

        }
    });
};
//月排行榜查询
function MonthQuery(){
    $.ajax({
        url:'/ranking/query',
        dataType:'json',
        cache: false,
        data :{
            gameid : $("#gameid").val(),
            rankingType : 1,
            period : $("#Monthperiod").val()
        },
        type:'Get',
        success:function(data){
            var a ="";
            var index=1;
            $.each(data.list,function(i,award){
                x = "<tr>"+"<td style=\"width:33%\">"+award.Account+"</td>"+"<td style=\"width:33%\">"+award.Amount+"</td>"+"<td style=\"width:33%\">"+award.Seq+"</td>"+"</tr>";
                a += x;
            })
            $("#Monthtr").html(a);
            var ranktype = 2;
            goPage(index,15,ranktype);

        }
    });
};
//幸运榜查询
function luckyQuery(){
    $.ajax({
        url:'/ranking/query',
        dataType:'json',
        cache: false,
        data :{
            gameid : $("#gameid").val(),
            rankingType : 2,
            period : $("#luckyperiod").val()
        },
        type:'Get',
        success:function(data){
            var a ="";
            var index=1
            $.each(data.list,function(i,award){
                x = "<tr>"+"<td style=\"width:33%\">"+award.Account+"</td>"+"<td style=\"width:33%\">"+award.Amount+"</td>"+"<td style=\"width:33%\">"+award.Seq+"</td>"+"</tr>";
                a += x
            })
            $("#luckytr").html(a);
            ranktype=3;
            goPage(1,15,ranktype);
        },


    });
};
function goPage(pno, psize,ranktype)
{
    var idtype = "";
    var pagetable="";
    switch (ranktype)
    {
        case 1:
            idtype ="Weektr";
            pagetable="barcon1";
            break;
        case 2:
            idtype="Monthtr";
            pagetable="barcon2";
            break;
        case 3:
            idtype ="luckytr";
            pagetable="barcon3";
            break;

    };
    var itable = document.getElementById(idtype);//通过ID找到表格
    var num = itable.rows.length;//表格所有行数(所有记录数)
    var totalPage = 0;//总页数
    var pageSize = psize;//每页显示行数
    var rank = ranktype;
    //总共分几页
    if (num / pageSize > parseInt(num / pageSize)) {
        totalPage = parseInt(num / pageSize) + 1;
    } else {
        totalPage = parseInt(num / pageSize);
    }
    var currentPage = pno;//当前页数
    var startRow = (currentPage - 1) * pageSize + 1;//开始显示的行  1
    var endRow = currentPage * pageSize;//结束显示的行   15
    endRow = (endRow > num) ? num : endRow;
    //遍历显示数据实现分页
    for (var i = 1; i < (num + 1); i++) {
        var irow = itable.rows[i - 1];
        if (i >= startRow && i <= endRow) {
            irow.style.display = "";
        } else {
            irow.style.display = "none";
        }
    }
    var tempStr = "";
    if (currentPage > 1) {
        var end  = currentPage+10;
        var sub  = totalPage - end;
        if (sub <=10){
            end  = totalPage
        }
        tempStr += "<a href=\"#main\" onClick=\"goPage(" + (currentPage - 1) + "," + psize + "," + rank + ")\"><上页&nbsp;&nbsp;</a>";

        for (var j = currentPage; j <= end; j++) {
            if (j==currentPage){
                tempStr += "<a href=\"#main\" class=\"key\"  onClick=\"goPage(" + j + "," + psize + "," + rank + ")\">&nbsp;" + j + "&nbsp;&nbsp;</a>"}
            else{
                tempStr += "<a href=\"#main\"  onClick=\"goPage(" + j + "," + psize + "," + rank + ")\">" + j + "&nbsp;&nbsp;</a>"
            }
        }
    } else {
        tempStr += "<上页&nbsp;&nbsp;";
        for (var j = 1; j <= 10; j++) {
            tempStr += "<a href=\"#main\"  onClick=\"goPage(" + j + "," + psize + "," + rank + ")\">" + j + "&nbsp;&nbsp;</a>"
        }
    }
    if (currentPage < totalPage) {
        tempStr += "<a href=\"#main\" onClick=\"goPage(" + (currentPage + 1) + "," + psize + "," + rank + ")\">下页></a>";
        for (var j = 1; j <= totalPage; j++) {
        }
    } else {
        tempStr += "  下页>";
        for (var j = 1; j <= totalPage; j++) {
        }
    }
    document.getElementById(pagetable).innerHTML = tempStr;
}






