# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command,
# db:seed:replant, or created alongside the database with db:setup.
#
# OlccBottle models from test/fixtures/olcc_bottles.yml
small_batch = OlccBottle.create( # standard:disable Lint/UselessAssignment
  {:new_item_code => "99900621975", "name" => "1792 SMALL BATCH 8 YR", "old_item_code" => "6219B", "category" => "DOMESTIC WHISKEY", "size" => "750 ML", "proof" => 93.7, "age" => "8 yrs"}
)
pipe_dream = OlccBottle.create(
  {:new_item_code => "99900654675", "name" => "REDWOOD EMPIRE PIPE DREAM", "old_item_code" => "6546B", "category" => "DOMESTIC WHISKEY", "size" => "750 ML", "proof" => 90.0, "age" => ""}
)
barcelo = OlccBottle.create(
  {:new_item_code => "99900592775", "name" => "BARCELO IMPERIAL", "old_item_code" => "5927B", "category" => "RUM", "size" => "750 ML", "proof" => 80.0, "age" => ""}
)
black_tot = OlccBottle.create(
  {:new_item_code => "99900924275", "name" => "BLACK TOT", "old_item_code" => "9242B", "category" => "RUM", "size" => "750 ML", "proof" => 92.4, "age" => ""}
)
#
# OlccStore models from test/fixtures/olcc_stores.yml
dallas = OlccStore.create(
  {:store_num => "1016", "name" => "Dallas", "location" => "Dallas", "address" => "170 W Ellendale Ste 105", "zip" => 97338, "telephone" => "503-623-9668", "store_hours" => "whenever"}
)
independence = OlccStore.create(
  {:store_num => "1054", "name" => "Independence", "location" => "Independence", "address" => "1353 Monmouth St", "zip" => 97351, "telephone" => "503-838-1941", "store_hours" => "whenever"}
)
bend3 = OlccStore.create(
  {:store_num => "1273", "name" => "Bend, 3rd St", "location" => "Bend", "address" => "740 NE Third St Ste 5", "zip" => 97701, "telephone" => "541-797-0028", "store_hours" => "Mon-Sat 10-8; Sun 11-7"}
)
#
# OlccInventory models from test/fixtures/olcc_inventories.yml
pipe_dream_dallas = OlccInventory.create( # standard:disable Lint/UselessAssignment
  {"quantity" => 7, "olcc_store" => dallas, "olcc_bottle" => pipe_dream}
)
black_tot_dallas = OlccInventory.create( # standard:disable Lint/UselessAssignment
  {"quantity" => 0, "olcc_store" => dallas, "olcc_bottle" => black_tot}
)
pipe_dream_independence = OlccInventory.create( # standard:disable Lint/UselessAssignment
  {"quantity" => 3, "olcc_store" => independence, "olcc_bottle" => pipe_dream}
)
barcelo_independence = OlccInventory.create( # standard:disable Lint/UselessAssignment
  {"quantity" => 4, "olcc_store" => independence, "olcc_bottle" => barcelo}
)
barcelo_bend = OlccInventory.create( # standard:disable Lint/UselessAssignment
  {"quantity" => 14, "olcc_store" => bend3, "olcc_bottle" => barcelo}
)
