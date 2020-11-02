class CouponController < ApplicationController
  def not_found
    render "not_found", status: 404
  end
  def home
    if is_device_mobile?
      redirect_to "http://m.uuhaodian.com"
      #redirect_to "http://uuhaodian.haozhia.cc/"
      return
    end
    #redirect_to "http://uuhaodian.com", status: 302
    set_cookie_channel
    @cates = get_cate_data
    @banners = get_banner_data
    @top_keywords = get_hot_keywords_data.sample(7)
    @items_9kuai9 = get_coupon_9kuai9_data
    @items_jd_static = [{"id" => 3,"title" => "柏云森 双重隔板 储物床","price_info" => "558.0元","pic_url" => "https://m.360buyimg.com/ceco/jfs/t16378/217/2173835764/374835/13bbedf9/5a96c8edN4fe0d171.jpg!q70.jpg"},{"id" => 4,"title" => "三星 Note20 Ultra 5G手机","price_info" => "9199.0元（京东自营 热卖1.1万件）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/149113/6/4603/71598/5f2a66ceEb2ada927/0afed4942dde8fab.jpg!q70.jpg"},{"id" => 5,"title" => "阿迪达斯 无痕橡胶 足球鞋","price_info" => "1283.04元","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/105860/28/19658/123082/5e9fd23eEa73456ba/02840c3e28b783a4.jpg!q70.jpg"},{"id" => 6,"title" => "旭福 高纯净易吸收 磷虾油","price_info" => "458.0元（京东自营）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/131650/26/5955/340581/5f27dd88E0e25fda9/6f715a0da21368e1.png"},{"id" => 7,"title" => "vivo S7 5G手机","price_info" => "2798.0元（京东自营 近期爆款 热卖2.0万件）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/122362/36/8850/47232/5f295bf6E5920468b/fdacbf3366737915.jpg!q70.jpg"},{"id" => 8,"title" => "美心 香滑浓郁 流心奶黄月饼","price_info" => "318.0元（需领东券30元 近期爆款）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/134604/6/5408/75161/5f1d3cc7E1b416ef0/04ecaddcf31f1bb7.jpg!q70.jpg"},{"id" => 9,"title" => "Puma 专项运动 板鞋","price_info" => "1499.0元（近期爆款）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/87080/4/18783/87499/5e992d2bE8ed08393/0bd11a9320c3bfdf.jpg!q70.jpg"},{"id" => 10,"title" => "3M 棱镜结构 车贴","price_info" => "699.0元（京东自营）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t3082/312/5158038116/477978/c3fcbd3e/58661421N509c5879.jpg!q70.jpg"},{"id" => 11,"title" => "阿迪达斯 轻薄简约 运动鞋","price_info" => "799.0元","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/114776/10/1080/63221/5e946152Ec77592c2/3ba256b6dd8458db.jpg!q70.jpg"},{"id" => 12,"title" => "三宅一生 针扣牛皮 男表","price_info" => "4390.0元（京东自营）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/128279/28/5715/89997/5ef7f5a4E21738d65/de12ffebf47a786d.jpg!q70.jpg"},{"id" => 13,"title" => "旭福 复合维生素 泡腾片","price_info" => "89.0元（京东自营 热卖1.2万件）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/127650/9/5039/144749/5ee9bcecEf92e5f7d/b687c312e60075be.jpg!q70.jpg"},{"id" => 14,"title" => "迪士尼 透气多隔层 书包","price_info" => "89.0元（京东自营）","pic_url" => "https://m.360buyimg.com/ceco/jfs/t1/134975/38/2263/213270/5ee60f60E37357811/e38ccdf3663e0be5.jpg!q70.jpg"},{"id" => 15,"title" => "美的 搪瓷易清洁内胆 电烤箱","price_info" => "429.0元（京东自营 热卖1.5万件）","pic_url" => "https://img20.360buyimg.com/ceco/jfs/t1/119619/37/3450/242468/5eaff34bE601381e7/55bac022b3ddcd8e.jpg!q70.jpg"},{"id" => 16,"title" => "全友 简约可伸缩 电脑桌","price_info" => "1116.0元","pic_url" => "https://img20.360buyimg.com/ceco/jfs/t1/131337/22/1927/55098/5ee03975Eacdba3d7/bd24f9023b419873.jpg!q70.jpg"},{"id" => 17,"title" => "小米 蓝牙便携 无线鼠标","price_info" => "89.0元（京东自营 热卖4.9万件）","pic_url" => "https://img20.360buyimg.com/ceco/jfs/t1/139292/30/152/58051/5edcdb75Eda7885ef/52c60bff4a2e2510.jpg!q70.jpg"},{"id" => 18,"title" => "格澜帝尔 玄关美式屏风门厅 酒柜","price_info" => "3750.0元","pic_url" => "https://img20.360buyimg.com/ceco/jfs/t1/140748/6/308/102395/5edf651bE48af48d7/f8edb1e4047a302a.jpg!q70.jpg"},{"id" => 19,"title" => "香可 现代简约 电脑桌","price_info" => "199.0元（京东自营）","pic_url" => "https://img20.360buyimg.com/ceco/jfs/t1/133307/26/1041/425624/5ed4ae4aE692d6ff1/fd848401de3942a6.jpg!q70.jpg"},{"id" => 20,"title" => "全友 现代简约 茶几电视柜组合套装","price_info" => "3091.0元","pic_url" => "https://img20.360buyimg.com/ceco/jfs/t1/97007/24/16491/214827/5e7d588bE38b76656/e5467a4a0569b93d.jpg!q70.jpg"}]
    @path = "http://api.uuhaodian.com/uu/home_list"
    @keyword = ''
    #@kk = $kk.sample(20)
    @items = []
    home_page_json = get_home_page_json
    @dtks = home_page_json["dtk"]
    @jd_coupons = home_page_json["coupons"]
    @cores = home_page_json["cores"]
    @shops = home_page_json["jd_shops"]
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
    @top_keywords = get_hot_keywords_data.sample(7)
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
    if @detail["auctionImages"].size < 6
      @detail["auctionImages"].unshift(@detail["coverImage"])
    end
    if @detail.nil?
      not_found
      return
    end
    @top_keywords = get_hot_keywords_data.sample(7)
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
    @path = "http://api.uuhaodian.com/uu/dg_goods_list"
    @top_keywords = get_hot_keywords_data.sample(7)
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
    if @detail["auctionImages"].size < 6
      @detail["auctionImages"].unshift(@detail["coverImage"])
    end
    @top_keywords = get_hot_keywords_data.sample(7)
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
    @path = "http://api.uuhaodian.com/uu/goods_list"
    if !is_robot? && is_device_mobile?
      redirect_to "/jd/buy/#{params[:id]}?coupon=#{URI.encode_www_form_component(@detail["coupon_url"])}"
      return
    end
  end

  def jd_static_product
    url = "http://api.uuhaodian.com/jduu/zhinan_jd_static_products?id=#{params[:id]}"
    @id = params[:id]
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
    @path = "http://api.uuhaodian.com/uu/goods_list"
    if !is_robot? && is_device_mobile?
      redirect_to "/jd/buy/#{@detail["sku"]}"
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
      redirect_to "/dz/#{URI.encode(params[:keyword])}/", status: 302
      return
    end
    set_cookie_channel
    @keyword = params[:keyword]
    if @keyword.size > 3 && @keyword[-3,3] == '优惠券'
      @keyword = @keyword[0..-4]
    end
    @top_keywords = get_hot_keywords_data.sample(7)
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
    @top_keywords = get_hot_keywords_data.sample(7)
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
    @top_keywords = get_hot_keywords_data.sample(7)
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
    @top_keywords = get_hot_keywords_data.sample(7)
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

  def core_tb
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
    if is_device_mobile?
      render :dazhe_core_tb, layout: "dazhe"
      return
    end
  end

  def core_jd
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
    if is_device_mobile?
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
    if is_device_mobile?
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
    redirect_to "http://www.uuhaodian.com", status: 302
  end

  def old_url_wp
    redirect_to "http://www.17430.com.cn/wp/#{params[:id]}.html", status: 301
  end

  def old_url_ws
    redirect_to "http://www.17430.com.cn/ws/#{params[:id]}.html", status: 301
  end

end
