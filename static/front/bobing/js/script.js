/* 依赖 mobile layer.js */
(function () {
    var Phage = function (options) {
        return this._init(options || {});
    }
    var ajax = $.ajax;
    $.extend({
        ajax: function(url, options) {
            if (typeof url === 'object') {
                options = url;
                url = undefined;
            }
            options = options || {};
            url = options.url;
            var xsrftoken = $('meta[name=_xsrf]').attr('content');
            var headers = options.headers || {};
            var domain = document.domain.replace(/\./ig, '\\.');
            if (!/^(http:|https:).*/.test(url) || eval('/^(http:|https:)\\/\\/(.+\\.)*' + domain + '.*/').test(url)) {
                headers = $.extend(headers, {'X-Xsrftoken':xsrftoken});
            }
            options.headers = headers;
            return ajax(url, options);
        }
    });
    Phage.prototype = {
        _init: function (options) {
            this.ops = $.extend({
                gid: 0,
                account: '',
                status: 0,
                msg: '请刷新',
                gameRule: '',
                regist:'',
                rechargeSite:'',
            }, options);
            return this;
        },
        ajaxSend: function (options) {
            var ops = $.extend({
                dataType: 'json',
                type: 'POST',
                error: function(info) {
                    layer.open({
                        time: 2,
                        skin: 'msg',
                        content: '请刷新后重试'
                    });
                }
            }, options);
            $.ajax(ops);
        },
        createLoginInfo: function () {
            var _this = this;
            $("#phageLoginAccount").text(_this.ops.account);
            $(".phage-login-info").show();
        },
        openPlayResult: function (info) {
            var _this = this;
            var data = info.data;
            var html = '<div class="content '+(info.code==1?'win':'lose')+'">'+
                '<div class=""></div>'+
                '<div class="detail">'+
                '<p class="gift-item">'+data.gift+'</p>'+
                '</div>'+
                '</div>';
            layer.open({
                type: 1,
                btn: '确定',
                content: html,
                className: 'phage-pop-gift',
                shadeClose: false,
                shade: 'background-color: rgba(0,0,0,.9)',
                yes: function (index) {
                    layer.close(index);
                }
            });
        },
        start: function (callback) {
            var _this = this;
            var gamid = $("#GameId").val();
            var html = '<div class="phage-header">'+
                '<a class="phage-game-rule" href='+_this.ops.regist+'>注册</a>'+
                '<a class="phage-game-rule" href='+_this.ops.rechargeSite+'>充值</a>'+
                '<div class="phage-login-info">'+
                '<a href="javascript:;" id="phageSearch"><span id="phageLoginAccount"></span></a>'+
                '<a class="phage-logout" href="javascript:;">注销</a>' +
                '<a class="phage-query" href="/query?gid='+gamid+'">查询</a>' +
                '</div>'+
                '</div><div class="phage-top-clear"></div>';
            $('body').append(html);
            $(".phage-logout").on("click", function () {
                localStorage.clear();
                _this.ajaxSend({
                    url: '/logout',
                    type: 'GET',
                    success: function (info) {
                        $("#phageLoginAccount").text("");
                        $(".phage-login-info").hide();
                        window.location.reload();
                    }
                });
            });
            /*$(".phage-game-rule").on("click", function () {
                layer.open({
                    //type: 1,
                    btn: '我知道啦',
                    content: '<div class="phage-game-rule-detail">' + _this.ops.gameRule || '暂无规则' + '</div>'
                    ,anim: 'up'
                });
                return;
            });*/
            if(_this.ops.status != 3) {
                layer.open({
                    skin: 'msg',
                    content: _this.ops.msg || '活动异常，请联系管理员'
                });
                return;
            }
           localusename = localStorage.getItem("username");
            if (localusename == null){
                if(_this.ops.account == '') {
                    _this.login(callback);
                } else {
                    _this.ajaxSend({
                        url: '/login',
                        data: {account: _this.ops.account, gid: _this.ops.gid},
                        success: function (info) {
                            if (info.code == 1) {
                                callback();
                                _this.createLoginInfo();
                            } else {
                                _this.login(callback);
                            }
                        }
                    });
                }
            }else {
                _this.ops.account = localusename;
                _this.createLoginInfo();
            }

        },
        login: function (callback) {
            var _this = this;
            layer.open({
                type: 0,
                className: 'phage-login-dialog',
                content: '<input name="account" id="phageAccount" required placeholder="会员账号">',
                shadeClose: false,
                btn: '登  录',
                yes: function (index) {
                    var account = $('#phageAccount').val().replace(/\s+/g, "");
                    var gid = _this.ops.gid;
                    if (account == '') {
                        layer.open({
                            type: 1,
                            time: 2,
                            skin: 'msg',
                            content: '请填写会员号'
                        });
                        return false;
                    }
                    _this.ajaxSend({
                        url: '/login',
                        data: {account: account, gid: gid},
                        success: function (info) {
                            if (info.code == 1) {
                                _this.ops.account = account;
                                localStorage.username = account;
                                layer.close(index);
                                callback();
                                _this.createLoginInfo();
                            } else {
                                layer.open({
                                    type: 1,
                                    time: 2,
                                    skin: 'msg',
                                    content: info.msg || '请重试'
                                });
                            }
                        }
                    });
                }
            });
        },
        lottery: function (callback) {
            var _this = this;
            _this.ajaxSend({
                url: '/front/lottery',
                success: function (info) {
                    if(info.code == 0) {
                        layer.open({
                            type: 1,
                            time: 2,
                            skin: 'msg',
                            content: info.msg || '请重试'
                        });
                    } else {
                        callback(info);
                    }
                }
            });
        }
    }
    window.Phage = Phage;
})();
