# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160923050532) do

  create_table "armies", force: :cascade do |t|
    t.integer  "army1"
    t.integer  "army2"
    t.integer  "army3"
    t.integer  "army4"
    t.integer  "army5"
    t.integer  "army6"
    t.integer  "army7"
    t.integer  "army8"
    t.integer  "army9"
    t.integer  "army10"
    t.integer  "army11"
    t.integer  "my_village_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["my_village_id"], name: "index_armies_on_my_village_id"
  end

  create_table "lands", force: :cascade do |t|
    t.integer  "type_id"
    t.integer  "coordinate_x"
    t.integer  "coordinate_y"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "my_villages", force: :cascade do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "coordinate_x"
    t.integer  "coordinate_y"
    t.integer  "wood"
    t.integer  "clay"
    t.integer  "iron"
    t.integer  "crop"
    t.integer  "wood_quanity"
    t.integer  "clay_quanity"
    t.integer  "iron_quanity"
    t.integer  "crop_quanity"
    t.integer  "user_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["user_id"], name: "index_my_villages_on_user_id"
  end

  create_table "oasises", force: :cascade do |t|
    t.integer  "bonus_wood"
    t.integer  "bonus_clay"
    t.integer  "bonus_iron"
    t.integer  "bonus_crop"
    t.integer  "rat"
    t.integer  "spider"
    t.integer  "snake"
    t.integer  "bat"
    t.integer  "wild_boar"
    t.integer  "wolf"
    t.integer  "bear"
    t.integer  "crocodile"
    t.integer  "tiger"
    t.integer  "elephant"
    t.integer  "land_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["land_id"], name: "index_oasises_on_land_id"
  end

  create_table "resources", force: :cascade do |t|
    t.integer  "gid"
    t.integer  "level"
    t.string   "link"
    t.boolean  "upgrade"
    t.integer  "my_village_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["my_village_id"], name: "index_resources_on_my_village_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password"
    t.integer  "race"
    t.string   "proxy"
    t.string   "t3e"
    t.string   "lowres"
    t.string   "sess_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "valleies", force: :cascade do |t|
    t.integer  "type"
    t.integer  "wood"
    t.integer  "clay"
    t.integer  "iron"
    t.integer  "crop"
    t.integer  "land_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["land_id"], name: "index_valleies_on_land_id"
  end

  create_table "villages", force: :cascade do |t|
    t.integer  "type"
    t.integer  "race"
    t.string   "owner"
    t.string   "clan"
    t.integer  "population"
    t.integer  "land_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["land_id"], name: "index_villages_on_land_id"
  end

  create_table "waste_lands", force: :cascade do |t|
    t.integer  "type"
    t.integer  "land_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["land_id"], name: "index_waste_lands_on_land_id"
  end

end
