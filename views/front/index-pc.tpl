<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="keywords" content="">
    <title>活动中心</title>
    <link rel="shortcut icon" href="/static/img/favicon.ico" type="image/x-icon">
    <link href="/static/front/index/css/style.css" type="text/css" rel="stylesheet" media="all">
    <link href="/static/front/index/css/animate.css" rel="stylesheet" type="text/css" media="all">
</head>
<body>

<div id="home" class="banner">
    <div class="container">
        <div class="header-info">
            <a href="{{.officialSite}}">
                <div class="logo">
                </div>
                <h1 class="logo-head">活动中心</h1>
            </a>
            <div class="header-info-right">
                <div class=" top-nav">
                    <ul class="nav1">
                        <li><a href="{{.officialSite}}" target="_black"><p>官网首页</p><span>Home</span></a></li>
                        <li><a href="{{or .officialRegist .officialSite}}" target="_black"><p>马上注册</p>
                            <span>Register</span></a></li>
                        <li><a href="{{or .rechargeSite .officialSite}}" target="_black"><p>充值中心</p>
                            <span>Recharge</span></a></li>
                        <li><a href="{{or .custServ .officialSite}}" target="_black"><p>在线客服</p><span>Service</span></a>
                        </li>
                    </ul>
                </div>
            </div>
            <div class="clearfix"></div>
        </div>
        <div class="bnr-img animated wow fadeInDown animated" data-wow-duration="2000ms"
             style="visibility: visible; animation-duration: 2000ms; animation-name: fadeInDown;">
            <img src="/static/front/index/images/gg.png" alt="">
        </div>
    </div>
    <div class="ban_botm"></div>
</div>

<div class="class">
    <div class="container">
        <div class="class-top heading">
            <h3></h3>
        </div>
        <div class="class-bottom">
            {{range $i,$v := .list}}
            {{if eq $v.Enabled 1}}
            {{if lt (date $.nowdt "Y-m-d H:i:s") (date $v.EndTime "Y-m-d H:i:s")}}
                <a href="/{{$v.GameType}}?gid={{$v.Id}}">
                    <div class="col-md-4 class-left animated wow fadeInLeft" data-wow-duration="1000ms">
                        <figure>
                            <img src="/static/front/index/images/logo-{{$v.GameType}}.jpg" alt="" class="img_responsive">
                        </figure>
                        <h6>{{date $v.StartTime "Y/m/d"}} - {{date $v.EndTime "Y/m/d"}}</h6>
                        <div class="c-btm">
                            <h4>{{$v.Name}}</h4>
                            <p> {{substr  $v.Announcement 0 40}}{{if gt ($v.Announcement|len) 40}}...{{end}}</p>
                        </div>
                    </div>
                </a>
            {{end}}
            {{end}}
            {{end}}
            <div class="clearfix"></div>
        </div>
    </div>
</div>
<div class="features">
    <div class="container">
        <div class="features-top heading1">
            <h3>往期活动</h3>
        </div>
        <div class="features-bottom">
            {{range $i,$v := .list}}
            {{if eq $v.Enabled 0}}
            {{if gt (date $.nowdt "Y-m-d H:i:s") (date $v.EndTime "Y-m-d H:i:s")}}
                <div class="col-md-4 feature-left animated wow fadeInRight" data-wow-duration="1000ms">
                    <div class="feature-one">
                        <h4 class="">{{$v.Name}}</h4>
                        <p>{{substr  $v.Announcement 0 40}}{{if gt ($v.Announcement|len) 40}}...{{end}}</p>
                        <p>{{date $v.StartTime "Y/m/d"}} - {{date $v.EndTime "Y/m/d"}}</p>
                    </div>
                </div>
            {{end}}
            {{end}}
            {{end}}
            <div class="clearfix"></div>
        </div>
    </div>
</div>


<div class="footer animated wow fadeInDown animated" data-wow-duration="1000ms"
     style="visibility: visible; animation-duration: 1000ms; animation-name: fadeInDown;">
    <div class="container">
        <div class="footer-top">
            <p>Copyright &copy;{{date .nowdt "Y"}} {{.siteName}} All rights reserved.</p>
        </div>
    </div>
</div>

<script src="/static/front/index/js/wow.min.js"></script>
<script>
    new WOW().init();

</script>

</body>
</html>