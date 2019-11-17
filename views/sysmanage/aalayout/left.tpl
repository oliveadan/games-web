<div class="layui-side layui-bg-black">
    <div class="layui-side-scroll">
        <ul class="layui-nav layui-nav-tree">
            <li class="layui-nav-item layui-nav-title"><a>管理菜单</a></li>
            <li class="layui-nav-item">
                <a href='{{urlfor "SysIndexController.Get"}}'><i class="layui-icon">&#xe68e;</i> 系统信息</a>
            </li>
            {{range $index, $vo := .mainMenuList}}
            <li class="layui-nav-item">
                <a href="javascript:;"><i class="layui-icon">&{{$vo.Icon}}</i> {{$vo.Name}}</a>
                <dl class="layui-nav-child">
                    {{range $i, $menu := map_get $.secdMenuMap $vo.Id}}
                    <dd><a href='{{urlfor $menu.Url}}'> {{$menu.Name}}</a></dd>
                    {{end}}
                </dl>
            </li>
            {{end}}
            <li class="layui-nav-item" style="height: 30px; text-align: center"></li>
        </ul>
    </div>
</div>