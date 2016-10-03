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

ActiveRecord::Schema.define(version: 20161003222152) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clubs", force: :cascade do |t|
    t.text     "name"
    t.text     "address"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.text     "source"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "streak_key"
  end

  create_table "clubs_leaders", id: false, force: :cascade do |t|
    t.integer "club_id"
    t.integer "leader_id"
    t.index ["club_id"], name: "index_clubs_leaders_on_club_id", using: :btree
    t.index ["leader_id"], name: "index_clubs_leaders_on_leader_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "leaders", force: :cascade do |t|
    t.text     "name"
    t.text     "gender"
    t.text     "year"
    t.text     "email"
    t.text     "slack_username"
    t.text     "github_username"
    t.text     "twitter_username"
    t.text     "phone_number"
    t.text     "address"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "streak_key"
  end

end
