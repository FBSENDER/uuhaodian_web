Rails.application.routes.draw do
  root "coupon#home"
  get "/category/:cid", to: "coupon#category", cid: /\d+/
  get "/collection/:tid", to: "coupon#collection", tid: /\d+/
  get "/yh/:id", to: "coupon#product_detail", id: /\d+/
  get "/sp/:id", to: "coupon#video_detail", id: /\d+/
  get "/query/:keyword", to: "coupon#query", keyword: /.+/
  get "/like/", to: "coupon#like"
  get "/top/", to: "coupon#top"
  get "/brand/", to: "coupon#brand"
  get "/app/", to: "coupon#app"
  get "/douyintongkuan/", to: "coupon#video_list"

  get "/dz/:keyword", to: "coupon#dazhe", keyword: /.+/
  get "/dz_search", to: "coupon#dazhe_search"
  get "/dr/:keyword", to: "coupon#dazhe_result", keyword: /.+/

  get "/dianpu/:name", to: "coupon#shop"
  get "/sshop/:name", to: "coupon#sem_shop"
end
