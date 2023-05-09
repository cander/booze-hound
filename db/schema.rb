# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_05_08_213310) do
  create_table "bottle_events", force: :cascade do |t|
    t.string "new_item_code"
    t.string "event_type", null: false
    t.text "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "olcc_bottles", primary_key: "new_item_code", id: :string, force: :cascade do |t|
    t.string "old_item_code"
    t.string "name"
    t.string "size"
    t.decimal "proof"
    t.string "age"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "bottle_price"
    t.boolean "followed", default: false
  end

  create_table "olcc_bottles_users", id: false, force: :cascade do |t|
    t.string "new_item_code"
    t.integer "user_id"
    t.index ["new_item_code"], name: "index_olcc_bottles_users_on_new_item_code"
    t.index ["user_id"], name: "index_olcc_bottles_users_on_user_id"
  end

  create_table "olcc_inventories", force: :cascade do |t|
    t.integer "quantity"
    t.string "new_item_code"
    t.string "store_num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "olcc_stores", primary_key: "store_num", id: :string, force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "address"
    t.integer "zip"
    t.string "telephone"
    t.string "store_hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "encrypted_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
