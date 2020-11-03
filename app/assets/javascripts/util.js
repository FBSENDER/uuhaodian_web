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
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.coverImage.replace('http:', '') +'" alt="'+z.title +'">';
    htmlstr += '</div>';
    htmlstr += '<p class="title-area">';
    htmlstr +=  z.shortTitle +'</p>';
    htmlstr += '<div class="tags-area">'
    if(platform == 2){
      htmlstr += '<span class="tag">天猫</span>';
    }
    else{
      htmlstr += '<span class="tag taobao">淘宝</span>';
    }
    if(z.sellerName.indexOf('旗舰店') > 0){
      htmlstr += '<span class="tag">旗舰店</span>';
    }
    if(z.activityType == 2){
      htmlstr += '<span class="tag">淘抢购</span>';
    }
    else if(z.activityType == 3){
      htmlstr += '<span class="tag">聚划算</span>';
    }
    if(z.couponMoney > 0){
      htmlstr += '<span class="tag c">' + parseInt(z.couponMoney) + '元券</span>';
    }
    htmlstr += '</div>'
    htmlstr += '<div class="price-area">';
    htmlstr += '券后价 ￥ <span class="price">' + (z.nowPrice > 0 ? z.nowPrice : z.price)  + '</span>';
    htmlstr += '</div>';
    htmlstr += '<div class="raw-price-area">原价：&yen;'+ z.price;
    if(z.monthSales > 0){
      var vv = z.monthSales > 10000 ? ((z.monthSales / 10000).toFixed(1) + '万') : z.monthSales
      htmlstr += '<p class="sold">' + vv +'人已付款</p>'
    }
    htmlstr += '</div>';
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
    htmlstr += '<p class="title-area">';
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
    htmlstr += '<p class="title-area">';
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
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.coverImage.replace('http:', '') +'" alt="'+z.
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
Util.createDgList = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var coupon_money = z.coupon_amount ? parseInt(z.coupon_amount) : 0;
    var now_price = (parseFloat(z.zk_final_price) - coupon_money).toFixed(2);
    var o_price = coupon_money > 0 ? parseFloat(z.zk_final_price).toFixed(2) : parseFloat(z.reserve_price).toFixed(2);
    var zhe = (now_price * 10.0 / o_price).toFixed(1);
    var platform = '',platformPic = '';
    htmlstr += '<div class="zk-item">';
    if(coupon_money > 0){
      htmlstr += '<a href="/yh/'+ z.item_id +'/?coupon_money=' + coupon_money + '#coupon" onclick="_hmt.push([\'_trackEvent\', \'淘宝商品点击\', \'click\', \'PC查询页\'])">';
    }
    else{
      htmlstr += '<a href="/yh/'+ z.item_id +'/#coupon" onclick="_hmt.push([\'_trackEvent\', \'淘宝商品点击\', \'click\', \'PC查询页\'])">';
    }
    htmlstr += '<div class="img-area">';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.pict_url +'" alt="'+z.
      title +'">';
    htmlstr += '</div>';
    htmlstr += '<p class="title-area">';
    if(z.short_title != ''){
      htmlstr +=  z.short_title +'</p>';
    }
    else{
      htmlstr +=  z.title +'</p>';
    }
    htmlstr += '<div class="tags-area">'
    if(z.user_type == 1){
      htmlstr += '<span class="tag">天猫</span>';
    }
    else{
      htmlstr += '<span class="tag taobao">淘宝</span>';
    }
    if(z.shop_title.indexOf('旗舰店') > 0){
      htmlstr += '<span class="tag">旗舰店</span>';
    }
    if(coupon_money > 0){
      htmlstr += '<span class="tag c">' + coupon_money + '元券</span>';
    }
    htmlstr += '</div>'
    htmlstr += '<div class="price-area">';
    if(coupon_money > 0){
      htmlstr += '券后价 ￥ <span class="price">' + now_price + '</span>';
    }
    else{
      htmlstr += '折扣价 ￥ <span class="price">' + now_price + '</span>';
    }
    htmlstr += '</div>';
    htmlstr += '<div class="raw-price-area">原价：&yen;'+ o_price;
    if(z.volume > 0){
      var vv = z.volume > 10000 ? ((z.volume / 10000).toFixed(1) + '万') : z.volume
      htmlstr += '<p class="sold">' + vv +'人已付款</p>'
    }
    htmlstr += '</div>';
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
Util.createPddList = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var coupon_money = z.couponMoney ? parseInt(z.couponMoney) : 0;
    var zhe = (parseFloat(z.nowPrice) * 10.0 / parseFloat(z.price)).toFixed(1);
    var buy_url = '/ddk/' + z.itemId + '/#coupon';
    htmlstr += '<div class="zk-item">';
    htmlstr += '<a href="'+ buy_url +'" title="'+ z.title + '" onclick="_hmt.push([\'_trackEvent\', \'拼多多商品点击\', \'click\', \'PC查询页\'])">';
    htmlstr += '<div class="img-area">';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.coverImage +'" alt="'+z.title +'">';
    htmlstr += '</div>';
    htmlstr += '<p class="title-area">';
    htmlstr +=  z.shortTitle +'</p>';
    htmlstr += '<div class="tags-area">'
    htmlstr += '<span class="tag">拼多多</span>';
    if(z.shopName.indexOf('旗舰店') > 0){
      htmlstr += '<span class="tag">旗舰店</span>';
    }
    if(z.activityTags != null && z.activityTags.includes(4)){
      htmlstr += '<span class="tag">秒杀</span>';
    }
    if(z.activityTags != null && z.activityTags.includes(7)){
      htmlstr += '<span class="tag">百亿补贴</span>';
    }
    if(z.activityTags != null && z.activityTags.includes(21)){
      htmlstr += '<span class="tag">金牌卖家</span>';
    }
    if(coupon_money > 0){
      htmlstr += '<span class="tag c">' + coupon_money + '元券</span>';
    }
    htmlstr += '</div>'
    htmlstr += '<div class="price-area">';
    if(coupon_money > 0){
      htmlstr += '券后价 ￥ <span class="price">' + z.nowPrice + '</span>';
    }
    else{
      htmlstr += '折扣价 ￥ <span class="price">' + z.nowPrice + '</span>';
    }
    htmlstr += '</div>';
    htmlstr += '<div class="raw-price-area">原价：&yen;'+ z.price;
    if(z.monthSales != '0'){
      htmlstr += '<p class="sold">'+ z.monthSales +'人已付款</p>';
    }
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
}
Util.createJdList = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '<div>';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var coupon_money = z.coupon_amount ? parseInt(z.coupon_amount) : 0;
    var buy_url = "/jd/" + z.item_id + '/#coupon';
    if(coupon_money == 0 && z.price_type == 1){
      buy_url = "/jd/buy/" + z.item_id + '/';
    }
    htmlstr += '<div class="zk-item">';
    if(coupon_money == 0 && z.price_type == 1){
      htmlstr += '<a href="'+ buy_url +'" target="_blank" title="' + z.title +  '" onclick="_hmt.push([\'_trackEvent\', \'京东商品jump\', \'click\', \'PC查询页\'])">';
    }
    else{
      htmlstr += '<a href="'+ buy_url +'" title="' + z.title +  '" onclick="_hmt.push([\'_trackEvent\', \'京东商品点击\', \'click\', \'PC查询页\'])">';
    }
    htmlstr += '<div class="img-area">';
    htmlstr += '<img data-ga-event="商品_图片:点击:'+ gaPage +'" class="lazy new" data-original="'+ z.pict_url +'" alt="'+z.title +'">';
    htmlstr += '</div>';
    htmlstr += '<p class="title-area">';
    htmlstr +=  z.title +'</p>';
    htmlstr += '<div class="tags-area">'
    htmlstr += '<span class="tag">京东</span>';
    if(z.owner == 'g'){
      htmlstr += '<span class="tag">自营</span>';
    }
    if(coupon_money > 0){
      htmlstr += '<span class="tag c">' + coupon_money + '元券</span>';
    }
    if(z.shop_title.indexOf('旗舰店') > 0){
      htmlstr += '<span class="tag">旗舰店</span>';
    }
    if(z.is_hot > 0){
      htmlstr += '<span class="tag">爆款</span>';
    }
    htmlstr += '</div>'
    htmlstr += '<div class="price-area">';
    if(coupon_money > 0){
      htmlstr += '券后价 ￥ <span class="price">' + z.lowest_coupon_price + '</span>';
    }
    else if(coupon_money == 0 && z.price_type == 2){
      htmlstr += '拼购价 ￥ <span class="price">' + z.lowest_coupon_price + '</span>';
    }
    else if(coupon_money == 0 && z.price_type == 3){
      htmlstr += '秒杀价 ￥ <span class="price">' + z.lowest_coupon_price + '</span>';
    }
    else{
      htmlstr += '现价 ￥ <span class="price">' + z.lowest_price + '</span>';
    }
    htmlstr += '</div>';
    if(coupon_money > 0 && z.price_type == 2){
      htmlstr += '<div class="raw-price-area">拼购价：&yen; '+ z.lowest_price;
    }
    else if(coupon_money > 0 && z.price_type == 3){
      htmlstr += '<div class="raw-price-area">秒杀价：&yen; '+ z.lowest_price;
    }
    else{
      htmlstr += '<div class="raw-price-area">原价：&yen; '+ z.o_price;
    }
    if(z.sales > 0){
      var vv = z.sales > 10000 ? ((z.sales / 10000).toFixed(1) + '万') : z.sales
      htmlstr += '<p class="sold">'+ vv +'人已付款</p>';
    }
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
}

