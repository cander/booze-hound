class AddPriceToOlccBottle < ActiveRecord::Migration[7.0]
  def change
    add_column :olcc_bottles, :bottle_price, :decimal
  end
end
