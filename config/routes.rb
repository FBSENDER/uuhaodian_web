Rails.application.routes.draw do
  root "coupon#home"
  get "/category/:cid", to: "coupon#category", cid: /\d+/
  get "/collection/:tid", to: "coupon#collection", tid: /\d+/
  get "/yh/:id", to: "coupon#product_detail", id: /\d+/
  get "/sp/:id", to: "coupon#video_detail", id: /\d+/
  get "/query/:keyword", to: "coupon#query"
  get "/like/", to: "coupon#like"
  get "/top/", to: "coupon#top"
  get "/brand/", to: "coupon#brand"
  get "/app/", to: "coupon#app"
  get "/douyintongkuan/", to: "coupon#video_list"
end
