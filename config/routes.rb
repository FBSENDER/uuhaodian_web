Rails.application.routes.draw do
  root "coupon#home"
  get "/category/:cid", to: "coupon#category", cid: /\d+/
  get "/collection/:tid", to: "coupon#collection", tid: /\d+/
  get "/yh/:id", to: "coupon#product_detail", id: /\d+/
  get "/query/:keyword", to: "coupon#query"
end
