class CouponController < ApplicationController
  def not_found
    render "not_found", status: 404
  end
  def wap_home
    set_cookie_channel

    @banners = get_banner_data
    @path = "https://api.uuhaodian.com/uu/home_list"
    @keyword = ''
    @kk = get_hot_keywords_data
    @items = []
    @path = "https://api.uuhaodian.com/uu/dg_goods_list"
    @keyword = @kk.sample
    render "wap_home", layout: "dazhe"
  end

  def home
    unless is_robot?
      for_shenhe_home
      puts "12312312"
      return
    end
    if is_device_mobile?
      redirect_to "http://wap.uuhaodian.com"
      return
    end
    set_cookie_channel

    file = Rails.root.join("public/seo_articles").join("uupc_home.html")
    if File.exists?(file) && !params[:is_refresh]
      render inline: File.read(file), layout: nil
      return
    end

    @cates = get_cate_data
    @banners = get_banner_data
    @top_keywords = get_hot_keywords_data.sample(7)
    @items_9kuai9 = get_coupon_9kuai9_data
    @path = "https://api.uuhaodian.com/uu/home_list"
    @keyword = ''
    #@kk = $kk.sample(20)
    @items = []
    home_page_json = get_home_page_json
    @dtks = home_page_json["dtk"]
    @jd_coupons = home_page_json["coupons"]
    @cores = home_page_json["cores"]
    @shops = home_page_json["jd_shops"]

    jd_seo_data = get_jd_seo_data
    @seo_shops = []
    @seo_cores = []
    @items_jd_static = []
    if jd_seo_data["status"] == 1
      @seo_shops = jd_seo_data["shops"]
      @seo_cores = jd_seo_data["cores"]
      @items_jd_static = jd_seo_data["products"]
    end

    @articles = []
    url = "http://api.uuhaodian.com/uu/article_list?tag=优惠券"
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] == 1
        @articles = json["result"]
      end
    rescue
    end
    
  end

  def like
    set_cookie_channel
    if cookies[:session_key].nil?
      redirect_to "/", status: 302
      return
    end
    #验证用户是否登录
    @path = "https://api.uuhaodian.com/uu/get_product_liked"
    @cates = get_cate_data
  end

  def for_shenhe_home
    @cid = "1325"
    @cates = get_cate_data
    @lanlan_category = @cates.select{|c| c["cid"] == @cid || c["cid"] == params[:cid_1]}.first
    if @lanlan_category.nil?
      not_found
      return
    end
    @category_name = params[:category_name] || @lanlan_category["name"]
    @path = "https://api.uuhaodian.com/uu/home_list"
    render "coupon/for_shenhe_home"
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
    @top_keywords = get_hot_keywords_data.sample(7)
    @items_bang = get_coupon_bang_data
    @path = "https://api.uuhaodian.com/uu/home_list"
    @kk = $kk.sample(20)
  end

  def product_detail
    if !is_robot? && request.referer && (URI(request.referer).path == "" || URI(request.referer).path == "/")
      redirect_to "https://api.uuhaodian.com/uu/pcbuy?id=#{params[:id]}"
      return
    end
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
      redirect_to "https://www.uuhaodian.com" + request.path
      return
    end
    if !@coupon_money.nil? && @coupon_money > 0 && @detail["couponMoney"].to_i == 0
      @detail["couponMoney"] = @coupon_money
      price = @detail["nowPrice"]
      @detail["nowPrice"] = @detail["nowPrice"].to_f - @coupon_money
      @detail["price"] = price
    end
    if @detail["auctionImages"].size < 6
      @detail["auctionImages"].unshift(@detail["coverImage"])
    end
    if @detail.nil?
      not_found
      return
    end
    @top_keywords = get_hot_keywords_data.sample(7)
    @path = "https://api.uuhaodian.com/uu/dg_goods_list"
    if is_device_mobile?
      render :m_product_detail, layout: "dazhe"
    end
  end

  def dtk_product_detail
    set_cookie_channel
    if is_device_mobile? && request.host != "wap.uuhaodian.com"
      redirect_to "http://wap.uuhaodian.com/dtk/#{params[:id]}/", status: 302
      return
    end
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
    @id = params[:id]
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
    @path = "https://api.uuhaodian.com/uu/dg_goods_list"
    @top_keywords = get_hot_keywords_data.sample(7)
    @jd_items = []
    @k = ''
    begin
      if cn = @detail["cnames"].split(',')
        if cn.size > 0
          @k = cn[-1]
          @jd_items = get_jd_open_search(@k)
        end 
      end
    rescue
    end
    if request.host == "wap.uuhaodian.com"
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
    if @detail["auctionImages"].size < 6
      @detail["auctionImages"].unshift(@detail["coverImage"])
    end
    @top_keywords = get_hot_keywords_data.sample(7)
    @path = "https://api.uuhaodian.com/uu/goods_list"
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

  def ddk_buy_url
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
        render json: {status: 1, id: params[:id], url: "https://p.pinduoduo.com/61pQKH5i"}, callback: params[:callback]
        return
      end
      render json: {status: 1, id: params[:id], url: json["result"]["short_url"]}, callback: params[:callback]
    rescue
      render json: {status: 0}, callback: params[:callback]
    end
  end

  def jd_lingquan
    if $jd_items["update_at"].nil? || $jd_items["items"].nil? || $jd_items["items"].size.zero? || Time.now.to_i - $jd_items["update_at"] > 3600
      url = "http://api.uuhaodian.com/jduu/jd_home_items"
      result = Net::HTTP.get(URI(url))
      json = JSON.parse(result)
      if json["status"] == 1
        @items = json["results"]
        $jd_items["items"] = json["results"]
        $jd_items["update_at"] = Time.now.to_i
        @jd_home_items = $jd_items["items"]
      else
        @jd_home_items = [
          {"id" => 1, "name" => '手机', "sort" => 1},
          {"id" => 2, "name" => '电视', "sort" => 2},
          {"id" => 3, "name" => '笔记本', "sort" => 3},
          {"id" => 4, "name" => '显示器', "sort" => 4},
          {"id" => 5, "name" => '空调', "sort" => 5},
          {"id" => 6, "name" => '冰箱', "sort" => 6},
          {"id" => 7, "name" => '路由器', "sort" => 7}
        ]
      end
    else
      @jd_home_items = $jd_items["items"]
    end
    @jd_item_id = params[:id].nil? ? 1 : params[:id].to_i
    @jd_home_items.each do |item|
      if item["id"] == @jd_item_id
        @jd_item = item
      end
    end
    @jd_item = @jd_home_items[0] if @jd_item.nil?
    @top_keywords = get_hot_keywords_data.sample(7)
    set_cookie_channel
    if is_device_mobile?
      render :dazhe_jd, layout: "dazhe"
      return
    end
  end

  def jd_product_detail
    url = "http://api.uuhaodian.com/jduu/product?id=#{params[:id]}"
    json = {}
    @items = []
    set_cookie_channel
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] != 200
        not_found
        return
      end
    rescue
      not_found
      return
    end
    @detail = json["result"]
    if @detail.nil?
      not_found
      return
    end
    @top_keywords = get_hot_keywords_data.sample(7)
    @path = "https://api.uuhaodian.com/uu/goods_list"
    if !is_robot? && is_device_mobile?
      redirect_to "/jd/buy/#{params[:id]}?coupon=#{URI.encode_www_form_component(@detail["coupon_url"])}"
      return
    end
  end

  def jd_static_product
    @id = params[:id]
    if is_device_mobile? && request.host != "wap.uuhaodian.com"
      redirect_to "http://wap.uuhaodian.com/jdhh/#{@id}/", status: 302
      return
    end
    url = "http://api.uuhaodian.com/jduu/zhinan_jd_static_products?id=#{@id}"
    json = {}
    @items = []
    set_cookie_channel
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] != 1
        not_found
        return
      end
    rescue
      not_found
      return
    end
    @detail = json["info"]
    @items = json["related"]
    @top_keywords = get_hot_keywords_data.sample(7)
    @path = "https://api.uuhaodian.com/uu/goods_list"
    @ks = []
    @items.each do |item|
      @ks += item["keywords"].map{|k| k[0]}
    end
    @jd_items = []
    @ks1 = @detail["ks1"]
    @ks2 = @detail["ks2"]
    @ks2.delete(" ")
    if @ks1.size > 0
      @jd_items = get_jd_open_search(@ks1[-1])
    end
    @ks = @ks1 + @ks.uniq.sample(10)
    if request.host == "wap.uuhaodian.com"
      render :dazhe_jd_static_product, layout: "dazhe"
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
    url = "http://api.uuhaodian.com/jduu/product_url?id=#{params[:id]}&jd_channel=#{cookies[:jd_channel]}"
    if params[:coupon]
      url = "http://api.uuhaodian.com/jduu/product_url?id=#{params[:id]}&jd_channel=#{cookies[:jd_channel]}&coupon=#{URI.encode_www_form_component(params[:coupon])}"
    end
    json = {}
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] != 200
        if params[:coupon]
          redirect_to "/jd/buy/#{params[:id]}/"
          return
        end
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
    url = "http://api.uuhaodian.com/jduu/product_url?id=#{params[:id]}&jd_channel=11"
    if params[:coupon]
      url = "http://api.uuhaodian.com/jduu/product_url?id=#{params[:id]}&jd_channel=11&coupon=#{URI.encode_www_form_component(params[:coupon])}"
    end
    json = {}
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] != 200
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
      @top_keywords = get_hot_keywords_data.sample(7)
      @error_message = '淘宝天猫商品，不支持搜索链接，请粘贴商品标题搜索'
      not_found
      return
    end
    if is_device_mobile?
      redirect_to "http://wap.uuhaodian.com/dz/#{URI.encode(params[:keyword])}/", status: 302
      return
    end
    set_cookie_channel
    @keyword = params[:keyword]
    if @keyword.size > 3 && @keyword[-3,3] == '优惠券'
      @keyword = @keyword[0..-4]
    end
    @top_keywords = get_hot_keywords_data.sample(7)
    @items_bang = get_coupon_bang_data
    @path = "https://api.uuhaodian.com/uu/dg_goods_list"
    url = "http://api.uuhaodian.com/uu/keyword_infos?keyword=#{URI.encode_www_form_component(@keyword)}"
    result = Net::HTTP.get(URI(url))
    json = JSON.parse(result)
    if json["status"] == 1
      @kk = json["result"]["r_keywords"] || []
    else
      @kk = []
    end
    @kk = @kk.sample(10)
    @jd_items = get_jd_open_search(@keyword)
  end

  def gaoyong
    if params[:platform] && [1,2,3].include?(params[:platform].to_i)
      cookies[:ff_platform] = {value: params[:platform].to_i, path: "/"}
    end
    if is_device_mobile?
      redirect_to "/dz/#{URI.encode(params[:keyword])}/", status: 302
      return
    end
    set_cookie_channel
    @keyword = params[:keyword]
    @top_keywords = get_hot_keywords_data.sample(7)
    @items_bang = get_coupon_bang_data
    @path = "https://api.uuhaodian.com/uu/dg_goods_list"
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
    @top_keywords = get_hot_keywords_data.sample(7)
    url = ""
    if @collection_type == 1
      @collection_name = "聚特卖"
      @mobile_url = "http://m.uuhaodian.com/index.php?r=index/brand"
      url = "https://api.uuhaodian.com/uu/temai_list"
    elsif @collection_type == 2
      @collection_name = "销量榜"
      url = "https://api.uuhaodian.com/uu/sale_list"
      @mobile_url = "http://m.uuhaodian.com/index.php?r=activity/sc#/fengqianglist"
    elsif @collection_type == 4
      @collection_name = "九块九包邮"
      @mobile_url = "http://m.uuhaodian.com/index.php?r=activity/sc#/ninePackageMail"
      url = "https://api.uuhaodian.com/uu/jiukuaijiu_list"
    else
      not_found
      return
    end
    if is_device_mobile?
      redirect_to @mobile_url
      return
    end
    @path = url
    @cates = get_cate_data
  end

  def top
    set_cookie_channel
    @cates = get_cate_data
    @top_keywords = get_hot_keywords_data.sample(7)
    @path = "https://api.uuhaodian.com/uu/home_list"
    @cid = params[:cid].nil? ? 0 : params[:cid].to_i
    cate = @cates.select{|item| item["cid"].to_i == @cid}.first
    @cate_name = cate.nil? ? '' : cate["name"]
    @is_top = true
  end

  def brand
    set_cookie_channel
    @cates = [
      {"cid" => 3761, "name" => "美食", "img_url"=> "https://qnoss1.lanlanlife.com/0a29c91c030c7d324c7651cddf7e31d2_126x126.png"},
      {"cid"=> 3767, "name"=> "女装", "img_url"=> "https://qnoss3.lanlanlife.com/de67fe83df5046ac7f3d6042120152c2_126x126.jpg"},
      {"cid"=> 3758, "name"=> "家居", "img_url"=> "https://qnoss.lanlanlife.com/5174917635791c5eb63bfe482d5fc175_126x126.jpg"},
      {"cid"=> 3763, "name"=> "美妆", "img_url"=> "https://qnoss.lanlanlife.com/bf45e751fc791ea6cbb743eaeb0d31c1_126x126.jpg"},
      {"cid"=> 3762, "name"=> "鞋包配饰", "img_url"=> "https://qnoss.lanlanlife.com/5a87f8a441028e199cba8af5188fc06f_126x126.jpg"},
      {"cid"=> 3765, "name"=> "内衣", "img_url"=> "https://qnoss1.lanlanlife.com/884bc36f08752afbc7d149205f8c1138_126x126.jpg"},
      {"cid"=> 3764, "name"=> "男装", "img_url"=> "https://qnoss2.lanlanlife.com/98d45a951aa5dca79fd3d251b625122e_126x126.jpg"},
      {"cid"=> 3760, "name"=> "母婴", "img_url"=> "https://qnoss2.lanlanlife.com/282cd239d5b99379edb68f3009a20c26_126x126.jpg"},
      {"cid"=> 3759, "name"=> "数码", "img_url"=> "https://qnoss2.lanlanlife.com/740886691d1c742a6a1c028d2c818271_126x126.jpg"}
    ]
    @top_keywords = get_hot_keywords_data.sample(7)
    @cid = params[:cid].nil? ? 3761 : params[:cid].to_i
    cate = @cates.select{|item| item["cid"].to_i == @cid}.first
    @cate_name = cate.nil? ? '' : cate["name"]
    @path = "https://api.uuhaodian.com/uu/tb_dg_list"
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
    @keyword = '抖音爆款'
  end

  def dazhe_monitor
    render :dazhe_monitor, layout: "dazhe"
  end

  def dazhe
    if params[:platform] && [1,2,3].include?(params[:platform].to_i)
      cookies[:ff_platform] = {value: params[:platform].to_i, path: "/"}
    end
    set_cookie_channel
    @channel = cookies[:channel]
    @keyword = params[:keyword]
    @items = []
    @device = mobile_device == 1 ? "ios" : "android" 
    @jd_items = []
    if is_robot?
      @jd_items = get_jd_open_search(@keyword)
    end
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
    @name = params[:name]
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

  def core_tb
    if is_device_mobile? && request.host != "wap.uuhaodian.com"
      redirect_to "http://wap.uuhaodian.com/core_1_#{params[:id]}/"
      return
    end
    url = "http://api.uuhaodian.com/jduu/core_keyword?id=#{params[:id]}"
    result = Net::HTTP.get(URI(url))
    r_json = JSON.parse(result)
    if r_json["status"] == 0
      not_found
      return
    end
    @top_keywords = get_hot_keywords_data.sample(7)
    @keyword = r_json["result"]["keyword"]
    @id = r_json["result"]["id"]
    @brands = r_json["result"]["brands"]
    @cates = r_json["result"]["cates"]
    @shops = r_json["result"]["shops"]
    @related = r_json["result"]["related_keywords"]
    cookies[:ff_platform] = {value: 1, path: "/"}
    if request.host == "wap.uuhaodian.com"
      render :dazhe_core_tb, layout: "dazhe"
      return
    end
  end

  def core_jd
    if is_device_mobile? && request.host != "wap.uuhaodian.com"
      redirect_to "http://wap.uuhaodian.com/core_2_#{params[:id]}/"
      return
    end
    url = "http://api.uuhaodian.com/jduu/core_keyword?id=#{params[:id]}"
    result = Net::HTTP.get(URI(url))
    r_json = JSON.parse(result)
    if r_json["status"] == 0
      not_found
      return
    end
    @top_keywords = get_hot_keywords_data.sample(7)
    @keyword = r_json["result"]["keyword"]
    @id = r_json["result"]["id"]
    @brands = r_json["result"]["brands"]
    @cates = r_json["result"]["cates"]
    @shops = r_json["result"]["shops"]
    @related = r_json["result"]["related_keywords"]
    cookies[:ff_platform] = {value: 2, path: "/"}
    if request.host == "wap.uuhaodian.com"
      render :dazhe_core_jd, layout: "dazhe"
      return
    end
  end

  def jd_shop
    @shop_id = params[:id].nil? ? 0 : params[:id].to_i
    if @shop_id == 0
      not_found
      return
    end
    if is_device_mobile? && request.host != "wap.uuhaodian.com"
      redirect_to "http://wap.uuhaodian.com/jdshop/#{@shop_id}/"
      return
    end
    set_cookie_channel
    url = "http://api.uuhaodian.com/jduu/jd_shop_json?shop_id=#{@shop_id}"
    result = Net::HTTP.get(URI(url))
    r_json = JSON.parse(result)
    if r_json["status"] == 0
      redirect_to "/jdshop_go/#{@shop_id}/"
      return
    end
    @top_keywords = get_hot_keywords_data.sample(7)
    @shop_name = r_json["result"]["shop_name"]
    @coupons = r_json["result"]["coupons"]
    @hot_products = r_json["result"]["hot_products"]
    @brands = r_json["result"]["brands"]
    @cid3s = r_json["result"]["cid3s"]
    @related = r_json["result"]["related"]
    cookies[:ff_platform] = {value: 2, path: "/"}
    if @brands.size > 0
      @keyword = @brands[0]["brand_name"]
    elsif @cid3s.size > 0
      @keyword = @cid3s[0]["cname3"]
    else
      @keyword = @shop_name
    end
    if request.host == "wap.uuhaodian.com"
      render :dazhe_shop_jd, layout: "dazhe"
      return
    end
  end

  def jd_shop_go
    shop_id = params[:id].nil? ? 0 : params[:id].to_i
    if shop_id == 0
      not_found
      return
    end
    if is_robot?
      render "not_found", status: 403
      return
    end
    url = "https://mall.jd.com/index-#{shop_id}.html"
    if is_device_mobile?
      url = "https://shop.m.jd.com/?shopId=#{shop_id}"
    end
    hurl = "http://api.uuhaodian.com/jduu/trans_diy_url?jd_channel=#{cookies[:jd_channel]}&url=#{URI.encode_www_form_component(url)}"
    result = Net::HTTP.get(URI(hurl))
    r_json = JSON.parse(result)
    if r_json["status"] == 200
      redirect_to r_json["data"]
    else
      not_found
      return
    end
  end

  def jd_shop_seo
    @shop_id = params[:id].nil? ? 0 : params[:id].to_i
    if @shop_id == 0
      not_found
      return
    end
    if is_device_mobile? && request.host != "wap.uuhaodian.com"
      redirect_to "http://wap.uuhaodian.com/jshop_#{@shop_id}.html"
      return
    end
    set_cookie_channel
    url = "http://api.uuhaodian.com/jduu/jd_shop_seo_json?shop_id=#{@shop_id}"
    result = Net::HTTP.get(URI(url))
    r_json = JSON.parse(result)
    if r_json["status"] == 0
      not_found
      return
    end
    @shop_name = r_json["result"]["shop_name"]
    @coupons = r_json["result"]["coupons"]
    @hot_products = r_json["result"]["products"]
    @brands = r_json["result"]["brands"]
    @cid3s = r_json["result"]["cid3s"]
    @top_keywords = @cid3s.map{|c| c["cname3"].split('/')[0]}
    @related = r_json["result"]["related"]
    cookies[:ff_platform] = {value: 2, path: "/"}
    if @brands.size > 0
      @keyword = @brands[0]["brand_name"]
      @top_keywords << @keyword
    elsif @cid3s.size > 0
      @keyword = @cid3s[0]["cname3"]
    else
      @keyword = @shop_name
    end
    @jd_items = get_jd_open_search(@shop_name)
    if @top_keywords.size < 7
      @top_keywords += get_hot_keywords_data.sample(7 - @top_keywords.size)
    else
      @top_keywords = @top_keywords.sample(7)
    end
    if request.host == "wap.uuhaodian.com"
      render :dazhe_shop_jd_seo, layout: "dazhe"
      return
    end
  end

  def dtk_shop_seo
    @shop_id = params[:id].nil? ? 0 : params[:id].to_i
    if @shop_id == 0
      not_found
      return
    end
    if is_device_mobile? && request.host != "wap.uuhaodian.com"
      redirect_to "http://wap.uuhaodian.com/tshop_#{@shop_id}.html"
      return
    end
    set_cookie_channel
    url = "http://api.uuhaodian.com/uu/dtk_shop_seo?shop_id=#{@shop_id}"
    result = Net::HTTP.get(URI(url))
    r_json = JSON.parse(result)
    if r_json["status"] == 0
      not_found
      return
    end
    @shop_name = r_json["result"]["shop_name"]
    @shop_type = r_json["result"]["shop_type"]
    @shop_logo = r_json["result"]["shop_logo"]
    @is_gold = r_json["result"]["is_gold"]
    @pd1 = r_json["result"]["pd1"]
    @pd2 = r_json["result"]["pd2"]
    @cnames = r_json["result"]["cnames"].split(',')
    @top_keywords = get_hot_keywords_data.sample(7)
    @related = r_json["result"]["shops"]
    @brand = r_json["result"]["brand_name"]
    @keyword = @brand.empty? ? @cnames[0] : @brand
    if request.host == "wap.uuhaodian.com"
      render :dazhe_shop_dtk_seo, layout: "dazhe"
      return
    end
  end

  def jd_diy_buy
    if is_robot?
      render "not_found", status: 403
      return
    end
    if params[:url].nil?
      not_found
      return
    end
    jd_channel = params[:jd_channel] || cookies[:jd_channel]
    hurl = "http://api.uuhaodian.com/jduu/trans_diy_url?jd_channel=#{jd_channel}&url=#{URI.encode_www_form_component(params[:url])}"
    result = Net::HTTP.get(URI(hurl))
    r_json = JSON.parse(result)
    if r_json["status"] == 200
      redirect_to r_json["data"]
    else
      not_found
      return
    end
  end

  def old_url
    if is_robot?
      not_found
      return
    end
    redirect_to "https://www.uuhaodian.com", status: 302
  end

  def old_url_wp
    redirect_to "http://www.17430.com.cn/wp/#{params[:id]}.html", status: 301
  end

  def old_url_ws
    redirect_to "http://www.17430.com.cn/ws/#{params[:id]}.html", status: 301
  end

  def get_jd_open_search(k)
    begin
      url = "http://api.uuhaodian.com/jduu/jd_open_search?keyword=#{URI.encode_www_form_component(k)}"
      result = Net::HTTP.get(URI(url))
      json = JSON.parse(result)
      if json["status"] == "OK" && json["result"]["items"]
        return json["result"]["items"]
      end
      return []
    rescue
      return []
    end
  end

end
