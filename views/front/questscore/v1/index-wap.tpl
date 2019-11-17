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
		<script type="text/javascript" src="{{static_front}}/static/front/questscore/wap/js/respond.min.js"></script>
        <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/questscore/wap/css/page_survey.css">
        <link rel="stylesheet" type="text/css" href="{{static_front}}/static/front/questscore/wap/css/theme.css">
		<style>
		.error {
			color:red;
		}
		form.questForm label.error {
			display: none;
		}
		</style>
	</head>
    <body class="g_wrapper page_survey g_survey">
        <div id="container" class="g_container">
            <div class="headerseat"></div>
			<div class="header" id="header">
			    <a href="{{urlfor "QuestApiController.Get"}}" class="logo"></a>
			</div>
            <div class="g_content">
                <div class="survey_wrap">
                    <div class="survey_main">
                        <h1 class="survey_title" style="display: block;">
                            <div class="inner">
                                <div class="title_content">
                                    <p>{{.gameDesc}}</p>
                                </div>
                            </div>
                        </h1>
                        <div class="survey_content">
                            <div class="survey_prefix" style="display: block;">
                                <div class="inner">
                                    <h2 class="prefix_content">
                                        <p>{{.announcement}}</p>
                                    </h2>
                                </div>
                            </div>
							<form class="questForm" id="questForm" action='{{urlfor "QuestscoreApiController.Post"}}' method="post">
                            {{ .xsrfdata }}
							<input type="hidden" name="gid" value="{{.gameId}}">
							<div class="survey_container">
                                <div class="survey_page">
								{{range $i, $v := .questList}}
									{{if eq $v.ContentType 1}}
									<div class="question question_radio" id="question_{{$v.Id}}" style="display: block;">
                                        <div class="inner">
                                            <div class="title">
                                                <div role="presetation">
                                                    <span class="title_index">
                                                        <span class="question_index"></span></span>
                                                    <h3 class="title_text">
                                                        <p>{{$v.Content}}</p>
                                                    </h3>
                                                </div>
                                                <span class="tips" role="alert"></span>
                                            </div>
                                            <div class="inputs">
												{{range $j, $v2 := $.questList}}
													{{if eq $v2.Pid $v.Id}}
                                                <div class="option_item" style="width: 100%;">
                                                    <input class="survey_form_checkbox" type="radio" name="option-{{$v2.Pid}}" id="{{$v2.Id}}" value="{{$v2.Id}}" required title="必选" />
                                                    <label for="{{$v2.Id}}">
                                                        <i class="survey_form_ui"></i>
                                                        <span class="option_text">{{$v2.Content}}</span></label>
                                                </div>
													{{end}}
												{{end}}
                                            </div>
											<label for="option-{{$v.Id}}" class="error">必选</label>
                                        </div>
                                    </div>
									{{else if eq $v.ContentType 2}}
									<div class="question question_checkbox {{if eq $v.Required 1}}required{{end}}" id="question_{{$v.Id}}" style="display: block;">
                                        <div class="inner">
                                            <div class="title">
                                                <div>
                                                    <span class="title_index"><span class="question_index">{{$v.Seq}}</span>、</span>
                                                    <h3 class="title_text">
                                                        <p>{{$v.Content}}
                                                            <span style="color:#53aaf3;margin-left:3px;">[多选题]</span>
														</p>
                                                    </h3>
												</div>
                                            </div>
                                            <div class="inputs">
												{{range $j, $v2 := $.questList}}
													{{if eq $v2.Pid $v.Id}}
                                                <div class="option_item" style="width: 100%;">
                                                    <input class="survey_form_checkbox" type="checkbox" name="option-{{$v2.Pid}}" id="{{$v2.Id}}" value="{{$v2.Id}}" {{if eq $v.Required 1}}required  title="必选"{{end}} />
                                                    <label for="{{$v2.Id}}">
                                                        <i class="survey_form_ui"></i>
                                                        <span class="option_text">{{$v2.Content}}</span>
													</label>
                                                </div>
													{{end}}
												{{end}}
                                            </div>
											<label for="option-{{$v.Id}}" class="error">必选</label>
                                        </div>
                                    </div>
									{{else if eq $v.ContentType 3}}
									<div class="question question_text {{if eq $v.Required 1}}required{{end}}" id="question_{{$v.Id}}" style="display: block;">
                                        <div class="inner">
                                            <div class="title">
                                                <div>
                                                    <span class="title_index"><span class="question_index">{{$v.Seq}}</span>、</span>
                                                    <h3 class="title_text">
                                                        <p>{{$v.Content}}</p>
                                                    </h3>
												</div>
                                            </div>
                                            <div class="inputs">
												<input type="text" name="{{$v.Id}}" {{if eq $v.Required 1}}required title="必填"{{end}}>
                                            </div>
                                        </div>
                                    </div>
									{{else if eq $v.ContentType 4}}
									<div class="question question_textarea {{if eq $v.Required 1}}required{{end}}" id="question_{{$v.Id}}" style="display: block;">
                                        <div class="inner">
                                            <div class="title">
                                                <div>
                                                    <span class="title_index"><span class="question_index">{{$v.Seq}}</span>、</span>
                                                    <h3 class="title_text">
                                                        <p>{{$v.Content}}</p>
                                                    </h3>
												</div>
                                            </div>
                                            <div class="inputs">
												<textarea class="survey_form_input" name="{{$v.Id}}" {{if eq $v.Required 1}}required title="必填"{{end}} rows="5" cols="60"></textarea>
                                            </div>
                                        </div>
                                    </div>
									{{end}}
								{{end}}
                                </div>
                            </div>
							<div class="inner">
								<span id="tips-span" class="error" style="display:none;">验证失败，请检查是否填写完整</span>
                            </div>
							<div class="survey_control">
                                <div class="inner">
									{{if gt (.questList|len) 0}}
                                    <input type="submit" class="survey_btn survey_submit" value="提交" style="display: inline-block;border:0;">
									{{else}}
									<div class="no_quest_tips">
										目前没有进行中的问卷<br>
										请前往 <a href="{{.officialSite}}">{{.siteName}}官网</a> 查看更多优惠活动
									</div>
									{{end}}
								</div>
                            </div>
							</form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer">
            <div class="copyright">©2016-{{date .nowdt "Y"}} {{.siteName}}. All rights reserved.</div></div>
        </div>
		
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.min.js"></script>
<script type="text/javascript" src="{{static_front}}/static/front/js/jquery.validate.min.js"></script>
<script>
$(document).ready(function() {
	$("#questForm").validate({
		invalidHandler:function(form){       
        	$("#tips-span").fadeIn();
			setTimeout(function(){
				$("#tips-span").fadeOut();
			},5000);
		}
	});
});
</script>
    </body>
</html>