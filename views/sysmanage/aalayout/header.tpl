<div class="layui-header header">
    <div class="logo">
        <span><strong>{{.siteName}}</strong> 后台管理系统</span>
    </div>
    <!--<img class="logo" src="__STATIC__/images/admin_logo.png" alt="">-->
    <ul class="layui-nav" style="position: absolute;top: 0;right: 20px;background: none;">
        <!--<li class="layui-nav-item"><a href="{:url('/')}" target="_blank">前台首页</a></li>-->
        <!--<li class="layui-nav-item"><a href="" data-url="{:url('admin/system/clear')}" id="clear-cache">清除缓存</a></li>-->
        <li class="layui-nav-item">
            <a href="javascript:;">{{.loginAdminName}}</a>
            <dl class="layui-nav-child"> <!-- 二级菜单 -->
                <dd><a href='{{urlfor "ChangePwdController.get"}}'>修改密码</a></dd>
                <dd><a href='{{urlfor "LoginController.Logout"}}'>退出登录</a></dd>
            </dl>
        </li>
    </ul>
</div>