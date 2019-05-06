/**
 *
 */
var Util = Util || {};

Util.pageSize = function() {
    var a = document.documentElement;
    var b = ["clientWidth", "clientHeight", "scrollWidth", "scrollHeight"];
    var c = {};
    for (var d in b) c[b[d]] = a[b[d]];
    c.scrollLeft = document.body.scrollLeft || document.documentElement.scrollLeft;
    c.scrollTop = document.body.scrollTop || document.documentElement.scrollTop;
    return c;
};
Util.lazyLoad = function(cn){
  var lazyImg = $('.'+cn);

  lazyImg.each(function(){
    var _this = $(this);
    var url = _this.attr('data-original');

    $('<img />').one('load',function(){
      if(_this.is('img')){
        _this.attr('src',url);
      }else{
        _this.css('background-image','url('+url+')');
            }
            setTimeout(function(){
              _this.css('opacity','1');
            },15);
            }).one('error',function(){
          _this.css('opacity','1');
        }).attr('src',url);
        });
    }

Util.timeCount = function(obj,endDesc,type){
    obj = $(obj);
    var endTime = obj.data('endtime');
    var now = Math.floor(new Date().getTime()/1000)*1;
    if(now > endTime){
        obj.html(endDesc);
    }else{
        var gap = endTime - now;
        var dd = Math.floor(gap/(60*60*24));
        var hh = Math.floor((gap-dd*60*60*24)/(60*60));
        var mm = Math.floor((gap-dd*60*60*24-hh*60*60)/60);
        var ss = gap-dd*60*60*24-hh*60*60-mm*60;
        var timeStr = '还剩&nbsp;'
            +(dd>0?'<em>'+dd+'</em>天':'')
            +(hh>0?'<em>'+hh+'</em>时':'')
            +(mm>0?'<em>'+mm+'</em>分':'')
            +(ss>=0?'<em>'+ss+'</em>秒':'')
            +'&nbsp;结束';
        if(type && type == 2 && dd <= 0){
            timeStr = '<span style="color:#FF2220;font-weight: bold;">即将失效：&nbsp;'
                +(dd>0?'<em>'+dd+'</em>天':'')
                +(hh>0?'<em>'+hh+'</em>时':'')
                +(mm>0?'<em>'+mm+'</em>分':'')
                +(ss>=0?'<em>'+ss+'</em>秒':'')
                +'</span>';
        }
        obj.html(timeStr);
    }
}

