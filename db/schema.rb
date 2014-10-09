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

ActiveRecord::Schema.define(:version => 20141009164231) do

  create_table "accounts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "minutes",           :default => 6000
    t.integer  "instance_limit",    :default => 2
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "security_group_id"
    t.boolean  "power_user",        :default => false
  end

  create_table "amis", :force => true do |t|
    t.string   "imageId"
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "size"
  end

  create_table "clouds", :force => true do |t|
    t.string   "name"
    t.string   "instance_id"
    t.datetime "turn_off_at"
    t.string   "ami_id"
    t.string   "subnet_id"
    t.integer  "account_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "clouds", ["account_id"], :name => "index_clouds_on_account_id"

  create_table "users", :force => true do |t|
    t.string   "login",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "remember_token"
    t.integer  "sign_in_count",          :default => 0,     :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
