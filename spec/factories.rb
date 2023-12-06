FactoryBot.define do
  factory :olcc_store do
    store_num { "1016" }
    name { "Dallas" }
    location { "DALLAS" }
  end

  factory :olcc_bottle do
    new_item_code { "99900592775" }
    description { "BARCELO IMPERIAL" }
    old_item_code { "5927B" }
    category { "RUM" }
    size { "750 ML" }
    proof { 80.0 }
    age { "" }
    bottle_price { 11.22 }
  end

  factory :olcc_inventory do
    quantity { 666 }
  end

  factory :user do
    first_name { "Joe" }
    last_name { "Tester" }
    email { "joe@test.com" }
    username { "joe" }
    password { "Testy McTester" }
  end

  factory :bottle_event do
    event_type { "NEW BOTTLE" }
    new_item_code { "112233" }
  end
end
