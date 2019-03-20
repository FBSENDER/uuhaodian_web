// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require_tree .
function ga_event(e){
  d = $(e).data("ga").split(":");
  gtag('event', d[0], {'event_category': d[1], 'event_label': d[2]});
}

$(function(){
  var headerBar = $('.header-bar'),
  tabArea = $('#header .tab-area'),
  si = $('.search-input'),
  errTip = $('.err-tip'),
  sb = $('.search-btn');
  var fluid_left = $('.fluid-left');
  headerBar.find('.close').on('click',function(){
    headerBar.remove();
  });
  $(document).on('scroll',function(){
    var _top = $(document).scrollTop();
    if(_top >= 400){
      tabArea.addClass('fixed');
      fluid_left.addClass('fixed');
    }else{
      tabArea.removeClass('fixed');
      fluid_left.removeClass('fixed');
    }
  });
  si.on('focus',function(){
    $(this).removeClass('unfocus');
  }).on('blur',function(){
    $(this).addClass('unfocus');
  }).on('keyup',function(e){
    var keycode = e.keyCode,
    q = $(this).val();
    $('.search-input.unfocus').val(q);

    if(keycode == 13 && q.trim()){
      goSearch(q.trim());
    }});
  sb.on('click',function(){
    var q = $(si[0]).val();
    if(q.trim() && q.trim() != '输入关键词'){
      goSearch(q.trim());
    }
  });

  function goSearch(q){
    window.location.href = '/query/' + encodeURIComponent(q).replace(/\x/g, "%") + '/';
  }
  function scrollToTop(){
    var body = $('body,html');
    body.stop(true,true).animate({
      scrollTop:0
    },100);
  }
  $("#backToTop").on('click', function(){
    scrollToTop();
  });
  $(window).on('scroll',function(){
    var scrollTop = document.documentElement.scrollTop;
    if(scrollTop > 1500){
      $('#backToTop').fadeIn(100);
    }else{
      $('#backToTop').fadeOut(100);
    }
  });
  var sw = new Swiper('.banner-area',{
    autoplay: 3000,
    loop:true,
    pagination: '.swiper-pager'
  });
  var sww = new Swiper('.wide-banner',{
    loop: true,
    prevButton:'.swiper-button-prev',
    nextButton:'.swiper-button-next'
  });
  $("#user_login").on('click', function(){
    url = "https://open.weixin.qq.com/connect/qrconnect?appid=wxb5c85d0e9a2a3ecd&esponse_type=code&scope=snsapi_login&state=STATE&redirect_uri=http%3A%2F%2Fapi.uuhaodian.com%2Fuu%2Fweb_login%3Fuu_path%3D" + encodeURIComponent(encodeURIComponent(location.href)) + "#wechat_redirect";
    window.location.href = url;
  });
  $("#user_logout").on('click', function(){
    window.location.href = "http://api.uuhaodian.com/uu/web_logout/";
  });
  $("#shoucang").on('click', function(){
    var $shoucang = $("#shoucang-span");
    if($shoucang[0].innerText == "加入收藏"){
      if($.cookie('session_key') == undefined){
        url = "https://open.weixin.qq.com/connect/qrconnect?appid=wxb5c85d0e9a2a3ecd&esponse_type=code&scope=snsapi_login&state=STATE&redirect_uri=http%3A%2F%2Fapi.uuhaodian.com%2Fuu%2Fweb_login%3Fuu_path%3D" + encodeURIComponent(encodeURIComponent(location.href)) + "#wechat_redirect";
        window.location.href = url;
        return;
      }
      $.ajax({
        url: 'http://api.uuhaodian.com/uu/add_product_liked',
        type: 'GET',
        dataType: 'jsonp',
        data:{
          item_id: $shoucang.data("id")
        },
        beforeSend: function(){
         $shoucang.text("操作中...");
        },
        success:function(data){
         $shoucang.text("已收藏");
        }
      });
    }
    else if ($shoucang[0].innerText == "已收藏"){
      $.ajax({
        url: 'http://api.uuhaodian.com/uu/cancel_product_liked',
        type: 'GET',
        dataType: 'jsonp',
        data:{
          item_id: $shoucang.data("id")
        },
        beforeSend: function(){
         $shoucang.text("操作中...");
        },
        success:function(data){
         $shoucang.text("加入收藏");
        }
      });
    }
  });
  if($("#shoucang-span").length > 0){
    var $shoucang = $("#shoucang-span");
    $.ajax({
      url: 'http://api.uuhaodian.com/uu/check_product_liked',
      type: 'GET',
      dataType: 'jsonp',
      data:{
        item_id: $shoucang.data("id")
      },
      success:function(data){
        if(data["status"] == 1){
          $shoucang.text("已收藏");
        }
      }
    });
  }
  if($.cookie('session_key') != undefined){
    $("#user_login").hide();
    $("#nickname").text($.cookie('nickname'));
    $("#headimgurl").attr("src", $.cookie('headimgurl'));
    $("#logined").show();
  }

});

/*! jquery.cookie v1.4.1 | MIT */
!function(a){"function"==typeof define&&define.amd?define(["jquery"],a):"object"==typeof exports?a(require("jquery")):a(jQuery)}(function(a){function b(a){return h.raw?a:encodeURIComponent(a)}function c(a){return h.raw?a:decodeURIComponent(a)}function d(a){return b(h.json?JSON.stringify(a):String(a))}function e(a){0===a.indexOf('"')&&(a=a.slice(1,-1).replace(/\\"/g,'"').replace(/\\\\/g,"\\"));try{return a=decodeURIComponent(a.replace(g," ")),h.json?JSON.parse(a):a}catch(b){}}function f(b,c){var d=h.raw?b:e(b);return a.isFunction(c)?c(d):d}var g=/\+/g,h=a.cookie=function(e,g,i){if(void 0!==g&&!a.isFunction(g)){if(i=a.extend({},h.defaults,i),"number"==typeof i.expires){var j=i.expires,k=i.expires=new Date;k.setTime(+k+864e5*j)}return document.cookie=[b(e),"=",d(g),i.expires?"; expires="+i.expires.toUTCString():"",i.path?"; path="+i.path:"",i.domain?"; domain="+i.domain:"",i.secure?"; secure":""].join("")}for(var l=e?void 0:{},m=document.cookie?document.cookie.split("; "):[],n=0,o=m.length;o>n;n++){var p=m[n].split("="),q=c(p.shift()),r=p.join("=");if(e&&e===q){l=f(r,g);break}e||void 0===(r=f(r))||(l[q]=r)}return l};h.defaults={},a.removeCookie=function(b,c){return void 0===a.cookie(b)?!1:(a.cookie(b,"",a.extend({},c,{expires:-1})),!a.cookie(b))}});
