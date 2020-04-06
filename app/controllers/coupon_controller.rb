class CouponController < ApplicationController
  def not_found
    render "not_found", status: 404
  end
  def home
    if is_device_mobile?
      redirect_to "http://m.uuhaodian.com"
      return
    end
    #redirect_to "http://uuhaodian.com", status: 302
    set_cookie_channel
    @cates = get_cate_data
    @banners = get_banner_data
    @top_keywords = get_hot_keywords_data.sample(8)
    @items_9kuai9 = get_coupon_9kuai9_data
    @items_bang = get_coupon_bang_data
    @path = "http://api.uuhaodian.com/uu/home_list"
    @keyword = ''
    @kk = $kk.sample(20)
    @items = []
  end

  def like
    set_cookie_channel
    if cookies[:session_key].nil?
      redirect_to "/", status: 302
      return
    end
    #验证用户是否登录
    @path = "http://api.uuhaodian.com/uu/get_product_liked"
    @cates = get_cate_data
  end

  def category
    set_cookie_channel
    @cid = params[:cid]
    @cid_1 = params[:cid_1]
    @cates = get_cate_data
    @lanlan_category = @cates.select{|c| c["cid"] == @cid || c["cid"] == params[:cid_1]}.first
    if @lanlan_category.nil?
      not_found
      return
    end
    @category_name = params[:category_name] || @lanlan_category["name"]
    @top_keywords = get_hot_keywords_data.sample(8)
    @items_bang = get_coupon_bang_data
    @path = "http://api.uuhaodian.com/uu/home_list"
    @kk = $kk.sample(20)
  end

  def product_detail
    set_cookie_channel
    @channel = cookies[:channel]
    @coupon_money = params[:coupon_money].to_i
    url = "http://api.uuhaodian.com/uu/product?item_id=#{params[:id]}"
    json = {}
    @items = []
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"]["code"] != 1001 || json["result"].nil?
        url = "http://api.uuhaodian.com/uu/product_tb?item_id=#{params[:id]}"
        result = Net::HTTP.get(URI(URI.encode(url)))
        json = JSON.parse(result)
        if json["status"] == 0 || json["result"].nil? || json["status"]["code"] != 1001 
          not_found
          return
        end
      end
      unless is_device_mobile?
        url_recommend = "http://api.uuhaodian.com/uu/tb_goods_recommend?item_id=#{params[:id]}"
        result_recommend = Net::HTTP.get(URI(url_recommend))
        r_json = JSON.parse(result_recommend)
        if r_json["status"] == 2
          @items = r_json["results"]
        end
      end
    rescue
      not_found
      return
    end
    @detail = json["result"]
    if request.host == "uu.iquan.net" && @detail["couponMoney"].to_i == 0 && (@coupon_money.nil? || @coupon_money <= 0)
      redirect_to "http://www.uuhaodian.com" + request.path
      return
    end
    if !@coupon_money.nil? && @coupon_money > 0 && @detail["couponMoney"].to_i == 0
      @detail["couponMoney"] = @coupon_money
      price = @detail["nowPrice"]
      @detail["nowPrice"] = @detail["nowPrice"].to_f - @coupon_money
      @detail["price"] = price
    end
    if @detail["auctionImages"].size < 5
      @detail["auctionImages"].unshift(@detail["coverImage"])
    end
    if @detail.nil?
      not_found
      return
    end
    @top_keywords = get_hot_keywords_data.sample(8)
    @path = "http://api.uuhaodian.com/uu/dg_goods_list"
    if is_device_mobile?
      render :m_product_detail, layout: "dazhe"
    end
  end

  def dtk_product_detail
    set_cookie_channel
    @channel = cookies[:channel]
    url = "http://api.uuhaodian.com/uu/dtk_static_product?id=#{params[:id]}"
    json = {}
    @items = []
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
    rescue
      not_found
      return
    end
    if json["code"] != 0 || json["data"].nil?
      not_found
      return
    end
    @detail = json["data"]["product"]
    if @detail.nil?
      not_found
      return
    end
    @detail["shortTitle"] = @detail["dtitle"]
    @detail["itemId"] = @detail["goodsId"]
    @detail["coverImage"] = @detail["mainPic"]
    @detail["recommend"] = @detail["desc"]
    @detail["auctionImages"] = [@detail["mainPic"]]
    @detail["sellerName"] = @detail["shopName"]
    @detail["price"] = @detail["originalPrice"]
    @detail["nowPrice"] = @detail["actualPrice"]
    @detail["couponMoney"] = @detail["couponPrice"]
    @detail["couponEndTime"] = ''
    @detail["couponUrl"] = ''
    @items = json["data"]["related"]
    @path = "http://api.uuhaodian.com/uu/dg_goods_list"
    @top_keywords = get_hot_keywords_data.sample(8)
    if is_device_mobile?
      render :m_dtk_product_detail, layout: "dazhe"
    end
  end

  def ddk_product_detail
    url = "http://api.uuhaodian.com/ddk/product?id=#{params[:id]}"
    json = {}
    @items = []
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
    rescue
      not_found
      return
    end
    @detail = json["result"]
    if @detail.nil?
      not_found
      return
    end
    if @detail["auctionImages"].size < 5
      @detail["auctionImages"].unshift(@detail["coverImage"])
    end
    @top_keywords = get_hot_keywords_data.sample(8)
    @path = "http://api.uuhaodian.com/uu/goods_list"
  end

  def ddk_buy
    if is_robot?
      render "not_found", status: 403
      return
    end
    url = "http://api.uuhaodian.com/ddk/promotion_url?id=#{params[:id]}"
    json = {}
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] != 1
        not_found
        return
      end
      redirect_to json["result"]["we_app_web_view_short_url"], status: 302
    rescue
      not_found
      return
    end
  end

  def jd_lingquan
    @is_jd = 1
    @jd_cates = [
      { cid: 1, name: '精选' },
      { cid: 1620, name: '家居日用' },
      { cid: 1315, name: '服饰内衣' },
      { cid: 1316, name: '美妆护肤' },
      { cid: 16750, name: '个人护理' },
      { cid: 17329, name: '箱包皮具' },
      { cid: 15901, name: '家庭清洁' },
      { cid: 15248, name: '家纺' },
      { cid: 1318, name: '运动户外' },
      { cid: 670, name: '电脑办公' },
      { cid: 1320, name: '食品饮料' },
      { cid: 6144, name: '珠宝首饰' },
      { cid: 652, name: '数码' },
      { cid: 1713, name: '图书' },
      { cid: 9847, name: '家具' },
      { cid: 5025, name: '钟表' },
      { cid: 6994, name: '宠物' },
      { cid: 6196, name: '厨具' },
      { cid: 6233, name: '玩具乐器' },
      { cid: 737, name: '家用电器' },
      { cid: 6728, name: '汽车用品' },
      { cid: 9987, name: '手机配件' }
    ]
    @cid = params[:cid] ? params[:cid].to_i : 1
    @cname = ''
    if jc = @jd_cates.select{|c| c[:cid] == @cid}.first
      @cname = jc[:name]
    end
    @top_keywords = get_hot_keywords_data.sample(8)
    set_cookie_channel
    if is_device_mobile?
      render :dazhe_jd, layout: "dazhe"
      return
    end
  end

  def jd_product_detail
    url = "http://api.uuhaodian.com/ddk/jd_product?id=#{params[:id]}"
    json = {}
    @items = []
    set_cookie_channel
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status_code"] != 200
        not_found
        return
      end
    rescue
      not_found
      return
    end
    @detail = json["data"]
    if @detail.nil?
      not_found
      return
    end
    @detail["auctionImages"] = @detail["picurls"].split(',')
    @top_keywords = get_hot_keywords_data.sample(8)
    @path = "http://api.uuhaodian.com/uu/goods_list"
    if !is_robot? && is_device_mobile?
      redirect_to "/jd/buy/#{params[:id]}?coupon=#{URI.encode_www_form_component(@detail["couponurl"])}"
      return
    end
  end
  def jd_buy
    if is_robot?
      render "not_found", status: 403
      return
    end
    if params[:id].to_i < 10 && params[:coupon]
      redirect_to params[:coupon], status: 302
      return
    end
    url = "http://api.uuhaodian.com/ddk/jd_product_url?id=#{params[:id]}&jd_channel=#{cookies[:jd_channel]}"
    if params[:coupon]
      url = "http://api.uuhaodian.com/ddk/jd_product_url?id=#{params[:id]}&jd_channel=#{cookies[:jd_channel]}&coupon=#{URI.encode_www_form_component(params[:coupon])}"
    end
    json = {}
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status_code"] != 200
        not_found
        return
      end
      redirect_to json["data"], status: 302
    rescue
      not_found
      return
    end
  end

  def jd_buy_url
    if is_robot?
      render "not_found", status: 403
      return
    end
    if params[:id].to_i < 10 && params[:coupon]
      render json: {status: 1, id: params[:id], url: params[:coupon]}, callback: params[:callback]
      return
    end
    url = "http://api.uuhaodian.com/ddk/jd_product_url?id=#{params[:id]}&jd_channel=#{cookies[:jd_channel]}"
    if params[:coupon]
      url = "http://api.uuhaodian.com/ddk/jd_product_url?id=#{params[:id]}&jd_channel=#{cookies[:jd_channel]}&coupon=#{URI.encode_www_form_component(params[:coupon])}"
    end
    json = {}
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status_code"] != 200
        render json: {status: 1, id: params[:id], url: "https://item.jd.com/#{params[:id]}.html"}, callback: params[:callback]
        return
      end
      render json: {status: 1, id: params[:id], url: json["data"]}, callback: params[:callback]
    rescue
      render json: {status: 0}, callback: params[:callback]
    end
  end

  def query
    if params[:platform] && [1,2,3].include?(params[:platform].to_i)
      cookies[:ff_platform] = {value: params[:platform].to_i, path: "/"}
    end
    if params[:keyword] && params[:keyword].match(/\.jd\..*\d+\.html/)
      jdid = params[:keyword].match(/\d+/)[0]
      redirect_to "/jd/#{jdid}/", status: 302
      return
    end 
    if params[:keyword] && (params[:keyword].match(/taobao.com/) || params[:keyword].match(/tmall.com/))
      @top_keywords = get_hot_keywords_data.sample(8)
      @error_message = '淘宝天猫商品，不支持搜索链接，请粘贴商品标题搜索'
      not_found
      return
    end
    if is_device_mobile?
      redirect_to "/dz/#{URI.encode(params[:keyword])}/", status: 302
      return
    end
    set_cookie_channel
    @keyword = params[:keyword]
    @top_keywords = get_hot_keywords_data.sample(8)
    @items_bang = get_coupon_bang_data
    @path = "http://api.uuhaodian.com/uu/dg_goods_list"
    url = "http://api.uuhaodian.com/uu/keyword_infos?keyword=#{URI.encode_www_form_component(@keyword)}"
    result = Net::HTTP.get(URI(url))
    json = JSON.parse(result)
    if json["status"] == 1
      @kk = json["result"]["r_keywords"] || []
    else
      @kk = []
    end
    @kk = @kk.sample(10)
  end

  def collection
    set_cookie_channel
    @collection_type = params[:tid].to_i 
    @cid = params[:cid].nil? ? 0 : params[:cid].to_i
    @top_keywords = get_hot_keywords_data.sample(8)
    url = ""
    if @collection_type == 1
      @collection_name = "聚特卖"
      url = "http://api.uuhaodian.com/uu/temai_list"
    elsif @collection_type == 2
      @collection_name = "销量榜"
      url = "http://api.uuhaodian.com/uu/sale_list"
    elsif @collection_type == 4
      @collection_name = "九块九包邮"
      url = "http://api.uuhaodian.com/uu/jiukuaijiu_list"
    else
      not_found
      return
    end
    @path = url
    @cates = get_cate_data
  end

  def top
    set_cookie_channel
    @cates = get_cate_data
    @top_keywords = get_hot_keywords_data.sample(8)
    @path = "http://api.uuhaodian.com/uu/home_list"
    @cid = params[:cid].nil? ? 0 : params[:cid].to_i
    cate = @cates.select{|item| item["cid"].to_i == @cid}.first
    @cate_name = cate.nil? ? '' : cate["name"]
    @is_top = true
  end

  def brand
    set_cookie_channel
    @cates = [
      {"cid" => 3761, "name" => "美食", "img_url"=> "http://qnoss1.lanlanlife.com/0a29c91c030c7d324c7651cddf7e31d2_126x126.png"},
      {"cid"=> 3767, "name"=> "女装", "img_url"=> "http://qnoss3.lanlanlife.com/de67fe83df5046ac7f3d6042120152c2_126x126.jpg"},
      {"cid"=> 3758, "name"=> "家居", "img_url"=> "http://qnoss.lanlanlife.com/5174917635791c5eb63bfe482d5fc175_126x126.jpg"},
      {"cid"=> 3763, "name"=> "美妆", "img_url"=> "http://qnoss.lanlanlife.com/bf45e751fc791ea6cbb743eaeb0d31c1_126x126.jpg"},
      {"cid"=> 3762, "name"=> "鞋包配饰", "img_url"=> "http://qnoss.lanlanlife.com/5a87f8a441028e199cba8af5188fc06f_126x126.jpg"},
      {"cid"=> 3765, "name"=> "内衣", "img_url"=> "http://qnoss1.lanlanlife.com/884bc36f08752afbc7d149205f8c1138_126x126.jpg"},
      {"cid"=> 3764, "name"=> "男装", "img_url"=> "http://qnoss2.lanlanlife.com/98d45a951aa5dca79fd3d251b625122e_126x126.jpg"},
      {"cid"=> 3760, "name"=> "母婴", "img_url"=> "http://qnoss2.lanlanlife.com/282cd239d5b99379edb68f3009a20c26_126x126.jpg"},
      {"cid"=> 3759, "name"=> "数码", "img_url"=> "http://qnoss2.lanlanlife.com/740886691d1c742a6a1c028d2c818271_126x126.jpg"}
    ]
    @top_keywords = get_hot_keywords_data.sample(8)
    @cid = params[:cid].nil? ? 3761 : params[:cid].to_i
    cate = @cates.select{|item| item["cid"].to_i == @cid}.first
    @cate_name = cate.nil? ? '' : cate["name"]
    @path = "http://api.uuhaodian.com/uu/tb_dg_list"
    @is_brand = true
  end

  def app
    redirect_to "http://apphtml.ffquan.com/index.php?r=index/down&app_id=550416?t=1532259944"
  end

  def video_detail
    url = "http://api.uuhaodian.com/uu/video?id=#{params[:id]}"
    @video = {}
    @video_items = []
    @videos = []
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] == 1
        @video = json["result"]["video"]
        item_ids = json["result"]["product_ids"]
        if item_ids.size > 0
          url_1 = "http://api.uuhaodian.com/uu/product_tbs?item_ids=#{item_ids.join(',')}"
          result_1 = Net::HTTP.get(URI(URI.encode(url_1)))
          json_1 = JSON.parse(result_1)
          if json_1["status"] == 2
            @video_items = json_1["result"]
          end
        end
      else
        not_found
      end
    rescue Exception => ex
      not_found
      return
    end
    begin
      url_2 = "http://api.uuhaodian.com/uu/video_list"
      result_2 = Net::HTTP.get(URI(URI.encode(url_2)))
      json_2 = JSON.parse(result_2)
      if json_2["status"] == 1
        @videos = json_2["result"]
      end
    rescue
    end
  end

  def video_list
    @videos = []
    url = "http://api.uuhaodian.com/uu/video_list"
    result = Net::HTTP.get(URI(URI.encode(url)))
    json = JSON.parse(result)
    if json["status"] == 1
      @videos = json["result"]
    end
  end

  def dazhe
    if params[:platform] && [1,2,3].include?(params[:platform].to_i)
      cookies[:ff_platform] = {value: params[:platform].to_i, path: "/"}
    end
    set_cookie_channel
    @channel = cookies[:channel]
    @keyword = params[:keyword]
    #url = "http://api.uuhaodian.com/uu/goods_list?keyword=#{@keyword}"
    #result = Net::HTTP.get(URI(URI.encode(url)))
    #json = JSON.parse(result)
    @items = []
    @device = mobile_device == 1 ? "ios" : "android" 
    render :dazhe, layout: "dazhe"
  end

  def dazhe_result
    if params[:platform] && [1,2,3].include?(params[:platform].to_i)
      cookies[:ff_platform] = {value: params[:platform].to_i, path: "/"}
    end
    if params[:keyword] && params[:keyword].match(/\.jd\..*\d+\.html/)
      jdid = params[:keyword].match(/\d+/)[0]
      redirect_to "/jd/#{jdid}/", status: 302
      return
    end 
    set_cookie_channel
    @channel = cookies[:channel]
    @keyword = params[:keyword]
    @device = mobile_device == 1 ? "ios" : "android" 
    render :dazhe_result, layout: "dazhe"
  end

  def dazhe_search
    @keywords = get_hot_keywords_data.sample(20)
    @device = mobile_device == 1 ? "ios" : "android" 
    @cats = [
      {id: 4, k: "家居日用"},
      {id: 6, k: "美食"},
      {id: 2, k: "母婴"},
      {id: 3, k: "美妆"},
      {id: 1, k: "女装"},
      {id: 8, k: "数码家电"},
      {id: 7, k: "文娱车品"},
      {id: 10, k: "内衣"},
      {id: 14, k: "家装家纺"},
      {id: 5, k: "鞋品"},
      {id: 9, k: "男装"},
      {id: 12, k: "配饰"},
      {id: 13, k: "户外运动"},
      {id: 11, k: "箱包"}
    ]
    @topics = [
    ]
    render :dazhe_search, layout: "dazhe"
  end

  def shop
    url = "http://api.uuhaodian.com/uu/shop?name=#{URI.encode_www_form_component(params[:name])}"
    result = Net::HTTP.get(URI(url))
    json = JSON.parse(result)
    if json["status"] == 0
      not_found
      return
    end
    @shop = json["result"]["shop"]
    @keyword = @shop["keyword"]
    @shop_id = @shop["source_id"]
    @items = []
    @device = mobile_device == 1 ? "ios" : "android" 
    render :dian, layout: "dazhe"
  end

  def sem_shop
    url = "http://api.uuhaodian.com/uu/shop?name=#{URI.encode_www_form_component(params[:name])}"
    result = Net::HTTP.get(URI(url))
    json = JSON.parse(result)
    if json["status"] == 0
      not_found
      return
    end
    @shop = json["result"]["shop"]
    @shop_id = @shop["source_id"]
    @items = []
    @device = mobile_device == 1 ? "ios" : "android" 
    render :sem_shop, layout: "dazhe"
  end

  def query_suggest
    begin
      url = "http://m.uuhaodian.com/index.php?r=index/kwarr&kw=#{URI.encode_www_form_component(params[:kw])}"
      result = Net::HTTP.get(URI(url))
      render json: result
    rescue
      render json: {status: 0}
    end
  end
end
