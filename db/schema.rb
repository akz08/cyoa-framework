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

ActiveRecord::Schema.define(version: 20150426120012) do

  create_table "characters", force: :cascade do |t|
    t.string  "name",        null: false
    t.integer "age",         null: false
    t.string  "gender",      null: false
    t.text    "description", null: false
    t.boolean "is_add_on",   null: false
  end

  create_table "messages", force: :cascade do |t|
    t.integer "scene_id",    null: false
    t.text    "text",        null: false
    t.boolean "is_incoming", null: false
    t.integer "delay"
    t.integer "parent_id"
  end

  add_index "messages", ["scene_id"], name: "index_messages_on_scene_id"

  create_table "scene_dependencies", id: false, force: :cascade do |t|
    t.integer "scene_id",   null: false
    t.integer "message_id", null: false
  end

  add_index "scene_dependencies", ["scene_id", "message_id"], name: "index_scene_dependencies_on_scene_id_and_message_id", unique: true

  create_table "scenes", force: :cascade do |t|
    t.integer "character_id", null: false
    t.text    "information",  null: false
  end

  add_index "scenes", ["character_id"], name: "index_scenes_on_character_id"

  create_table "user_characters", id: false, force: :cascade do |t|
    t.integer  "fb_user_id",   null: false
    t.integer  "character_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_characters", ["fb_user_id", "character_id"], name: "index_user_characters_on_fb_user_id_and_character_id", unique: true

  create_table "user_messages", id: false, force: :cascade do |t|
    t.integer  "fb_user_id", null: false
    t.integer  "message_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_messages", ["fb_user_id", "message_id"], name: "index_user_messages_on_fb_user_id_and_message_id", unique: true

  create_table "users", id: false, force: :cascade do |t|
    t.integer  "fb_user_id",      limit: 8, null: false
    t.string   "first_name"
    t.string   "last_name"
    t.text     "encrypted_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["fb_user_id"], name: "index_users_on_fb_user_id", unique: true

end
