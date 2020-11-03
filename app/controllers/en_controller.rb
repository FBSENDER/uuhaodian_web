class EnController < ApplicationController
  def not_found
    render "not_found", status: 404
  end

  def home
    @title = "Amazon and Aliexpress coupons, one click inquiry, free collection - uuhaodian"
    @description = "uuhaodian.com - now supports the inquiry and collection of Amazon coupons and Aliexpress coupons. You can get the coupons first and then place an order, which saves money and benefits!"
    @page_keywords = "uuhaodian,aliexpress coupon,amazon coupon"
    @path = "https://www.uuhaodian.com/en/"

    @ks = "mobile phone,pizex,Washing machine,headset,overcoat,loose coat,gym shoes,suit,Running shoes,Lunch box,a bag,Toys,sofa,Casual shoes,skate shoes,Basketball shoes,roll of paper,notebook,Powdered Milk,Wrist watch,Aromatherapy,Solid wood dining table,table,dining table and chair,Dining table and chair combination,Tables and chairs,tea table,Windbreaker,high-capacity,Elbow,Bracelet,Whisky,Vodka,Clear wine,imported wine,monitor,Key buckle,keyboard,Bluetooth headset,milk,man 's suit,tool,Gift box,Children's Toys,Pro,Ornaments,Ballast,Daddy shoes,Solid state drive,sound card,Sandals,leather shoes,Charger,Jacket,leather clothing,Sweater,heater,Lazy chair,Rocking chair,Sofa chair,Lazy sofa,Fabric sofa,Back flow censer,Incense burner,Refluxing fragrance,Aromatherapy oven,Pansy,Joss stick,Balance car,Scooter,Three piece set,Model,Backpack,knapsack,TV cabinet combination,Sofa bed,TV cabinet,Side table,furniture,Shoe cabinet,stool,Tea table TV cabinet,Table and chair combination,combination,Lockers,Leisure chair,cane chair,chair,Shoe changing stool,deck chair,Console Cabinet,screen,wine cabinet,Shelf,Console Tables,Side cabinet,Tea cabinet,The computer table,Porch,Wooden sofa,processor,CPU,host,a main board,radiator,Hard disk,Chassis,Memory,Power Supply,Video card,Computer chair,Electronic competition chair,Office chair,Desktop,Electronic competition table,Solid wood desk,bookshelf,Bookcase,Sideboard,Dining chair,mouse,Garage Kit,Ultraman,robot,loudspeaker box,Bluetooth audio,Bluetooth Speaker,sound,The song machine,Jewelry box,Music box,Horn comb,Nail clippers,Cosmetic mirror,comb,wooden comb,Wood carving,sandalwood,Incense,Agarwood,Sound box,Handlebar,Handball,Pendant,A piece,gourd,brave troops,Inkstone,computer,Casual pants,mlb,Jeans,shirt,Overalls,Leggings,Pant,sweatpants,Quick drying pants,Sports pants,Short sleeve,Polo shirt,Short sleeve T-shirt,Down Jackets,Western-style trousers,shorts,Long sleeves,Sunscreen clothing,Cotton,telescope,Torch,Tent,barbecue grill,Barbecue,peaked cap,Pocket,Mountaineering bag,Baseball cap,Slingshot,Flashlight,Shovel,Yoga suit,Yoga Mat,Fitness wear,Athletic Wear,Sports suit,Yoga Pants,Fitness pants,Sports vest,Sports underwear,Sports bra,Bras,Underwear,Dance shoes,Tights,Skin coat,canvas shoe,Sweatsuit,Sports cap,high-heeled shoes,Single shoes,Small white shoes,Bicycle,Electric vehicle,Children bicycle,Cognac,Brandy,Plum wine,Safety seat,hand basket,Sunscreen,Hiking shoes,Climbing shoes,Draw bar box,Sound package,Home theater,the echo wall,home audio,Power amplifier,Subwoofer,system,Electric piano,piano,Upright piano,Tricycle,automobile,swing car,Children's balance car,Walkers,garden cart,Children tricycle,Grill,Flat,air cushion,Basketball,Fan,Pedal,Apple,partition"

    url = "http://api.uuhaodian.com/jduu/zhinan_jd_static_en_products?id=1"
    @items = []
    begin
      result = Net::HTTP.get(URI(URI.encode(url)))
      json = JSON.parse(result)
      if json["status"] == 1
        @items = json["related"]
      end
    rescue
    end

    render "en/home", layout: "layouts/en"
  end

  def goods
    url = "http://api.uuhaodian.com/jduu/zhinan_jd_static_en_products?id=#{params[:id]}"
    @id = params[:id]
    json = {}
    @items = []
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
    @detail = json["info"]
    @items = json["related"]

    @title = "#{@detail["title"]} - uuhaodian"
    @description = "#{@detail["title"]},#{@detail["price_info"]},#{@detail["recommends"][0]} - uuhaodian"
    @page_keywords = "#{@detail["title"]},uuhaodian"
    @path = "https://www.uuhaodian.com/en/goods_#{@id}/"

    render "en/goods", layout: "layouts/en"
  end

  def popular
    url = "http://api.uuhaodian.com/jduu/zhinan_jd_en_keyword_1?keyword=#{params[:keyword].strip}"
    json = {}
    @items = []
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
    @keyword = json["keyword"].titleize
    @num = json["num"]
    @ks = json["ks"]
    @items = json["data"]

    @title = "Top 10 Best #{@keyword} in 2020 | Related Products, Promotion, Reference Price on Auuhaodian"
    @description = "Top 10 Best #{@keyword} in 2020, related products, promotion and reference price of #{@keyword}.#{@items.last["disc"]} - uuhaodian"
    @page_keywords = "#{@keyword},#{@ks.join(',')}"
    @path = "http://www.uuhaodian.com/en/popular/#{URI.encode(@keyword.downcase)}/"
    @h1 = "Top 10 Best #{@keyword} in 2020"

    render "en/popular", layout: "layouts/en"
  end

  def new_release
    url = "http://api.uuhaodian.com/jduu/zhinan_jd_en_keyword_2?keyword=#{params[:keyword].strip}"
    json = {}
    @items = []
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
    @keyword = json["keyword"].titleize
    @num = json["num"]
    @ks = json["ks"]
    @items = json["data"]

    @title = "New Releases In #{@keyword} | Related Products, Promotion, Reference Price on Auuhaodian"
    @description = "New releases in #{@keyword}, related products, promotion and reference price of #{@keyword}.#{@items.last["disc"]} - uuhaodian"
    @page_keywords = "#{@keyword},#{@ks.join(',')}"
    @path = "https://www.uuhaodian.com/en/new_release/#{URI.encode(@keyword.downcase)}/"
    @h1 = "New Releases In #{@keyword}"

    render "en/new_release", layout: "layouts/en"
  end
end
