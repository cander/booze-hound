# A simple data transfer object (DTO) for inventory data
# The attribute names match the attributes on the corresponding models

module Dto
  InventoryData = Data.define(:new_item_code, :store_num, :quantity)
  StoreData = Data.define(:store_num, :location, :address, :zip, :telephone, :store_hours)
  # NB - hack: name becomes name and description in the model
  BottleData = Data.define(:new_item_code, :old_item_code, :name, :size, :proof, :age, :category, :bottle_price)
end
