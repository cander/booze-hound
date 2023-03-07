class UpdateBottleInventory < ApplicationService
  def initialize(client, bottle)
    @client = client
    @bottle = bottle
  end

  def call
    existing_inv = OlccInventory.where(new_item_code: @bottle)
    inv_map = {}
    existing_inv.each { |i|
      inv_map[i.store_num] = i
    }

    new_inv = @client.get_item_inventory(@bottle.new_item_code, @bottle.old_item_code)

    # code to update records that are in both
    new_inv.each do |id|
      inv = OlccInventory.where(new_item_code: id.new_item_code,
        store_num: id.store_num).first
      if inv
        inv.update(quantity: id.quantity)
        inv_map.delete(id.store_num)
      else
        OlccInventory.create(new_item_code: id.new_item_code,
          store_num: id.store_num, quantity: id.quantity)
      end
    end

    # anything still in inv_map has zero quantity
    inv_map.each do |store_num, inv|
      inv.update(quantity: 0)
    end
  end
end
