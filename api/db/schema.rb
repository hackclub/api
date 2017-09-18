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

ActiveRecord::Schema.define(version: 20170918023540) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
    t.text     "team"
    t.text     "access_token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "check_ins", force: :cascade do |t|
    t.integer  "club_id"
    t.integer  "leader_id"
    t.date     "meeting_date"
    t.integer  "attendance"
    t.text     "notes"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["club_id"], name: "index_check_ins_on_club_id", using: :btree
    t.index ["leader_id"], name: "index_check_ins_on_leader_id", using: :btree
  end

  create_table "cloud9_invites", force: :cascade do |t|
    t.text     "team_name"
    t.text     "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "club_applications", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "github"
    t.string   "twitter"
    t.string   "high_school"
    t.string   "interesting_project"
    t.string   "systems_hacked"
    t.string   "steps_taken"
    t.text     "referer"
    t.string   "phone_number"
    t.time     "start_date"
    t.text     "year"
    t.text     "application_quality"
    t.text     "rejection_reason"
    t.text     "source"
    t.string   "streak_key"
    t.string   "stage_key"
    t.string   "notes"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "legacy_year"
  end

  create_table "clubs", force: :cascade do |t|
    t.text     "name"
    t.text     "address"
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.text     "source"
    t.text     "notes"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.text     "streak_key"
    t.integer  "point_of_contact_id"
    t.text     "stage_key"
    t.text     "activation_date"
    t.text     "reason_of_death"
    t.datetime "time_of_death"
    t.index ["point_of_contact_id"], name: "index_clubs_on_point_of_contact_id", using: :btree
    t.index ["streak_key"], name: "index_clubs_on_streak_key", using: :btree
  end

  create_table "clubs_leaders", id: false, force: :cascade do |t|
    t.integer "club_id"
    t.integer "leader_id"
    t.index ["club_id", "leader_id"], name: "index_clubs_leaders_uniqueness", unique: true, using: :btree
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

  create_table "donors", force: :cascade do |t|
    t.string   "email"
    t.string   "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fundraising_deals", force: :cascade do |t|
    t.text     "name"
    t.text     "streak_key"
    t.text     "stage_key"
    t.integer  "commitment_amount"
    t.integer  "amount_in_bank"
    t.text     "source"
    t.text     "notes"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["streak_key"], name: "index_fundraising_deals_on_streak_key", using: :btree
  end

  create_table "hackbot_interactions", force: :cascade do |t|
    t.text     "type"
    t.integer  "hackbot_team_id"
    t.text     "state"
    t.json     "data"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["hackbot_team_id"], name: "index_hackbot_interactions_on_hackbot_team_id", using: :btree
  end

  create_table "hackbot_teams", force: :cascade do |t|
    t.text     "team_id"
    t.text     "team_name"
    t.text     "bot_user_id"
    t.text     "bot_access_token"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.text     "bot_username"
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
    t.text     "notes"
    t.text     "slack_id"
    t.text     "slack_team_id"
    t.text     "stage_key"
    t.index ["streak_key"], name: "index_leaders_on_streak_key", using: :btree
  end

  create_table "letters", force: :cascade do |t|
    t.text     "name"
    t.text     "streak_key"
    t.text     "letter_type"
    t.text     "what_to_send"
    t.text     "address"
    t.decimal  "final_weight"
    t.text     "notes"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.text     "stage_key"
    t.index ["streak_key"], name: "index_letters_on_streak_key", using: :btree
  end

  create_table "net_promoter_score_surveys", force: :cascade do |t|
    t.integer  "score"
    t.text     "could_improve"
    t.text     "done_well"
    t.text     "anything_else"
    t.integer  "leader_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["leader_id"], name: "index_net_promoter_score_surveys_on_leader_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.text     "title"
    t.text     "description"
    t.text     "local_dir"
    t.text     "git_url"
    t.text     "live_url"
    t.json     "data"
    t.integer  "source"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "slack_analytic_logs", force: :cascade do |t|
    t.json     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slack_invites", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "slack_invite_id"
    t.text     "full_name"
    t.text     "username"
    t.text     "password"
    t.text     "state"
  end

  create_table "tech_domain_redemptions", force: :cascade do |t|
    t.text     "name"
    t.text     "email"
    t.text     "requested_domain"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_foreign_key "check_ins", "clubs"
  add_foreign_key "check_ins", "leaders"
  add_foreign_key "clubs", "leaders", column: "point_of_contact_id"
  add_foreign_key "net_promoter_score_surveys", "leaders"
end
