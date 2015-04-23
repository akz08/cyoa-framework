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

ActiveRecord::Schema.define(version: 20150422110546) do

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token",                          null: false
    t.integer  "uid",          limit: 8,                null: false
    t.boolean  "active",                 default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["access_token"], name: "index_api_keys_on_access_token", unique: true
  add_index "api_keys", ["uid"], name: "index_api_keys_on_uid"

  create_table "characters", force: :cascade do |t|
    t.string  "name",        null: false
    t.integer "age",         null: false
    t.string  "gender",      null: false
    t.text    "description", null: false
    t.boolean "default",     null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "scene_id",  null: false
    t.string  "text",      null: false
    t.boolean "from_self", null: false
    t.integer "parent_id", null: false
    t.integer "delay"
  end

  add_index "messages", ["parent_id"], name: "index_messages_on_parent_id"
  add_index "messages", ["scene_id"], name: "index_messages_on_scene_id"

  create_table "scenes", force: :cascade do |t|
    t.integer "character_id", null: false
    t.text    "information",  null: false
  end

  add_index "scenes", ["character_id"], name: "index_scenes_on_character_id"

  create_table "user_characters", id: false, force: :cascade do |t|
    t.integer "user_id",      null: false
    t.integer "character_id", null: false
  end

  add_index "user_characters", ["user_id", "character_id"], name: "index_user_characters_on_user_id_and_character_id", unique: true

  create_table "user_messages", id: false, force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "message_id", null: false
    t.datetime "datetime",   null: false
  end

  add_index "user_messages", ["user_id", "message_id"], name: "index_user_messages_on_user_id_and_message_id", unique: true

  create_table "users", id: false, force: :cascade do |t|
    t.integer  "uid",                limit: 8, null: false
    t.text     "encrypted_fb_token"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "encrypted_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["uid"], name: "index_users_on_uid", unique: true

end
