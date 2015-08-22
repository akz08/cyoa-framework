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

ActiveRecord::Schema.define(version: 20150625122305) do

  create_table "api_keys", id: false, force: :cascade do |t|
    t.string   "key"
    t.integer  "fb_user_id", limit: 8
    t.boolean  "active",               default: true
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "api_keys", ["fb_user_id"], name: "index_api_keys_on_fb_user_id"
  add_index "api_keys", ["key"], name: "index_api_keys_on_key"

  create_table "characters", force: :cascade do |t|
    t.string  "name",        null: false
    t.integer "age",         null: false
    t.string  "gender",      null: false
    t.text    "description", null: false
    t.boolean "add_on",      null: false
  end

  create_table "characters_users", id: false, force: :cascade do |t|
    t.integer  "character_id"
    t.integer  "fb_user_id",   limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "characters_users", ["character_id", "fb_user_id"], name: "index_characters_users_on_character_id_and_fb_user_id", unique: true
  add_index "characters_users", ["character_id"], name: "index_characters_users_on_character_id"
  add_index "characters_users", ["fb_user_id"], name: "index_characters_users_on_fb_user_id"

  create_table "message_scene_dependencies", id: false, force: :cascade do |t|
    t.integer "message_id"
    t.integer "scene_id"
  end

  add_index "message_scene_dependencies", ["message_id", "scene_id"], name: "index_message_scene_dependencies_on_message_id_and_scene_id", unique: true
  add_index "message_scene_dependencies", ["message_id"], name: "index_message_scene_dependencies_on_message_id"
  add_index "message_scene_dependencies", ["scene_id"], name: "index_message_scene_dependencies_on_scene_id"

  create_table "messages", force: :cascade do |t|
    t.integer "scene_id"
    t.text    "text",           null: false
    t.boolean "from_character", null: false
    t.integer "delay"
    t.integer "parent_id"
  end

  add_index "messages", ["scene_id"], name: "index_messages_on_scene_id"

  create_table "messages_users", id: false, force: :cascade do |t|
    t.integer  "message_id"
    t.integer  "fb_user_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "messages_users", ["fb_user_id"], name: "index_messages_users_on_fb_user_id"
  add_index "messages_users", ["message_id", "fb_user_id"], name: "index_messages_users_on_message_id_and_fb_user_id", unique: true
  add_index "messages_users", ["message_id"], name: "index_messages_users_on_message_id"

  create_table "scenes", force: :cascade do |t|
    t.integer "character_id"
    t.text    "information",  null: false
  end

  add_index "scenes", ["character_id"], name: "index_scenes_on_character_id"

  create_table "scenes_users", id: false, force: :cascade do |t|
    t.integer  "scene_id"
    t.integer  "fb_user_id", limit: 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "scenes_users", ["fb_user_id"], name: "index_scenes_users_on_fb_user_id"
  add_index "scenes_users", ["scene_id", "fb_user_id"], name: "index_scenes_users_on_scene_id_and_fb_user_id", unique: true
  add_index "scenes_users", ["scene_id"], name: "index_scenes_users_on_scene_id"

  create_table "users", id: false, force: :cascade do |t|
    t.integer  "fb_user_id",      limit: 8
    t.string   "first_name"
    t.string   "last_name"
    t.string   "encrypted_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["fb_user_id"], name: "index_users_on_fb_user_id"

end
