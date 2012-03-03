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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120303063921) do

  create_table "accessory_points", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",      :default => 0
    t.integer  "point_id",   :default => 1
    t.string   "alias"
  end

  create_table "comments", :force => true do |t|
    t.string   "user_id"
    t.string   "event_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "time"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_id"
    t.string   "first"
    t.string   "second"
  end

  create_table "points", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",      :default => 0
    t.string   "alias"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "e_mail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