Util.createJdCoupon = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '';
  for(var i=0,len=cl.length;i<len;i++){
    var z = cl[i];
    var buy_url = "/jd/buy/" + z.product_id + '/?coupon=' + encodeURIComponent(z.coupon_url);
    var c_url = "/jd/buy_url/" + z.product_id + '/?coupon=' + encodeURIComponent(z.coupon_url);
    htmlstr += '<a href="'+ buy_url +'" target="_blank" onclick="_hmt.push([\'_trackEvent\', \'京券领取\', \'click\', \'jd\'])" title="使用手机京东扫啊扫，可以直接领券">';
    htmlstr += '<div class="jd-coupon" data-id="' + z.product_id + '" data-url="' + c_url + '">';
    htmlstr += '<div class="img" style="overflow:hidden;white-space:nowrap;">';
    htmlstr += '<div id="c' + z.product_id + '" style="position:relative;">' 
    htmlstr += '<img class="lazy new" data-original="'+ z.pic_url +'" style="display:inline;">';
    htmlstr += '<div id="cv' + z.product_id + '" style="display:inline;height:104px;width:104px"></div>';
    htmlstr += '</div>' 
    htmlstr += '</div>';
    htmlstr += '<div class="c-content">';
    htmlstr += '<div class="price-area">';
    htmlstr += '<span class="s1">￥</span>';
    htmlstr += '<span class="s2">' + z.discount + '</span>';
    htmlstr += '<span class="s3">满' + z.quota + '元可用</span>';
    htmlstr += '</div>';
    htmlstr += '<div class="c-desc">';
    htmlstr += '<p class="b">' + z.mall_name +'</p>';
    htmlstr += '<img src="/img/jd_logo.png"/>';
    htmlstr += '</div>';
    htmlstr += '</div>';
    htmlstr += '<div class="lingquan">立即领券</div>';
    htmlstr += '</div>';
    htmlstr += '</a>';
  }
  htmlstr = $(htmlstr);
  obj.append(htmlstr);
  Util.lazyLoad('lazy.new');
  $('.lazy.new').removeClass('new');
}

