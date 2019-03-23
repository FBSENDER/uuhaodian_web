class CouponController < ApplicationController
  def not_found
    render "not_found", status: 404
  end
  def home
    #redirect_to "http://uuhaodian.com", status: 302
    set_cookie_channel
    @cates = get_cate_data
    @banners = get_banner_data
    @top_keywords = get_hot_keywords_data.sample(8)
    @items_9kuai9 = get_coupon_9kuai9_data
    @items_bang = get_coupon_bang_data
    #@path = "http://api.uuhaodian.com/uu/home_list"
    @path = "http://api.uuhaodian.com/uu/goods_list"
    @keyword = '男装'
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
        url = "http://api.uuhaodian.com/uu/product_db?item_id=#{params[:id]}"
        result = Net::HTTP.get(URI(URI.encode(url)))
        json = JSON.parse(result)
        if json["status"] == 0 
          url = "http://api.uuhaodian.com/uu/product_tb?item_id=#{params[:id]}"
          result = Net::HTTP.get(URI(URI.encode(url)))
          json = JSON.parse(result)
          not_found if json["result"].nil? || json["status"]["code"] != 1001
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
    @path = "http://api.uuhaodian.com/uu/goods_list"
    if is_device_mobile?
      render :m_product_detail, layout: "dazhe"
    end
  end

  def query
    set_cookie_channel
    @keyword = params[:keyword]
    #if @keyword.include?('http') || @keyword.include?("taobao") || @keyword.include?("tmall")
    #  redirect_to "https://www.iquan.net/tbzk/?keyword=#{URI.encode_www_form_component(@keyword)}", status: 302
    #  return
    #end
    @cates = get_cate_data
    #@keywords = get_hot_keywords_data.sample(10)
    @top_keywords = get_hot_keywords_data.sample(8)
    @items_bang = get_coupon_bang_data
    @path = "http://api.uuhaodian.com/uu/goods_list"
    if @keyword.size >= 10
      @path = "http://api.uuhaodian.com/uu/tb_goods_list"
    end
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
      {"cid" => 3761, "name" => "美食", "img_url"=> "http://oss3.lanlanlife.com/ab30e09ed1072851ff723074e34a3a49_126x126.png"},
      {"cid"=> 3767, "name"=> "女装", "img_url"=> "http://oss2.lanlanlife.com/e8aa20c6ba198967fffdeb479903a22c_126x126.png"},
      {"cid"=> 3758, "name"=> "家居", "img_url"=> "http://oss2.lanlanlife.com/9ab88dded485353f3f35c5d0eb54f296_126x126.png"},
      {"cid"=> 3763, "name"=> "美妆", "img_url"=> "http://oss2.lanlanlife.com/22ef7dd24a4e1d4f9248e988349536b6_126x126.png"},
      {"cid"=> 3762, "name"=> "鞋包配饰", "img_url"=> "http://oss3.lanlanlife.com/3eb2d6f410443c288e5682e445db20d1_126x126.png"},
      {"cid"=> 3765, "name"=> "内衣", "img_url"=> "http://oss2.lanlanlife.com/e81fda4ee7f33c8723dc2c87204bc92a_126x126.png"},
      {"cid"=> 3764, "name"=> "男装", "img_url"=> "http://oss.lanlanlife.com/bf3bac5f430f6eb64b508cc524350976_126x126.png"},
      {"cid"=> 3760, "name"=> "母婴", "img_url"=> "http://oss2.lanlanlife.com/fccdeeb51c7ac0d6d90607031c1f8414_126x126.png"},
      {"cid"=> 3759, "name"=> "数码", "img_url"=> "http://oss1.lanlanlife.com/57f40d4d1baf8a8115548bebb2964a0c_126x126.png"}
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
      puts ex
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
    set_cookie_channel
    @channel = cookies[:channel]
    @keyword = params[:keyword]
    @device = mobile_device == 1 ? "ios" : "android" 
    render :dazhe_result, layout: "dazhe"
  end

  def dazhe_search
    @keywords = %w(连衣裙 内裤 睡衣 小白鞋 防晒霜 卸妆水 雨伞 零食 雨衣)
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
end
