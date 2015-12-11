# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151211013839) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "applications", force: :cascade do |t|
    t.string "identifier"
    t.string "root_url"
  end

  create_table "browsers", force: :cascade do |t|
    t.string "browser_name"
  end

  create_table "operating_systems", force: :cascade do |t|
    t.string "op_system"
  end

  create_table "payloads", force: :cascade do |t|
    t.integer  "application_id"
    t.string   "relative_path_string"
    t.datetime "requested_at"
    t.integer  "responded_in"
    t.string   "referred_by"
    t.string   "request_type_string"
    t.string   "event"
    t.string   "operating_system_string"
    t.string   "browser_string"
    t.string   "resolution_string"
    t.string   "ip_address"
    t.integer  "relative_path_id"
    t.integer  "request_type_id"
    t.integer  "resolution_id"
    t.integer  "operating_system_id"
    t.integer  "browser_id"
  end

  create_table "relative_paths", force: :cascade do |t|
    t.string "path"
  end

  create_table "request_types", force: :cascade do |t|
    t.string "verb"
  end

  create_table "resolutions", force: :cascade do |t|
    t.integer "width"
    t.integer "height"
  end

end
