<!DOCTYPE html>
<html lang="zh-cn">
    <head>
        <meta charset="utf-8">
        <meta http-equiv="x-ua-compatible" content="ie=edge">
        <meta name="renderer" content="webkit">
        <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
        <meta name="format-detection" content="telephone=no">
        <title>{{.siteName}}-{{.gameDesc}}</title>
        <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
        <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/quest/css/page_survey.css">
        <link id="theme_css" rel="stylesheet" type="text/css" href="{{static_front}}/static/front/quest/css/theme.css"></head>
    
    <body class="g_wrapper page_survey g_survey">
        <div id="container" class="g_container">
            <div class="header">
                <div class="headercon w1000">
                    <a class="logo" href='{{urlfor "QuestApiController.Get"}}'></a>
                    <div class="menu">
                        <ul>
                            <li>
                                <a target="_blank" href="{{.officialSite}}">
                                    <i class="i1"></i>
                                    <p>官方首页</p>
                                </a>
                            </li>
                            <!-- <li><a href="javascript:;" onclick="document.getElementById('light').style.display='block'; document.getElementById('fade').style.display='block'"><i class="i8"></i>
                            <p>中奖查询</p>
                            </a></li> -->
                            <li>
                                <a target="_blank" href="{{.officialRegist}}">
                                    <i class="i5"></i>
                                    <p>免费注册</p>
                                </a>
                            </li>
                            <li class="last">
                                <a target="_blank" href="{{.custServ}}">
                                    <i class="i6"></i>
                                    <p>在线客服</p>
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="g_content">
                <div class="survey_wrap">
                    <div class="survey_main" style="padding-bottom: 0px;">
                        <div class="survey_content">
                            
                            <div class="survey_suffix" style="">
                                <div class="inner">
                                    <div class="suffix_content">
                                        <p>
										{{if eq .code 1}}
                                            <img src="{{static_front}}/static/front/quest/images/end.png">
										{{else}}
											<img src="{{static_front}}/static/front/quest/images/failure.png">
										{{end}}
										</p>
                                        <p>&nbsp;</p>
                                        <p>{{.msg}}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="survey_ads" style="display: block;">
                                <a target="_blank" href="{{.officialSite}}">
                                    <img class="pc" src="{{static_front}}/static/front/quest/images/survey_banner_ad_pc.png"></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>