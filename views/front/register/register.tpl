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
                        <label>用户名</label>
                        <input type="text" name="Account" value="" class="username" placeholder="6~12个字符，只能使用小写字母和数字">
                    </div>
                    <div class="vali">
                        <label>密码</label>
                        <input type="password" name="Password" value="" placeholder="6~16个字符，仅能使用字母与数字" class="pasw">
                    </div>
                    <div class="vali">
                        <label>确认密码</label>
                        <input type="password" name="RePassword" value="" placeholder="请再次输入密码" id="password" class="pasws">
                    </div>
                    <div class="vali">
                        <label>中文全名</label>
                        <input type="text" name="RealName" value="" placeholder="必须与您的银行帐户名称相同，否则不能出款！" class="fullname">
                    </div>
                    <div class="vali">
                        <label>手机号码</label>
                        <input type="text" name="Mobile" value="" placeholder="请输入11位手机号" class="phone">
                    </div>
                    <div class="vali">
                        <label>微信号</label>
                        <input type="text" name="WxNo" value="" placeholder="请输入微信号" class="Required">
                    </div>
                    <div class="vali">
                        <label>取款密码</label>
                        <input type="password" name="WithdrawPass" value="" placeholder="提款认证必须，请务必牢记！" class="Required">
                    </div>
                    <div class="vali">
                        <label>提示问题</label>
                        <select name="Question" class="Required">
                            <option value="">请选择</option>
                            <option value="您的车牌号码">您的车牌号码</option>
                            <option value="您所在的城市">您所在的城市</option>
                            <option value="您的生日">您的生日</option>
                            <option value="您的名字">您的名字</option>
                            <option value="您父亲的名字">您父亲的名字</option>
                            <option value="您母亲的名字">您母亲的名字</option>
                            <option value="您儿女的名字">您儿女的名字</option>
                            <option value="您妻子的名字">您妻子的名字</option>
                            <option value="您喜欢的数字">您喜欢的数字</option>
                            <option value="您喜欢的品牌">您喜欢的品牌</option>
                            <option value="您喜欢的运动">您喜欢的运动</option>
                            <option value="您喜欢的颜色">您喜欢的颜色</option>
                            <option value="您喜欢的球队">您喜欢的球队</option>
                            <option value="您喜欢的球星">您喜欢的球星</option>
                        </select>
                    </div>
                    <div class="vali">
                        <label>提示答案</label>
                        <input type="text" name="Answer" value="" placeholder="请输入提示问题的答案，请务必牢记！" class="Required">
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
        myform:".form2",								//表单id
        mybtn:".btn",									//提交表单按钮id
        myVali:".vali",									//input父盒子的class，可自定义类名

        Required:".Required",							//验证必填选项，值为Required,input自己加class
        RequiredTps:["不能为空!"],					//只验证不为空提示

        Requireds:".Requireds",							//验证必填不同提示，值为Requireds,input自己加class
        reqtps:".reqtps",								//验证不为空不同提示,input父盒子的class,可自定义类名
        Reqlength:[[2,4]],								//只验证不为空,设置最小长度和最大长度

        myName:".username",								//用户名id或class
        myName2:".fullname",								//昵称id或class

        myPassword:".pasw",								//密码id或class
        myConfirmPassword:".pasws",						//确认密码id或class
        myqkmm : ".qkmm",

        myPhone:".phone",								//手机号id或class

        isPhoneCode:false,								//开启手机短信验证，true开启，默认false不开启(此项功能与myPhone配合验证)

        phoneCodeInput:".phcode",						//短信验证码id或class（输入框）

        myMailbox:".eal",								//邮箱id或class

        PwdStrong:true,								//密码强度验证，默认false不开启，true开启
        isStrongTps:["弱","中","强"],				//密码强度提示，可自定义提示
    });
</script>
</body>
</html>
