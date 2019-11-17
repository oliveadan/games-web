<!DOCTYPE html>

<html>
<head>
  <title>跳转提示</title>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>
{{if eq .isWap true}}
	<div style="width: 100%; height: 280px; background:url(./static/front/img/s1.png) no-repeat; background-size: 100% 100%;"></div>
	<div style="width: 100%; height: 800px; background:url(./static/front/img/s2.png) no-repeat; background-size: 100% 100%;"></div>
{{else}}
	<div style="width: 750px; height: 480px; background:url(./static/front/img/p1.png) no-repeat; background-size: 100% 100%;"></div>
{{end}}
</body>
</html>