Util.createJdShopCoupon = function(cl,obj,channel,gaPage){
  gaPage = gaPage || '未知';
  var htmlstr = '';
  for(var i=0,len=cl.length;i<len;i++){
    var c = cl[i];
    var curl = encodeURIComponent(c.coupon_url);
    for(var j=0; j < c.products.length ; j++){
      if(j >= 3){
        continue;
      }
      var z = c.products[j];
      var buy_url = "/jd/buy/" + z.item_id + '/?coupon=' + curl;
      var c_url = "/jd/buy_url/" + z.item_id + '/?coupon=' + curl;
      htmlstr += '<a href="'+ buy_url +'" target="_blank" onclick="_hmt.push([\'_trackEvent\', \'京券领取\', \'click\', \'jd\'])">';
      htmlstr += '<div class="jd-coupon">';
      htmlstr += '<div class="img" style="overflow:hidden;white-space:nowrap;">';
      htmlstr += '<div id="c' + z.item_id + '" style="position:relative;">' 
      htmlstr += '<img class="lazy new" data-original="'+ z.pict_url +'" style="display:inline;">';
      htmlstr += '<div id="cv' + z.item_id + '" style="display:inline;height:104px;width:104px"></div>';
      htmlstr += '</div>' 
      htmlstr += '</div>';
      htmlstr += '<div class="c-content">';
      htmlstr += '<div class="price-area">';
      htmlstr += '<span class="s1">￥</span>';
      htmlstr += '<span class="s2">' + c.discount + '</span>';
      htmlstr += '<span class="s3">满' + c.quota + '元可用</span>';
      htmlstr += '</div>';
      htmlstr += '<div class="c-small">';
      htmlstr += '<p style="height:46px;overflow:hidden;">' + z.title +'</p>';
      htmlstr += '<img src="/img/jd_logo.png" width="76px" height=38px" style="padding:0;margin:0;float:right;"/>';
      htmlstr += '</div>';
      htmlstr += '</div>';
      htmlstr += '<div class="lingquan">立即领券</div>';
      htmlstr += '</div>';
      htmlstr += '</a>';
    }
  }
  htmlstr = $(htmlstr);
  obj.append(htmlstr);
  Util.lazyLoad('lazy.new');
  $('.lazy.new').removeClass('new');
}
