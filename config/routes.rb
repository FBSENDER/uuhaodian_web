Rails.application.routes.draw do
  root "coupon#wap_home", constraints: {host: "wap.uuhaodian.com"}
  root "car#index", constraints: {host: "car.uuhaodian.com"}
  root "coupon#home"
  get "/article/:id.html", to: "article#show"
  get "/article/tag_:tag", to: "article#list"
  get "/about.html", to: "coupon#about"
  get "/category/:cid", to: "coupon#category", cid: /\d+/
  get "/collection/:tid", to: "coupon#collection", tid: /\d+/
  get "/yh/:id", to: "coupon#product_detail", id: /\d+/
  get "/dtk/:id", to: "coupon#dtk_product_detail", id: /\d+/
  get "/ddk/:id", to: "coupon#ddk_product_detail", id: /\d+/
  get "/ddk/buy/:id", to: "coupon#ddk_buy", id: /\d+/
  get "/ddk/buy_url/:id", to: "coupon#ddk_buy_url", id: /\d+/
  get "/jd/", to: "coupon#jd_lingquan"
  get "/jd/:id", to: "coupon#jd_product_detail", id: /\d+/
  get "/jdhh/:id", to: "coupon#haohuo", id: /\d+/
  get "/jd/buy/:id", to: "coupon#jd_buy", id: /\d+/
  get "/jd/buy_url/:id", to: "coupon#jd_buy_url", id: /\d+/
  get "/jdshop/:id", to: "coupon#jd_shop", id: /\d+/
  get "/jdshop_go/:id", to: "coupon#jd_shop_go", id: /\d+/
  get "/jshops", to: "coupon#jd_shops"
  get "/jshops/:cate", to: "coupon#jd_shops_cate"
  get "/jshops/:cate/ziying", to: "coupon#jd_shops_cate_ziying"
  get "/jshops/:cate/:page", to: "coupon#jd_shops_cate", page: /\d+/
  get "/jshop_:id.html", to: "coupon#jd_shop_seo", id: /\d+/
  get "/tshop_:id.html", to: "coupon#dtk_shop_seo", id: /\d+/
  get "/jddiybuy", to: "coupon#jd_diy_buy"
  #get "/sp/:id", to: "coupon#video_detail", id: /\d+/
  get "/query/:keyword", to: "coupon#query", keyword: /.+/
  get "/query_suggest", to: "coupon#query_suggest"
  get "/gy/:keyword", to: "coupon#gaoyong", keyword: /.+/
  get "/like/", to: "coupon#like"
  get "/top/", to: "coupon#top"
  get "/brand/", to: "coupon#brand"
  get "/app/", to: "coupon#app"
  get "/douyintongkuan/", to: "coupon#video_list"

  get "/wp/:id.html", to: "coupon#old_url_wp", id: /\d+/
  get "/ws/:id.html", to: "coupon#old_url_ws", id: /\d+/

  get "/dz/:keyword", to: "coupon#dazhe", keyword: /.+/
  get "/dz_search", to: "coupon#dazhe_search"
  get "/dr/:keyword", to: "coupon#dazhe_result", keyword: /.+/
  get "/dt/:id", to: "coupon#dazhe_monitor", id: /\d+/

  get "/dianpu/:name", to: "coupon#shop"
  get "/sshop/:name", to: "coupon#sem_shop"

  #car
  get "/car/brand/:id", to: "car#brand", constraints: {host: "car.uuhaodian.com"}
  get "/car/category/:id", to: "car#category", constraints: {host: "car.uuhaodian.com"}
  get "/car/series/:id", to: "car#series", constraints: {host: "car.uuhaodian.com"}
  get "/car/cd/:id", to: "car#cd", constraints: {host: "car.uuhaodian.com"}
  get "/car/cb-:cid-:bid", to: "car#cb", constraints: {host: "car.uuhaodian.com"}
  get "/car/cs-:cid-:sid", to: "car#cs", constraints: {host: "car.uuhaodian.com"}
  get "/car/product/:id", to: "car#product", constraints: {host: "car.uuhaodian.com"}
  get "/car/keyword", to: "car#keyword", constraints: {host: "car.uuhaodian.com"}

  #seo
  get "/core_1_:id", to: "coupon#core_tb", id: /\d+/
  get "/core_2_:id", to: "coupon#core_jd", id: /\d+/

  #en
  get "/en/", to: "en#home"
  get "/en/goods_:id", to: "en#goods", id: /\d+/
  get "/en/popular/:keyword", to: "en#popular"
  get "/en/new_release/:keyword", to: "en#new_release"


end
