# A simple data transfer object (DTO) for inventory data
# The attribute names match the attributes on the corresponding models

module Dto
  InventoryData = Data.define(:new_item_code, :store_num, :quantity)
  StoreData = Data.define(:store_num, :location, :address, :zip, :telephone, :store_hours)
end
