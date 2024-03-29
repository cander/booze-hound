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
        orig_qty = inv.quantity
        inv.update(quantity: ir.quantity)
        BottleEvent.new_inventory(inv) if orig_qty == 0
        existing_inv.delete(ir.store_num)
        # ignore the case where OLCC reports inventory, but the store is no longer
        # followed by any users - not going to delete the inventory record.
      else
        # TODO: eventually, only create a store inventory record for stores that
        # some user is following. Will want a follower count for that.
        store = OlccStore.find_by(store_num: ir.store_num)
        if store && store.followers_count > 0
          logger.info { "Adding #{ir.quantity} bottles at store #{ir.store_num} with #{store.followers_count} followers" }
          i = OlccInventory.create(new_item_code: ir.new_item_code,
            store_num: ir.store_num, quantity: ir.quantity)
          if i.valid?
            BottleEvent.new_inventory(i)
          else
            logger.error { "Validations failed for store #{i.store_num} - #{i.errors.messages}" }
          end
        else
          logger.info { "Ignoring #{ir.quantity} bottles at store #{ir.store_num} with no followers" }
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
