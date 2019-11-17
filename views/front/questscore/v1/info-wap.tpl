<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <meta name="renderer" content="webkit">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta name="format-detection" content="telephone=no">
    <title>{{.siteName}}-{{.gameDesc}}</title>
    <link rel="shortcut icon" href="{{static_front}}/static/img/favicon.ico" type="image/x-icon">
    <script type="text/javascript" src="{{static_front}}/static/front/questscore/wap/js/respond.min.js"></script>
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/questscore/wap/css/page_survey.css">
    <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/questscore/wap/css/theme.css">
</head>

<body class="g_wrapper page_survey g_survey">
<div id="container" class="g_container">
    <div class="headerseat"></div>
    <div class="header" id="header">
        <a href="{{urlfor "QuestscoreApiController.Get"}}" class="logo"></a>
    </div>
    <div class="g_content">
        <div class="survey_wrap">
            <div class="survey_main" style="padding-bottom: 0px;">
                <div class="survey_content">

                    <div class="survey_suffix" style="">
                        <div class="inner">
                            <div class="suffix_content info">
                                {{if eq .code 1}}
                                <p style="color:#ff60e9">正确答案</p>
                                {{range $i,$v := .right}}
                                    <p>{{index $v 0}}</p>
                                    <p style="color: red">{{index $v 1}}</p>
                                {{end}}
                                <p>
                                    <img src="{{static_front}}/static/front/questscore/images/end.png">
                                    {{else}}
                                        <img src="{{static_front}}/static/front/questscore/images/failure.png">
                                    {{end}}
                                </p>
                                <p>&nbsp;</p>
                                <p>{{.msg}}</p>
                            </div>
                        </div>
                    </div>
                    <div class="survey_ads" style="display: block;">
                        <a target="_blank" href="{{.officialSite}}">
                            <img class="pc"
                                 src="{{static_front}}/static/front/questscore/images/survey_banner_ad_pc.png"></a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>