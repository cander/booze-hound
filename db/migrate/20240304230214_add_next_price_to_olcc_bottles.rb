class AddNextPriceToOlccBottles < ActiveRecord::Migration[7.1]
  def up
    add_column :olcc_bottles, :next_bottle_price, :decimal
    OlccBottle.update_all "next_bottle_price = bottle_price"
  end

  def down
    remove_column :olcc_bottles, :next_bottle_price
  end
end
