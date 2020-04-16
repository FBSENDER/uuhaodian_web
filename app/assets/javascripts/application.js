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
function goSearch(q){
  if(q.indexOf('jd.com') >= 0){
    _hmt.push(['_trackEvent', '京东商品搜索', 'click', 'PC全局']);
  }
  window.location.href = '/query/' + encodeURIComponent(q) + '/';
}
function suggestClick(obj){
  $(".suggest-area").addClass('sno');
  var kw = $(obj).text();
  $("#search_input").val(kw);
  _hmt.push(['_trackEvent', '顶部suggest点击', 'click', 'PC全局']);
  goSearch(kw);
}

$(function(){
  var headerBar = $('.header-bar'),
  tabArea = $('#header .tab-area'),
  si = $('.search-input'),
  errTip = $('.err-tip'),
  sb = $('.search-btn');
  var fluid_left = $('.fluid-left');
  var gy_filter = $('#gy_filter');
  var jd_tool_area_right = $('.jd-tool-area-right');
  headerBar.find('.close').on('click',function(){
    headerBar.remove();
  });
  $(document).on('scroll',function(){
    var _top = $(document).scrollTop();
    if(_top >= 800){
      tabArea.addClass('fixed');
      fluid_left.addClass('fixed');
      if(gy_filter){
        gy_filter.addClass('fixed');
      }
      if(jd_tool_area_right){
        jd_tool_area_right.fadeIn(1000);
      }
    }else{
      tabArea.removeClass('fixed');
      fluid_left.removeClass('fixed');
      if(gy_filter){
        gy_filter.removeClass('fixed');
      }
      if(jd_tool_area_right){
        jd_tool_area_right.fadeOut(100);
      }
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

  function scrollToTop(){
    var body = $('body,html');
    body.stop(true,true).animate({
      scrollTop:0
    },100);
  }
  $("#backToTop").on('click', function(){
    scrollToTop();
  });
  $("#gy_filter.fixed").on('click', function(){
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
    autoplay: {
      delay: 3000
    },
    loop:true,
    pagination: {
      el: '.swiper-pager'
    }
  });
  var sww = new Swiper('.wide-banner',{
    loop: true,
    navigation:{
      prevEl:'.swiper-button-prev',
      nextEl:'.swiper-button-next'
    }
  });
  $("#search_input").keyup(function(){
    var _this = $(this);
    var kw = _this.val().trim();
    if(kw != ''){
      $.ajax({
        url: "/query_suggest",
        type: 'GET',
        data: {
          kw: kw
        },
        success:function(data){
          if(data.status == 1 && data.data.length > 0){
            $("#suggest_list_items").html("");
            var s = "";
            for(var i = 0; i < data.data.length; i++){
              s += '<p class="suggest-item" onclick="suggestClick(this);">' + data.data[i] + '</p>';
            }
            $("#suggest_list_items").html(s);
            $(".suggest-area").removeClass('sno');
          }
          else{
            $(".suggest-area").addClass('sno');
          }
        }
      });
    }
    else{
      $(".suggest-area").addClass('sno');
    }
  });
  $("#suggest_close").click(function(){
    $(".suggest-area").addClass('sno');
  });

});

/*! jquery.cookie v1.4.1 | MIT */
!function(a){"function"==typeof define&&define.amd?define(["jquery"],a):"object"==typeof exports?a(require("jquery")):a(jQuery)}(function(a){function b(a){return h.raw?a:encodeURIComponent(a)}function c(a){return h.raw?a:decodeURIComponent(a)}function d(a){return b(h.json?JSON.stringify(a):String(a))}function e(a){0===a.indexOf('"')&&(a=a.slice(1,-1).replace(/\\"/g,'"').replace(/\\\\/g,"\\"));try{return a=decodeURIComponent(a.replace(g," ")),h.json?JSON.parse(a):a}catch(b){}}function f(b,c){var d=h.raw?b:e(b);return a.isFunction(c)?c(d):d}var g=/\+/g,h=a.cookie=function(e,g,i){if(void 0!==g&&!a.isFunction(g)){if(i=a.extend({},h.defaults,i),"number"==typeof i.expires){var j=i.expires,k=i.expires=new Date;k.setTime(+k+864e5*j)}return document.cookie=[b(e),"=",d(g),i.expires?"; expires="+i.expires.toUTCString():"",i.path?"; path="+i.path:"",i.domain?"; domain="+i.domain:"",i.secure?"; secure":""].join("")}for(var l=e?void 0:{},m=document.cookie?document.cookie.split("; "):[],n=0,o=m.length;o>n;n++){var p=m[n].split("="),q=c(p.shift()),r=p.join("=");if(e&&e===q){l=f(r,g);break}e||void 0===(r=f(r))||(l[q]=r)}return l};h.defaults={},a.removeCookie=function(b,c){return void 0===a.cookie(b)?!1:(a.cookie(b,"",a.extend({},c,{expires:-1})),!a.cookie(b))}});
