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

ActiveRecord::Schema.define(version: 20170809085316) do

  create_table "players", force: :cascade do |t|
    t.integer "song_id"
    t.integer "room_id"
    t.date    "modified_at"
  end

  create_table "rooms", force: :cascade do |t|
    t.string  "name"
    t.integer "player_id"
    t.date    "modified_at"
    t.string  "owner"
  end

  add_index "rooms", ["player_id"], name: "index_rooms_on_player_id"

  create_table "songs", force: :cascade do |t|
    t.string  "name"
    t.string  "link"
    t.integer "poll"
    t.integer "room_id"
    t.string  "thumbnail"
    t.integer "modified_at"
    t.boolean "past"
    t.boolean "liked"
  end

  add_index "songs", ["room_id"], name: "index_songs_on_room_id"

end
