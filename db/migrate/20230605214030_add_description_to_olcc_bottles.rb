class AddDescriptionToOlccBottles < ActiveRecord::Migration[7.0]
  def change
    add_column :olcc_bottles, :description, :string

    OlccBottle.connection.execute("UPDATE olcc_bottles SET description = name")
  end
end
