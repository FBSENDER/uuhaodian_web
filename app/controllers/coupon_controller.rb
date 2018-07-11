class CouponController < ApplicationController
  def not_found
    render "not_found", status: 404
  end
  def home
    @cates = get_cate_data
    @banners = get_banner_data
    @top_keywords = get_hot_keywords_data.sample(8)
    @items_9kuai9 = get_coupon_9kuai9_data
    @items_bang = get_coupon_bang_data
    @path = "http://api.uuhaodian.com/uu/home_list"
  end

  def like
    if cookies[:session_key].nil?
      redirect_to "/", status: 302
      return
    end
    #验证用户是否登录
    @path = "http://api.uuhaodian.com/uu/get_product_liked"
    @cates = get_cate_data
  end

  def category
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
    @path = "http://api.uuhaodian.com/uu/home_list"
  end

  def product_detail
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
        not_found if json["status"]["code"] != 1001 || json["result"].nil?
      end
      url_recommend = "http://api.uuhaodian.com/uu/tb_goods_recommend?item_id=#{params[:id]}"
      result_recommend = Net::HTTP.get(URI(url_recommend))
      r_json = JSON.parse(result_recommend)
      if r_json["status"] == 2
        @items = r_json["results"]
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
    @top_keywords = get_hot_keywords_data.sample(8)
    @path = "http://api.uuhaodian.com/uu/goods_list"
  end

  def query
    @keyword = params[:keyword]
    if @keyword.include?('http') || @keyword.include?("taobao") || @keyword.include?("tmall")
      redirect_to URI.encode("https://www.iquan.net/tbzk/?keyword=#{@keyword}"), status: 302
      return
    end
    @cates = get_cate_data
    #@keywords = get_hot_keywords_data.sample(10)
    @top_keywords = get_hot_keywords_data.sample(8)
    @path = "http://api.uuhaodian.com/uu/goods_list"
    if @keyword.size >= 10
      @path = "http://api.uuhaodian.com/uu/tb_goods_list"
    end
  end

  def collection
    @collection_type = params[:tid].to_i 
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
end
