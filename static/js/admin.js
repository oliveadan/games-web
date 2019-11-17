/**
 * 后台JS主入口
 */
layui.use(['layer','element','form','upload'], function(){
    var layer = layui.layer,
        element = layui.element,
        form = layui.form;
	var upload = layui.upload;
	
    /**
     * AJAX全局设置
     */
    $.ajaxSetup({
        type: "post",
        dataType: "json"
    });

    /**
     * 通用表单提交(AJAX方式)
     */
    form.on('submit(*)', function (data) {
        $.ajax({
            url: data.form.action,
            type: data.form.method,
            data: $(data.form).serialize(),
            success: function (info) {
                if (info.code === 1) {
                    setTimeout(function () {
                        location.href = info.url || location.href;
                    }, 1000);
                }
                layer.msg(info.msg);
            }
        });

        return false;
    });

    /**
     * 通用批量处理（审核、取消审核、删除）
     */
    $('.ajax-action').on('click', function () {
        var _action = $(this).data('action');
        layer.open({
            shade: false,
            content: '确定执行此操作？',
            btn: ['确定', '取消'],
            yes: function (index) {
                $.ajax({
                    url: _action,
                    data: $('.ajax-form').serialize(),
                    success: function (info) {
                        if (info.code === 1) {
                            setTimeout(function () {
                                location.href = info.url || location.href;
                            }, 1000);
                        }
                        layer.msg(info.msg);
                    }
                });
                layer.close(index);
            }
        });

        return false;
    });

    /**
     * 通用全选
     */
    $('.check-all').on('click', function () {
        $(this).parents('table').find('input[type="checkbox"]').prop('checked', $(this).prop('checked'));
    });

    /**
     * 通用删除
     */
    $('.ajax-delete').on('click', function () {
        var _href = $(this).attr('href');
        layer.open({
            shade: false,
            content: '确定删除？',
            btn: ['确定', '取消'],
            yes: function (index) {
                $.ajax({
                    url: _href,
                    type: "get",
                    success: function (info) {
                        if (info.code === 1) {
                            setTimeout(function () {
                                location.href = info.url || location.href;
                            }, 1000);
                        }
                        layer.msg(info.msg);
                    }
                });
                layer.close(index);
            }
        });

        return false;
    });

	/**
     * 通用批量提交操作
     */
    $('.ajax-batch').on('click', function () {
        var _href = $(this).attr('href');
        layer.open({
            shade: false,
            content: '该操作将根据条件批量处理数据，请谨慎操作！<br>确定执行？',
            btn: ['确定', '取消'],
            yes: function (index) {
                $.ajax({
                    url: _href,
                    type: "post",
                    data: $('.layui-form').serialize(),
                    success: function (info) {
                        if (info.code === 1) {
                            setTimeout(function () {
                                location.href = info.url || location.href;
                            }, 1000);
                        }
                        layer.msg(info.msg);
                    }
                });
                layer.close(index);
            }
        });

        return false;
    });

    /**
     * 通用a点击事件
     */
    $('.ajax-click').on('click', function () {
        var _href = $(this).attr('href');
        layer.open({
            shade: false,
            content: '确定执行此操作？',
            btn: ['确定', '取消'],
            yes: function (index) {
                $.ajax({
                    url: _href,
                    type: "get",
                    success: function (info) {
                        if (info.code === 1) {
                            setTimeout(function () {
                                location.href = info.url || location.href;
                            }, 1000);
                        }
                        layer.msg(info.msg);
                    }
                });
                layer.close(index);
            }
        });

        return false;
    });
	/*
	* 使用此方法，必须在元素上配置lay-data url
	*/
	upload.render({
	    elem: '#import',
		accept: 'file',
		before: function(obj){
	    	layer.load(); //上传loading
	  	},
	    done: function(res){
			layer.closeAll('loading');
			layer.open({
			  	title: '导入提示',
			  	content: res.msg
			});
	    },
	    error: function(obj){
			layer.closeAll('loading');
            layer.open({
                title: '导入提示',
                content: obj.error()
            });
	    }
  	});
    upload.render({
        elem: '#import1',
        accept: 'file',
        before: function(obj){
            layer.load(); //上传loading
        },
        done: function(res){
            layer.closeAll('loading');
            layer.open({
                title: '导入提示',
                content: res.msg
            });
        },
        error: function(obj){
            layer.closeAll('loading');
            layer.open({
                title: '导入提示',
                content: obj.error()
            });
        }
    });

    /**
     * 清除缓存
     */
    $('#clear-cache').on('click', function () {
        var _url = $(this).data('url');
        if (_url !== 'undefined') {
            $.ajax({
                url: _url,
                success: function (data) {
                    if (data.code === 1) {
                        setTimeout(function () {
                            location.href = location.pathname;
                        }, 1000);
                    }
                    layer.msg(data.msg);
                }
            });
        }

        return false;
    });

});