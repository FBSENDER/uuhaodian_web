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

$(function(){
  var headerBar = $('.header-bar'),
  tabArea = $('#header .tab-area'),
  si = $('.search-input'),
  errTip = $('.err-tip'),
  sb = $('.search-btn');
  headerBar.find('.close').on('click',function(){
    headerBar.remove();
  });
  $(document).on('scroll',function(){
    var _top = $(document).scrollTop();
    if(_top >= 400){
      tabArea.addClass('fixed');
    }else{
      tabArea.removeClass('fixed');
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
});