Util.zkItemTimeCount = function(type){
    var timeCountInter = null;
    $('.zk-item').unbind('mouseenter').unbind('mouseleave');
    $('.zk-item').on('mouseenter',function(){
        clearInterval(timeCountInter);
        timeCountInter = null;

        var tc = $(this).find('.time-count');
        Util.timeCount(tc,'优惠券已过期',type);
        timeCountInter = setInterval(function(){
            Util.timeCount(tc,'优惠券已过期',type);
        },1000);
    }).on('mouseleave',function(){
        clearInterval(timeCountInter);
        timeCountInter = null;
    });
}
Util.createLanlanCouponList = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var re = /activityId=(\w*)/;
    var buy_url = '/yh/' + z.itemId + '/';
    buy_url += "?coupon_money=" + parseInt(z.couponMoney)
    if(channel == 10){
      buy_url += "&from=iquan";
    }
    buy_url += "#coupon"
    var platform = '',platformPic = '';
    if(z.shopType == 'tmall')
      platform = 2;
    else
      platform = 1;
    htmlstr += '<div class="zk-item">';
    htmlstr += '<a href="'+ buy_url +'">';
    htmlstr += '<div class="img-area">';
    htmlstr += '<div class="bottom-info">';
    htmlstr += '<p data-endtime="'+ z.couponEndTime +'" class="time-count"></p>';
    htmlstr += '</div>';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.coverImage +'" alt="'+z.title +'">';
    htmlstr += '</div>';
    htmlstr += '<p class="title-area elli">';
    htmlstr += '<span class="post-free">包邮</span>';
    htmlstr +=  z.shortTitle +'</p>';
    htmlstr += '<div class="raw-price-area">现价：&yen;'+ z.price +'<p class="sold">已领'+ z.monthSales +'张券</p></div>';
    htmlstr += '<div class="info">';
    htmlstr += '<div class="price-area">';
    htmlstr += '<span class="price">&yen;<em class="number-font">'+ z.nowPrice.toString().split('.')[0] +'</em>';
    htmlstr += '<em class="decimal">'+(z.nowPrice.toString().split('.').length>1?'.'+z.nowPrice.toString().split('.')[1]:'')+'</em><i></i></span>';
    htmlstr += '</div>';
    htmlstr += '<span class="coupon_click">券 ';
    htmlstr += parseInt(z.couponMoney);
    htmlstr += ' 元</span>';
    htmlstr += '</div>';
    htmlstr += '</a>';
    htmlstr += '</div>';
  }
  htmlstr += '</div>';
  htmlstr = $(htmlstr);
  htmlstr.find('[data-ga-event]').on('click',function(){
    var _this = $(this);
    var gaEvent = _this.attr('data-ga-event');
    var gaParmas = gaEvent.split(':');
    if(typeof ga != 'undefined' && gaParmas.length >= 3){
      ga('send','event',gaParmas[0],gaParmas[1],gaParmas[2]);
    }
  });
  obj.append(htmlstr);
  Util.lazyLoad('lazy.new');
  $('.lazy.new').removeClass('new');
  Util.zkItemTimeCount();
}
Util.createTaobaoCouponList = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var re = /减(\d+)元/;
    var coupon_money = parseInt(re.exec(z.coupon_info)[1]);
    var buy_url = 'http://api.uuhaodian.com/uu/pcbuy?id=' + z.num_iid;
    if(channel == 10){
      buy_url += "&from=iquan";
    }
    var platform = '',platformPic = '';
    if(z.user_type == 1)
      platform = 2;
    else
      platform = 1;
    htmlstr += '<div class="zk-item">';
    htmlstr += '<a href="/yh/'+ z.num_iid +'/?coupon_money=' + coupon_money + '#coupon">';
    htmlstr += '<div class="img-area">';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.pict_url +'" alt="'+z.
      title +'">';
    htmlstr += '</div>';
    htmlstr += '<p class="title-area elli">';
    htmlstr += '<span class="post-free">包邮</span>';
    htmlstr +=  z.title +'</p>';
    htmlstr += '<div class="raw-price-area">现价：&yen;'+ z.zk_final_price +'<p class="sold">已领'+ (z.volume + 131) +'张券</p></div>';
    htmlstr += '<div class="info">';
    htmlstr += '<div class="price-area">';
    htmlstr += '<span class="price">&yen;<em class="number-font">'+ (parseInt(z.zk_final_price) - coupon_money) +'</em>';
    htmlstr += '<em class="decimal">'+(z.zk_final_price.toString().split('.').length>1?'.'+z.zk_final_price.toString().split('.')[1]:'')+'</em><i></i></span>';
    htmlstr += '</div>';
    htmlstr += '<span class="coupon_click">券 ';
    htmlstr += coupon_money;
    htmlstr += ' 元</span>';
    htmlstr += '</div>';
    htmlstr += '</a>';
    htmlstr += '</div>';
  }
  htmlstr += '</div>';
  htmlstr = $(htmlstr);
  obj.append(htmlstr);
  Util.lazyLoad('lazy.new');
  $('.lazy.new').removeClass('new');
}
Util.createTaobaoProductList = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var buy_url = z.item_url; 
    var platform = '',platformPic = '';
    if(z.user_type == 1)
      platform = 2;
    else
      platform = 1;
    htmlstr += '<div class="zk-item">';
    htmlstr += '<a href="http://tt.uuhaodian.com/yh/'+ z.num_iid +'/#coupon">';
    htmlstr += '<div class="img-area">';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.pict_url +'" alt="'+z.
      title +'">';
    htmlstr += '</div>';
    htmlstr += '<p class="title-area elli">';
    htmlstr += '<span class="post-free">包邮</span>';
    htmlstr +=  z.title +'</p>';
    htmlstr += '<div class="raw-price-area">现价：&yen;'+ z.reserve_price +'<p class="sold">已售'+ (z.volume + 131) +'件</p></div>';
    htmlstr += '<div class="info">';
    htmlstr += '<div class="price-area">';
    htmlstr += '<span class="price">&yen;<em class="number-font">'+ parseInt(z.zk_final_price) +'</em>';
    htmlstr += '<em class="decimal">'+(z.zk_final_price.toString().split('.').length>1?'.'+z.zk_final_price.toString().split('.')[1]:'')+'</em><i></i></span>';
    htmlstr += '</div>';
    htmlstr += '<span class="coupon_click">' + (parseFloat(z.zk_final_price) * 10.0 / parseFloat(z.reserve_price)).toFixed(1) + ' 折</span> ';
    htmlstr += '</div>';
    htmlstr += '</a>';
    htmlstr += '</div>';
  }
  htmlstr += '</div>';
  htmlstr = $(htmlstr);
  obj.append(htmlstr);
  Util.lazyLoad('lazy.new');
  $('.lazy.new').removeClass('new');
}
Util.createTaobaoCouponFluid = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var platform = '',platformPic = '';
    if(z.user_type == 1)
      platform = 2;
    else
      platform = 1;
    htmlstr += '<div class="item" onclick="ga_event(this);" data-ga="领券:品牌好券:品牌好券_信息流_领券">';
    htmlstr += '<a href="'+ z.coupon_click_url +'" target="_blank">';
    htmlstr += '<div class="img-area">';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.pict_url +'" alt="'+z.title +'"/>';
    htmlstr += '</div></a>';
    htmlstr += '<a href="/yh/'+ z.item_id +'/?coupon_money=' + z.coupon_amount + '#coupon" target="_blank">';
    htmlstr += '<div class="content">';
    htmlstr += '<div class="title elli">'
    htmlstr +=  z.title +'</div>';
    htmlstr += '<div class="desc">'
    htmlstr +=  z.item_description +'</div>';
    htmlstr += '<div class="shop">'
    htmlstr += '30天销量 ' + z.volume + ' 件';
    htmlstr += '</div>'
    htmlstr += '<div class="price"><span class="normal">券后价&nbsp;&nbsp; </span>';
    htmlstr += (parseInt(z.zk_final_price) - parseInt(z.coupon_amount));
    htmlstr += '</div></div></a>';
    htmlstr += '<div class="right"><div class="btn">';
    htmlstr += '<a href="/yh/' + z.item_id + '/?coupon_money=' + z.coupon_amount +'#coupon" title="立即领券" target="_blank">' 
    htmlstr += parseInt(z.coupon_amount) + '元券</a></div></div>';
    htmlstr += '</div>';
  }
  htmlstr += '</div>';
  htmlstr = $(htmlstr);
  obj.append(htmlstr);
  Util.lazyLoad('lazy.new');
  $('.lazy.new').removeClass('new');
}
Util.createLanlanCouponFluid = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var re = /activityId=(\w*)/;
    var buy_url = '/yh/' + z.itemId + '/';
    if(channel == 10){
      buy_url += "?from=iquan";
    }
    buy_url += "#coupon"
    var platform = '',platformPic = '';
    if(z.shopType == 'tmall')
      platform = 2;
    else
      platform = 1;
    htmlstr += '<div class="item" onclick="ga_event(this);" data-ga="信息流详情:小时风云榜:小时风云榜_信息流详情">';
    htmlstr += '<a href="'+ buy_url +'">';
    htmlstr += '<div class="img-area">';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.coverImage +'" alt="'+z.
      title +'"/>';
    if(page == 1 && i < 3){
      htmlstr += '<span class="top-bang-order">' + (i + 1) + '</span>'
    }
    htmlstr += '</div></a>';
    htmlstr += '<a href="'+ buy_url +'">';
    htmlstr += '<div class="content">';
    htmlstr += '<div class="title elli">'
    htmlstr +=  z.shortTitle +'</div>';
    htmlstr += '<div class="desc">'
    htmlstr +=  z.recommend +'</div>';
    htmlstr += '<div class="shop">'
    htmlstr += z.sellerName + ' - 2小时销量 ' + z.sales2h + ' 件';
    htmlstr += '</div>'
    htmlstr += '<div class="price"><span class="normal">券后价&nbsp;&nbsp; </span>';
    htmlstr += z.nowPrice;
    htmlstr += '</div></div></a>';
    htmlstr += '<div class="right"><div class="btn">';
    htmlstr += '<a href="' + buy_url +'" target="_blank" title="立即领券">' 
    htmlstr += parseInt(z.couponMoney) + '元券</a></div></div>';
    htmlstr += '</div>';
  }
  htmlstr += '</div>';
  htmlstr = $(htmlstr);
  obj.append(htmlstr);
  Util.lazyLoad('lazy.new');
  $('.lazy.new').removeClass('new');
}
