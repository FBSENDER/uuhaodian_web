class ArticleController < ApplicationController
  def show
    @id = params[:id].to_i
    url = "http://api.uuhaodian.com/uu/article?id=#{@id}"
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
    set_cookie_channel
    @top_keywords = get_hot_keywords_data.sample(7)
    @title = json["title"]
    @keywords = json["k"]
    @description = json["d"]
    @tags = json["tags"].split(',')
    @articles = json["more"]
    file = Rails.root.join("public/seo_articles").join("#{@id}.html")
    if !File.exists?(file)
      @content = ""
    else
      @content = File.read(file)
    end
    jd_seo_data = get_jd_seo_data
    @shops = []
    @cores = []
    @products = []
    if jd_seo_data["status"] == 1
      @shops = jd_seo_data["shops"]
      @cores = jd_seo_data["cores"]
      @products = jd_seo_data["products"]
    end
    if is_device_mobile?
      render :m_show, layout: "dazhe"
    else
      render :show, layout: "application"
    end
  end

  def list
    @tag = params[:tag]
    @articles = []
    url = "http://api.uuhaodian.com/uu/article_list?tag=#{@tag}"
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] == 1
        @articles = json["result"]
      else
        not_found
        return
      end
    rescue
    end
    set_cookie_channel
    @top_keywords = get_hot_keywords_data.sample(7)
    @title = "#{@tag}相关文章列表"
    @keywords = "#{@tag},#{@tag}优优好店"
    @description = "优优好店为您提供#{@tag}相关文章，查价格领优惠，就来优优好店。在优优好店可以查淘宝、京东、拼多多的优惠商品，可以相当的省钱呦，来关注我们的公众号吧！"
    jd_seo_data = get_jd_seo_data
    @shops = []
    @cores = []
    @products = []
    if jd_seo_data["status"] == 1
      @shops = jd_seo_data["shops"]
      @cores = jd_seo_data["cores"]
      @products = jd_seo_data["products"]
    end
    render :list, layout: "application"
  end
end
