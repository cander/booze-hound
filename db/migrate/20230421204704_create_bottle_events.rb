class CreateBottleEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :bottle_events do |t|
      t.string :new_item_code
      t.string :event_type
      t.text :details

      t.timestamps
    end
    # add_foreign_key :bottle_event, :olcc_bottles, primary_key: "new_item_code"
  end
end
