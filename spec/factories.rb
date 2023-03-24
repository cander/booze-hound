FactoryBot.define do
  factory :olcc_store do
    store_num { "1016" }
    name { "Dallas" }
    location { "DALLAS" }
  end

  factory :olcc_bottle do
    new_item_code { "99900592775" }
    name { "BARCELO IMPERIAL" }
    old_item_code { "5927B" }
    category { "RUM" }
    size { "750 ML" }
    proof { 80.0 }
    age { "" }
    bottle_price { 11.22 }
  end
end
