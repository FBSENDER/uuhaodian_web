class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  $cate_data = {}
  $hot_keywords_data = {}
  $banner_data = {}
  def get_banner_data
    if $banner_data["update_at"].nil? || $banner_data["banners"].nil? || $banner_data["banners"].size.zero? || Time.now.to_i - $cate_data["update_at"] > 3600
      url = "http://api.uuhaodian.com/uu/banners"
      result = Net::HTTP.get(URI(url))
      json = JSON.parse(result)
      if json["status"]  == 1001
        $banner_data["banners"] = json["result"]
        $banner_data["update_at"] = Time.now.to_i
        return $banner_data["banners"]
      else
        return []
      end
    end
    return $banner_data["banners"]
  end
  def get_cate_data
    if $cate_data.nil? || $cate_data["update_at"].nil? || $cate_data["cate"].nil? || $cate_data["cate"].size.zero? || Time.now.to_i - $cate_data["update_at"] > 3600
      url = "http://api.uuhaodian.com/uu/category_list"
      result = Net::HTTP.get(URI(url))
      json = JSON.parse(result)
      if json["status"] && json["status"]["code"] == 1001
        $cate_data["cate"] = json["result"].sort{|a, b| a["cid"].to_i <=> b["cid"].to_i}
        $cate_data["update_at"] = Time.now.to_i
        return $cate_data["cate"]
      else
        return []
      end
    end
    return $cate_data["cate"]
  end

  def get_hot_keywords_data
    if $hot_keywords_data["update_at"].nil? || $hot_keywords_data["keywords"].nil? || $hot_keywords_data["keywords"].size.zero? || Time.now.to_i - $hot_keywords_data["update_at"] > 3600
      url = "http://api.uuhaodian.com/uu/hot_keywords"
      result = Net::HTTP.get(URI(url))
      json = JSON.parse(result)
      if json["status"] && json["status"]["code"] == 1001
        $hot_keywords_data["keywords"] = json["result"]
        $hot_keywords_data["update_at"] = Time.now.to_i
        return $hot_keywords_data["keywords"]
      else
        return []
      end
    end
    return $hot_keywords_data["keywords"]
  end
  def not_found
    raise ActionController::RoutingError.new('NOT FOUND')
  end
end
