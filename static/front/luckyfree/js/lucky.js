

function showLogin() {
    $('#window-login').show();
}
function login() {
    if ($('#username').val() == '') {
        layer.msg('请输入账号！');
        return false;
    }
    username = $('#username').val();
    ggid = $('#gid').val();
    $.ajax({
        type: 'POST',
        url: '/login',
        dataType: 'json',
        data: {
            account: username,
            gid: ggid,
        },
        success: function (data) {
            if (data.code != 1) {
                //swal('', data.msg, 'error');
                layer.msg(data.msg)
            } else {
                localStorage.username = username;
                $('.btn-choujiang').html('-1抽奖次数');
                var str = "";
                str = '您还有'+'<span class="huang">'+data.data.lotteryNums+'</span>'+'次抽奖机会'+'</br>';
                var exit = "";
                exit = '<a href="javascript:(0);" onclick="exit()">'+'退出'+'</a>';
                $("#login-status").html(str+exit);
                closeLogin();
            }
        }
    });
}
function exit() {
    $.ajax({
        url: '/logout',
        dataType: 'json',
        cache: false,
        type: 'GET',
        success: function (obj) {
            localStorage.clear();
            window.location.reload();
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            var x = 1;
        }
    })
};
function closeLogin() {
    $('#window-login').hide();
}
function showQuery() {
    $('#window-query').show();
}
function closeQuery() {
    $('#window-query').hide();
}
function query() {
    var username = $('#query-username').val();
    if (!username) {
        alert('请输入会员账号！');
        return false;
    }
    queryPage(1);
}

var lottery={
    index:-1,    //当前转动到哪个位置，起点位置
    count:0,    //总共有多少个位置
    timer:0,    //setTimeout的ID，用clearTimeout清除
    speed:20,    //初始转动速度
    times:0,    //转动次数
    cycle:50,    //转动基本次数：即至少需要转动多少次再进入抽奖环节
    prize:-1,    //中奖位置
    init:function(id){
        if ($("#"+id).find(".lottery-unit").length>0) {
            $lottery = $("#"+id);
            $units = $lottery.find(".lottery-unit");
            this.obj = $lottery;
            this.count = $units.length;
            $lottery.find(".lottery-unit-"+this.index).addClass("active");
        };
    },
    roll:function(){
        var index = this.index;
        var count = this.count;
        var lottery = this.obj;
        $(lottery).find(".lottery-unit-"+index).removeClass("active");
        index += 1;
        if (index>count-1) {
            index = 0;
        };
        $(lottery).find(".lottery-unit-"+index).addClass("active");
        this.index=index;
        return false;
    },
    stop:function(index){
        this.prize=index;
        return false;
    }
};

function roll(){
    lottery.times += 1;
    lottery.roll();//转动过程调用的是lottery的roll方法，这里是第一次调用初始化
    if (lottery.times > lottery.cycle+10 && lottery.prize==lottery.index) {
        clearTimeout(lottery.timer);
        lottery.prize=-1;
        lottery.times=0;
        click=false;
        layer.alert(attainPrize,{title:"恭喜您抽中了",icon:6});
    }else{
        if (lottery.times<lottery.cycle) {
            lottery.speed -= 10;
        }else if(lottery.times==lottery.cycle) {
            //var index = Math.random()*(lottery.count)|0;//中奖物品通过一个随机数生成
            //lottery.prize = index;
        }else{
            if (lottery.times > lottery.cycle+10 && ((lottery.prize==0 && lottery.index==7) || lottery.prize==lottery.index+1)) {
                lottery.speed += 110;
            }else{
                lottery.speed += 20;
            }
        }
        if (lottery.speed<40) {
            lottery.speed=40;
        };
        //console.log(lottery.times+'^^^^^^'+lottery.speed+'^^^^^^^'+lottery.prize);
        lottery.timer = setTimeout(roll,lottery.speed);//循环调用
    }
    return false;
}
var click=false;
var attainPrize = null; // 抽中的奖品
// 通知中奖结果

// 加载奖品
lottery.init('lottery');
$("#lottery .btn-choujiang").click(function(){
    username3 = localStorage.getItem("username");
    ggid = $("#gid").val();
    if (username3 == null) {
        showLogin();
        return false;
    }
    if (click) {//click控制一次抽奖过程中不能重复点击抽奖按钮，后面的点击不响应
        return false;
    }else{
        $.ajax({
            url: '/frontshare/lottery',
            method: 'post',
            data:{account:username3,gid:ggid},
            success: function (resp) {
                if (resp.code == 1) {
                    attainPrize = resp.data.gift;
                    switch (resp.data.seq){
                        case "1":
                            lottery.prize = 0;
                            break;
                        case "2":
                            lottery.prize = 1;
                            break;
                        case "3":
                            lottery.prize = 2;
                            break;
                        case "4":
                            lottery.prize = 3;
                            break;
                        case "5":
                            lottery.prize = 9;
                            break;
                        case "7":
                            lottery.prize = 4;
                            break;
                        case "8":
                            lottery.prize = 8;
                            break;
                        case "9":
                            lottery.prize = 7;
                            break;
                        case "10":
                            lottery.prize = 6;
                            break;
                        case "11":
                            lottery.prize = 5;
                    }
                    lottery.speed=500;
                    $('.huang').html($('.huang').text() - 1);
                    roll();    //转圈过程不响应click事件，会将click置为false
                    click=true; //一次抽奖完成后，设置click为true，可继续抽奖
                }else {
                    layer.msg(resp.msg);
                }

            }
        });
        return false;
    }
});


var pagesize = 5;
function queryPage(page) {
    $.ajax({
        url: '/frontshare/lotteryquery',
        dataType: 'json',
        cache: false,
        data: {
            gid: $("#gid").val(),
            account: $('#query-username').val(),
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
                    $("#query-result").html(sHtml1);
                } else {
                    $("#query-result").html("<tr><td colspan='3'>没有中奖记录</td></tr>");
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


/*查询的分布显示*/
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
};


