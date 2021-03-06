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

ActiveRecord::Schema.define(version: 20150213004536) do

  create_table "influencers", force: :cascade do |t|
    t.string   "name"
    t.string   "handle"
    t.string   "id_str"
    t.string   "pic"
    t.text     "raw"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "description"
    t.datetime "last_tweet_request"
  end

  create_table "tweets", force: :cascade do |t|
    t.string   "user"
    t.string   "id_str"
    t.text     "tx"
    t.text     "raw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "tweet_time"
  end

  add_index "tweets", ["tweet_time"], name: "index_tweets_on_tweet_time"

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.text     "raw"
    t.datetime "last_tweet_request"
  end

end
