<script src="/static/js/jquery.min.js"></script>
<script src="/static/layui/layui.all.js"></script>
<script src="/static/js/admin.js"></script>
<script>
/**
 * 后台侧边菜单选中状态
 */
$('.layui-nav-item').find('a').removeClass('layui-this');
$('.layui-nav-tree').find('a[href*="' + {{.currentUrl}} + '"]').parent().addClass('layui-this').parents('.layui-nav-item').addClass('layui-nav-itemed');
</script>