'use strict';(function(factory){if(typeof exports==='object'){var jQuery=require('jquery');module.exports=factory(jQuery||$);}else if(typeof define==='function'&&define.amd){define(['jquery'],factory);}else{factory(jQuery||$);}}(function($){var defaults={callback:null,captionSize:0,countdown:true,countdownAlertLimit:10,displayCaptions:false,displayDays:0,displayHours:true,fontFamily:'Verdana, sans-serif',fontSize:32,lang:'en',seconds:0,start:true,theme:'white',vals:[0,0,0,0,0,0,0,0,0],limits:[9,9,9,2,9,5,9,5,9],iSec:8,iHour:4,tickTimeout:1000,intervalId:null};var methods={start:function(sec){if(sec)init.call(this,sec);var me=this,intervalId=setTimeout(function(){tick.call(me);},1000);this.data('ttStartTime',(new Date()).getTime());this.data('intervalId',intervalId);},stop:function(){var data=this.data();if(data.intervalId){clearTimeout(data.intervalId);this.data('intervalId',null);}