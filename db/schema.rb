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

ActiveRecord::Schema.define(:version => 20101016120424) do

  create_table "news", :force => true do |t|
    t.text     "body",       :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["created_at"], :name => "index_news_on_created_at"

  create_table "posts", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.integer  "user_id",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.string   "video_url"
  end

  add_index "posts", ["created_at"], :name => "index_posts_on_created_at"
  add_index "posts", ["type"], :name => "index_posts_on_type"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "post_id",    :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["post_id", "user_id"], :name => "index_ratings_on_post_id_and_user_id"

  create_table "users", :force => true do |t|
    t.string   "surname",                                                :null => false
    t.string   "name",                                                   :null => false
    t.string   "squad",                                                  :null => false
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                               :default => false, :null => false
  end

  add_index "users", ["admin"], :name => "index_users_on_admin"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["surname", "name", "squad"], :name => "index_users_on_surname_and_name_and_squad", :unique => true

  create_table "video_metadatas", :force => true do |t|
    t.integer "video_id",         :null => false
    t.string  "provider_name"
    t.string  "title"
    t.string  "author_name"
    t.string  "thumbnail_url",    :null => false
    t.integer "thumbnail_width"
    t.integer "thumbnail_height"
  end

  add_index "video_metadatas", ["video_id"], :name => "index_video_metadatas_on_video_id", :unique => true

end
