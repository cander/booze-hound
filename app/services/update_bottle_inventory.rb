# Update the inventory for one bottle. Fetch the latest inventory from OLCC and
# compare it to exising inventory records. Possible outcomes: add new record or
# update existing record, possibly setting quantity to zero.
class UpdateBottleInventory < ApplicationService
  def initialize(client, bottle)
    @client = client
    @bottle = bottle
  end

  def call
    logger.info { "Updating inventory for #{@bottle.category} #{@bottle.new_item_code} - #{@bottle.name}" }
    inv_records = OlccInventory.where(new_item_code: @bottle)
    # index existing inventory by store_num
    existing_inv = {}
    inv_records.each { |i| existing_inv[i.store_num] = i }

    new_inv = @client.get_item_inventory(@bottle.category, @bottle.new_item_code, @bottle.old_item_code)

    # records in new_inv could be existing or new
    new_inv.each do |ir|
      inv = existing_inv[ir.store_num]
      logger.info { "Found #{ir.quantity} bottles at #{ir.store_num} - existing inv: #{inv ? inv.quantity : "NONE"}" }
      if inv
        # PERF: Rails re-checks the FKs when the quantity is unchanged
        # alternative is to set the qty and call quantity_changed? before save
        inv.update(quantity: ir.quantity)
        existing_inv.delete(ir.store_num)
      else
        logger.info { "Adding #{ir.quantity} bottles at store #{ir.store_num}" }
        i = OlccInventory.create(new_item_code: ir.new_item_code,
          store_num: ir.store_num, quantity: ir.quantity)
        unless i.valid?
          logger.error { "Validations failed for store #{i.store_num} - #{i.errors.messages}" }
        end
      end
    end

    # anything still in existing_inv has zero quantity
    existing_inv.each do |store_num, inv|
      logger.info { "Zeroing quantity at store #{store_num}" }
      inv.update(quantity: 0)
    end
  end
end
