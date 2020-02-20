class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  $cate_data = {}
  $hot_keywords_data = {}
  $banner_data = {}
  $coupon_9kuai9_data = {}
  $coupon_bang_data = {}
  $kk = [[1,'加湿器'],[17,'幼猫粮'],[20,'猫粮evo'],[33,'食品袋'],[55,'洗衣机'],[64,'宿舍锅'],[82,'棉衣男'],[86,'棉衣女'],[121,'毛衣女'],[123,'卫衣女'],[124,'棉服女'],[125,'袜子女'],[129,'短靴女'],[140,'温度计'],[153,'鞋袜'],[155,'地板袜'],[161,'鞋袜女'],[162,'鞋袜男'],[190,'婴儿床'],[191,'连衣裙'],[209,'外套'],[210,'外套男'],[211,'外套女'],[212,'夹克'],[226,'口红'],[229,'ysl口红'],[231,'mac口红'],[234,'唇膏'],[235,'tf口红'],[241,'口红管'],[242,'口红粉'],[257,'卫衣'],[258,'卫衣男'],[275,'鞋子女'],[277,'女鞋'],[280,'靴子女'],[287,'包包'],[288,'包包女'],[289,'女包'],[290,'小包包'],[292,'包包男'],[293,'双肩包'],[294,'男包'],[305,'火鸡面'],[307,'方便面'],[310,'螺蛳粉'],[317,'面膜'],[320,'面膜男'],[327,'ray面膜'],[329,'jm面膜'],[331,'snp面膜'],[332,'面膜粉'],[333,'面膜纸'],[334,'面膜碗'],[336,'面膜刷'],[358,'女卫衣'],[389,'素颜霜'],[402,'唇釉'],[403,'唇彩'],[407,'唇蜜'],[409,'ysl唇釉'],[419,'唇釉管'],[421,'眼影盘'],[423,'nyx眼影'],[425,'tf眼影'],[429,'3ce眼影'],[458,'宠物犬'],[484,'ck香水'],[497,'零食'],[503,'巧克力'],[504,'辣条'],[508,'小零食'],[521,'小礼物'],[562,'耳机'],[570,'耳麦'],[575,'耳机线'],[577,'耳机架'],[578,'眼影'],[581,'眼影笔'],[583,'眼影棒'],[585,'眼影刷'],[588,'小白鞋'],[592,'回力'],[607,'春装女'],[621,'圣罗兰'],[623,'迪奥'],[624,'纪梵希'],[625,'香奈儿'],[640,'男长裤'],[642,'毛衣男'],[643,'袜子男'],[644,'皮鞋男'],[646,'手套男'],[647,'帽子男'],[648,'棉鞋男'],[649,'围巾男'],[650,'皮带男'],[661,'水杯'],[662,'茶杯'],[664,'水杯女'],[672,'帽子'],[673,'帽子女'],[675,'鸭舌帽'],[676,'棒球帽'],[677,'贝雷帽'],[682,'绿帽子'],[701,'女鞋冬'],[705,'女靴'],[715,'洁面女'],[716,'洁面乳'],[726,'辣片'],[730,'亲嘴烧'],[738,'打底裤'],[743,'打底裙'],[745,'打底衣'],[785,'手表'],[786,'手表男'],[787,'手表女'],[809,'ysl气垫'],[829,'鞋垫'],[830,'鞋垫女'],[842,'棉鞋垫'],[844,'鞋垫冬'],[851,'连帽衫'],[863,'夹克男'],[865,'男卫衣'],[876,'高跟鞋'],[893,'单肩包'],[898,'mk女包'],[899,'lv女包'],[902,'ck女包'],[904,'女包包'],[906,'女包冬'],[907,'耐克'],[910,'李宁'],[911,'安踏'],[912,'彪马'],[913,'新百伦'],[914,'安德玛'],[916,'耐克鞋'],[929,'男衬衫'],[947,'充电宝'],[966,'手机壳'],[996,'洗面奶']]
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
    %w(包包 女鞋 鼠标 连衣裙 瑜伽垫 男T恤 女T恤 阔腿裤 女春装 打底裤 开衫)
    #if $hot_keywords_data["update_at"].nil? || $hot_keywords_data["keywords"].nil? || $hot_keywords_data["keywords"].size.zero? || Time.now.to_i - $hot_keywords_data["update_at"] > 3600
    #  url = "http://api.uuhaodian.com/uu/hot_keywords"
    #  result = Net::HTTP.get(URI(url))
    #  json = JSON.parse(result)
    #  if json["status"] && json["status"]["code"] == 1001
    #    $hot_keywords_data["keywords"] = json["result"]
    #    $hot_keywords_data["update_at"] = Time.now.to_i
    #    return $hot_keywords_data["keywords"]
    #  else
    #    return []
    #  end
    #end
    #return $hot_keywords_data["keywords"]
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

  def set_cookie_channel
    if params[:channel] 
      cookies[:channel] = {value: params[:channel], expires: Time.now + 604800} 
    elsif params[:from]
      if params[:from] == "shikuai"
        cookies[:channel] = {value: "3", expires: Time.now + 604800} 
      elsif params[:from] == "iquan"
        cookies[:channel] = {value: "2", expires: Time.now + 604800} 
      elsif params[:from] == "m_shikuai"
        cookies[:channel] = {value: "9", expires: Time.now + 604800} 
      elsif params[:from] == "amp_shikuai"
        cookies[:channel] = {value: "9", expires: Time.now + 604800} 
      elsif params[:from] == "m_iquan"
        cookies[:channel] = {value: "8", expires: Time.now + 604800} 
      end
    end
  end

  def is_device_mobile?
    user_agent = request.headers["HTTP_USER_AGENT"]
    user_agent.present? && user_agent =~ /\b(Android|iPhone|Windows Phone|Opera Mobi|Kindle|BackBerry|PlayBook|UCWEB|Mobile)\b/i
  end

end
