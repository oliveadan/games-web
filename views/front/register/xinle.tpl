<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="renderer" content="webkit">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
    <meta content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <title>注册-{{.siteName}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <link type="text/css" rel="stylesheet" href="{{static_front}}/static/front/register/css/register.css">

    <script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
    <script type="text/javascript" src="{{static_front}}/static/front/register/js/vali.min.js"></script>
</head>
<body>
<div class="body">
    <div class="top-space"></div>
    <div class="vli">
        <div class="wrapper move">
            <div id="register">
                <form class="form2" method="post">
                {{ .xsrfdata }}
                    <h3>免费注册</h3>
                    <div class="vali">
                        <label>邀请码</label>
                        <input type="text" name="Upline" value="" class="Required">
                    </div>
                    <div class="vali">
                        <label>用户名</label>
                        <input type="text" name="Account" value="" class="username" placeholder="6~12个字符，只能使用小写字母和数字">
                    </div>
                    <div class="vali">
                        <label>密码</label>
                        <input type="password" name="Password" value="" placeholder="6~16个字符，仅能使用字母与数字" class="pasw">
                    </div>
                    <div class="vali">
                        <label>手机号码</label>
                        <input type="text" name="Mobile" value="" placeholder="请输入11位手机号" class="phone">
                    </div>
                    <div class="marb0">
                        <div class="vali pho">
                            <input type="text" name="captcha" value="" placeholder="请输入验证码" class="Required">
                        </div>
                        <div class="pcd">
                        {{create_captcha}}
                        </div>
                        <div class="cl1"></div>
                    </div>
                    <div>
                        <div class="checkbox">
                            <input type="checkbox" id="agree" value="1" name="agree" class="agree" checked>
                        </div>
                        <div class="label">
                            <label>我已年满18周岁，且已阅读、接受并同意有关年龄验证和KYC（身份验证过程）的条款与规则、规则 、 隐私政策, PAGE_REGISTER_CookiesJC 及其他政策</label>
                        </div>
                    </div>
                    <div class="submit">
                        <input type="submit" class="btn" value="立即注册">
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script type="text/javascript">
    $.myvali({
        myform:".form2",
        mybtn:".btn",
        myVali:".vali",

        Required:".Required",
        RequiredTps:["不能为空!"],

        Requireds:".Requireds",
        reqtps:".reqtps",
        Reqlength:[[2,4]],

        myName:".username",
        myName2:".fullname",

        myPassword:".pasw",

        myPhone:".phone",
        isPhoneCode:false,
        phoneCodeInput:".phcode",

        PwdStrong:true,
        isStrongTps:["弱","中","强"],
    });
</script>
</body>
</html>
