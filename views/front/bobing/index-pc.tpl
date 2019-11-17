<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
	<title>{{.siteName}}-{{.gameDesc}}</title>
	<link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/bobing/css/commstyle.css"/>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/bobing/css/style.css"/>
</head>
<body>
<input type="hidden" id="GameId" value="{{.gameId}}" >
<section class="index-wrap">

    <section style="text-align: center;padding-top: 2rem;height: 4.49rem;">
        <div class="bb-wan" id="vessel">
            <div style="position:absolute; left: 50%; top: 50%; width: 1px; height: 1px">
                <img class="sezi sz1 png" src="{{static_front}}/static/front/bobing/images/1.png">
                <img class="sezi sz2 png" src="{{static_front}}/static/front/bobing/images/2.png">
                <img class="sezi sz3 png" src="{{static_front}}/static/front/bobing/images/3.png">
                <img class="sezi sz4 png" src="{{static_front}}/static/front/bobing/images/4.png">
                <img class="sezi sz5 png" src="{{static_front}}/static/front/bobing/images/5.png">
                <img class="sezi sz6 png" src="{{static_front}}/static/front/bobing/images/6.png">
                <img class="sezi sz1 gif" src="{{static_front}}/static/front/bobing/images/0.gif">
                <img class="sezi sz2 gif" src="{{static_front}}/static/front/bobing/images/0.gif">
                <img class="sezi sz3 gif" src="{{static_front}}/static/front/bobing/images/0.gif">
                <img class="sezi sz4 gif" src="{{static_front}}/static/front/bobing/images/0.gif">
                <img class="sezi sz5 gif" src="{{static_front}}/static/front/bobing/images/0.gif">
                <img class="sezi sz6 gif" src="{{static_front}}/static/front/bobing/images/0.gif">
            </div>
        </div>
    </section>
    <section class="tc">
        <a href="javascript:;" class="b-btn b-btn-icon" id="btn-shake">搏一把</a>
    </section>
    <div class="wininfobg">
        <div class="wininfo">
            <ul>
            {{range $i, $v := .rlList}}
                <li><span class="spa1">恭喜会员<em>{{$v.account}}</em></span><span>博出<i>{{$v.gift}}</i></span></li>
            {{end}}
            </ul>
        </div>
    </div>
    <div class="content">
        <div class="title">活动详情</div>
        {{str2html .gameRule}}
    </div>
</section>
<script src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script src="{{static_front}}/static/front/layer-v3.1.1/mobile/layer.js"></script>
<script src="{{static_front}}/static/front/bobing/js/script.js"></script>
<script src="{{static_front}}/static/front/bobing/js/base.js"></script>
<script src="{{static_front}}/static/front/bobing/js/shake.js"></script>
<script>
    $(function(){
        var phage = new Phage({
            gid: parseInt({{.gameId}}),
            account: '{{.account}}',
            status: parseInt({{.gameStatus}}),
            msg: '{{.gameMsg}}',
            gameRule: '{{.gameRule}}',
            regist:'{{.officialRegist}}',
            rechargeSite:'{{.rechargeSite}}'
        });
        phage.start(function () {});

        var isRun = false;
        var $vessel = $("#vessel");
        function shake() {
            isRun = true;
            $vessel.addClass('shake');
            var time1= new Date().getTime();
            phage.ajaxSend({
                url: '{{urlfor "BobingFrontController.Post"}}',
				data: {account: phage.ops.account, gid: parseInt({{.gameId}})},
                success: function(info) {
                    if(info.code != 0) {
                        var time2= new Date().getTime();
                        if(time2-time1<1200){
                            setTimeout(function(){
                                updateInfo(info);
                            },1200-(time2-time1));
                        }else{
                            updateInfo(info);
                        }
                    }else{
                        isRun = false;
                        $vessel.removeClass('shake');
                        layer.open({
                            type: 1,
                            time: 2,
                            skin: 'msg',
                            content: info.msg || '请重试'
                        });
                    }
                }
            })
        }
        function updateInfo(info) {
            var data = info.data;
            var betNumber = String(data.seq).split('');
            $vessel.removeClass('shake');
            $vessel.find("img.png").each(function(i) {
                $(this).attr('src', '{{static_front}}/static/front/bobing/images/' + betNumber[i] + '.png');
            });
            setTimeout(function(){
                isRun = false;
                phage.openPlayResult(info);
            },1000);
        }
        var myShakeEvent = new Shake({
            threshold: 15,
            timeout: 1200
        });
        myShakeEvent.start();
        $(window).on('shake', function() {
            if (!isRun && !$vessel.hasClass('shake')) {
                shake();
            }
        });
        $("#btn-shake").on("click", function(e){
            e.preventDefault();
            if (!isRun && !$vessel.hasClass('shake')) {
                shake();
            }
        });
    });

    function autoScroll(obj){
        $(obj).find("ul").animate({
            marginTop : "-0.5rem"
        },500,function(){
            $(this).css({marginTop : "0rem"}).find("li:first").appendTo(this);
        })
    }
    $(function(){
        setInterval('autoScroll(".wininfo")',3000);
    })
</script>
</body>
</html>
