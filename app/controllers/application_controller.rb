class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  $cate_data = {}
  $hot_keywords_data = {}
  $banner_data = {}
  $coupon_9kuai9_data = {}
  $coupon_bang_data = {}
  def get_banner_data
    if $banner_data["update_at"].nil? || $banner_data["banners"].nil? || $banner_data["banners"].size.zero? || Time.now.to_i - $banner_data["update_at"] > 3600
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
        $cate_data["cate"].each do |c|
          c["img_url"] = c["list"][0]["image"]
        end
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

  def get_coupon_9kuai9_data
    if $coupon_9kuai9_data["update_at"].nil? || $coupon_9kuai9_data["items"].nil? || $coupon_9kuai9_data["items"].size.zero? || Time.now.to_i - $coupon_9kuai9_data["update_at"] > 3600
      url = "http://api.uuhaodian.com/uu/jiukuaijiu_list"
      result = Net::HTTP.get(URI(url))
      json = JSON.parse(result)
      if json["status"] && json["status"]["code"] == 1001
        $coupon_9kuai9_data["items"] = json["result"]
        $coupon_9kuai9_data["update_at"] = Time.now.to_i
        return $coupon_9kuai9_data["items"]
      else
        return []
      end
    end
    return $coupon_9kuai9_data["items"]
  end

  def get_coupon_bang_data
    if $coupon_bang_data["update_at"].nil? || $coupon_bang_data["items"].nil? || $coupon_bang_data["items"].size.zero? || Time.now.to_i - $coupon_bang_data["update_at"] > 3600
      url = "http://api.uuhaodian.com/uu/sale_list"
      result = Net::HTTP.get(URI(url))
      json = JSON.parse(result)
      if json["status"] && json["status"]["code"] == 1001
        $coupon_bang_data["items"] = json["result"]
        $coupon_bang_data["update_at"] = Time.now.to_i
        return $coupon_bang_data["items"]
      else
        return []
      end
    end
    return $coupon_bang_data["items"]
  end

  def not_found
    raise ActionController::RoutingError.new('NOT FOUND')
  end

  def mobile_device
    # 1 ios  2 androd
    user_agent = request.headers["HTTP_USER_AGENT"]
    if user_agent.present? && user_agent =~ /(iphone|ipad|ipod)/i
      return 1
    else
      return 2
    end 
  end
end
