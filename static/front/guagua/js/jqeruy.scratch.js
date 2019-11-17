//插件方法封装区
;(function () {
    // 事件绑定
    window.bindHandler = (function () {
        if (window.addEventListener) {// 标准浏览器
            return function (elem, type, handler) {
                // elem:节点    type:事件类型   handler:事件处理函数
                // 最后一个参数为true:在捕获阶段调用事件处理程序;为false:在冒泡阶段调用事件处理程序。注意：ie没有这个参数
                elem.addEventListener(type, handler, false);
            }
        } else if (window.attachEvent) {// IE浏览器
            return function (elem, type, handler) {
                elem.attachEvent("on" + type, handler);
            }
        }
    }());

    // 事件解除
    window.removeHandler = (function () {
        if (window.removeEventListener) {// 标准浏览器
            return function (elem, type, handler) {
                elem.removeEventListener(type, handler, false);
            }
        } else if (window.detachEvent) {// IE浏览器
            return function (elem, type, handler) {
                elem.detachEvent("on" + type, handler);
            }
        }
    }());
}());

//命名区

var canvas = document.getElementById("canvas");
var context = canvas.getContext("2d");

var canvas2 = document.getElementById("canvas2");
var context2 = canvas2.getContext("2d");
var brush = function () {//刮奖
    context.clearRect(event.offsetX, event.offsetY, 20, 20);
};
var draw = function () {//写字
    context2.fillRect(event.offsetX, event.offsetY, 10, 10);
};

//功能实现区

//刮刮乐

// 1. 绘制刮奖区域
context.fillStyle = '#A9AB9D';
context.fillRect(10, 10, 280, 180);
context.fillStyle = '#000';
context.font = '50px Arial';
context.fillText('刮奖区', 75, 115);
//2. 为canvas元素onmousedown和onmouseup事件
canvas.onmousedown = function () {
    // 鼠标按下时 - 绑定鼠标跟随事件
    bindHandler(canvas, 'mousemove', brush, false);
}
canvas.onmouseup = function () {
    // 停止刮奖功能 - 解绑鼠标跟随事件
    removeHandler(canvas, "mousemove", brush, false);
}

//画笔
context2.font = '20px Arial';
context2.strokeText('', 100, 30);//写个头
//为canvas元素onmousedown和onmouseup事件
/*
//这是原来的写法
canvas2.onmousedown = function(){
    // 启用画笔功能 - 绑定鼠标跟随事件
    bindHandler(canvas2,'mousemove',draw,false);
}
canvas2.onmouseup = function(){
    // 停止画笔功能 - 解绑鼠标跟随事件
    removeHandler(canvas2,"mousemove",draw,false);
}
*/
//改良后的写法
var isTouch = "ontouchstart" in window ? true : false;
var StartDraw = isTouch ? "touchstart" : "mousedown",
    MoveDraw = isTouch ? "touchmove" : "mousemove",
    EndDraw = isTouch ? "touchend" : "mouseup";

context2.strokeStyle = 'blue';//线色
context2.lineCap = "round";//连接处为圆形
context2.lineWidth = 10;//线框

canvas2.addEventListener(StartDraw, function (ev) {
    ev.preventDefault();
    var isX = isTouch ? ev.targetTouches[0].pageX : ev.pageX;
    var isY = isTouch ? ev.targetTouches[0].pageY : ev.pageY;
    var x = isX - canvas2.offsetLeft;
    var y = isY - canvas2.offsetTop;
    context2.beginPath();
    context2.moveTo(x, y);

    function StartMove(ev) {
        var isX1 = isTouch ? ev.targetTouches[0].pageX : ev.pageX;
        var isY1 = isTouch ? ev.targetTouches[0].pageY : ev.pageY;
        var x1 = isX1 - canvas2.offsetLeft;
        var y1 = isY1 - canvas2.offsetTop;
        context2.lineTo(x1, y1);

        context2.stroke();
        context2.beginPath();
        context2.moveTo(x1, y1);
    };

    function EndMove(ev) {
        var isX1 = isTouch ? ev.changedTouches[0].pageX : ev.pageX;
        var isY1 = isTouch ? ev.changedTouches[0].pageY : ev.pageY;
        var x1 = isX1 - canvas2.offsetLeft;
        var y1 = isY1 - canvas2.offsetTop;
        context2.lineTo(x1, y1);
        context2.stroke();
        canvas2.removeEventListener(MoveDraw, StartMove, false);
        canvas2.removeEventListener(EndDraw, EndMove, false);
    };
    canvas2.addEventListener(MoveDraw, StartMove, false);
    canvas2.addEventListener(EndDraw, EndMove, false);
}, false);