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
end
