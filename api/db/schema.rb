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

ActiveRecord::Schema.define(version: 20180221055304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_stat_statements"

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.text "team"
    t.text "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "athul_clubs", id: :serial, force: :cascade do |t|
    t.integer "club_id"
    t.integer "leader_id"
    t.integer "letter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_athul_clubs_on_club_id"
    t.index ["leader_id"], name: "index_athul_clubs_on_leader_id"
    t.index ["letter_id"], name: "index_athul_clubs_on_letter_id"
  end

  create_table "check_ins", id: :serial, force: :cascade do |t|
    t.integer "club_id"
    t.integer "leader_id"
    t.date "meeting_date"
    t.integer "attendance"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_check_ins_on_club_id"
    t.index ["leader_id"], name: "index_check_ins_on_leader_id"
  end

  create_table "cloud9_invites", id: :serial, force: :cascade do |t|
    t.text "team_name"
    t.text "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "club_applications", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "github"
    t.string "twitter"
    t.string "high_school"
    t.string "interesting_project"
    t.string "systems_hacked"
    t.string "steps_taken"
    t.text "referer"
    t.string "phone_number"
    t.time "start_date"
    t.text "year"
    t.text "application_quality"
    t.text "rejection_reason"
    t.text "source"
    t.string "streak_key"
    t.string "stage_key"
    t.string "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "legacy_year"
  end

  create_table "clubs", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.text "source"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "streak_key"
    t.integer "point_of_contact_id"
    t.text "stage_key"
    t.text "activation_date"
    t.text "reason_of_death"
    t.datetime "time_of_death"
    t.text "parsed_address"
    t.text "parsed_city"
    t.text "parsed_state"
    t.text "parsed_state_code"
    t.text "parsed_postal_code"
    t.text "parsed_country"
    t.text "parsed_country_code"
    t.index ["point_of_contact_id"], name: "index_clubs_on_point_of_contact_id"
    t.index ["streak_key"], name: "index_clubs_on_streak_key"
  end

  create_table "clubs_leaders", id: false, force: :cascade do |t|
    t.integer "club_id"
    t.integer "leader_id"
    t.index ["club_id", "leader_id"], name: "index_clubs_leaders_uniqueness", unique: true
    t.index ["club_id"], name: "index_clubs_leaders_on_club_id"
    t.index ["leader_id"], name: "index_clubs_leaders_on_leader_id"
  end

  create_table "donors", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "stripe_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fundraising_deals", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "streak_key"
    t.text "stage_key"
    t.text "source"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "actual_amount"
    t.text "target_amount"
    t.text "probability_of_close"
    t.index ["streak_key"], name: "index_fundraising_deals_on_streak_key"
  end

  create_table "hackbot_interactions", id: :serial, force: :cascade do |t|
    t.text "type"
    t.integer "hackbot_team_id"
    t.text "state"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hackbot_team_id"], name: "index_hackbot_interactions_on_hackbot_team_id"
  end

  create_table "hackbot_teams", id: :serial, force: :cascade do |t|
    t.text "team_id"
    t.text "team_name"
    t.text "bot_user_id"
    t.text "bot_access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "bot_username"
  end

  create_table "leader_profiles", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "new_club_application_id"
    t.text "leader_name"
    t.text "leader_email"
    t.integer "leader_year_in_school"
    t.integer "leader_gender"
    t.integer "leader_ethnicity"
    t.text "leader_phone_number"
    t.text "leader_address"
    t.decimal "leader_latitude"
    t.decimal "leader_longitude"
    t.text "leader_parsed_address"
    t.text "leader_parsed_city"
    t.text "leader_parsed_state"
    t.text "leader_parsed_state_code"
    t.text "leader_parsed_postal_code"
    t.text "leader_parsed_country"
    t.text "leader_parsed_country_code"
    t.text "presence_personal_website"
    t.text "presence_github_url"
    t.text "presence_linkedin_url"
    t.text "presence_facebook_url"
    t.text "presence_twitter_url"
    t.text "skills_system_hacked"
    t.text "skills_impressive_achievement"
    t.boolean "skills_is_technical"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "leader_birthday"
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_leader_profiles_on_deleted_at"
    t.index ["new_club_application_id"], name: "index_leader_profiles_on_new_club_application_id"
    t.index ["user_id"], name: "index_leader_profiles_on_user_id"
  end

  create_table "leaders", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "gender"
    t.text "year"
    t.text "email"
    t.text "slack_username"
    t.text "github_username"
    t.text "twitter_username"
    t.text "phone_number"
    t.text "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "streak_key"
    t.text "notes"
    t.text "slack_id"
    t.text "slack_team_id"
    t.text "stage_key"
    t.text "parsed_address"
    t.text "parsed_city"
    t.text "parsed_state"
    t.text "parsed_state_code"
    t.text "parsed_postal_code"
    t.text "parsed_country"
    t.text "parsed_country_code"
    t.index ["streak_key"], name: "index_leaders_on_streak_key"
  end

  create_table "leadership_positions", force: :cascade do |t|
    t.bigint "new_club_id"
    t.bigint "new_leader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_club_id"], name: "index_leadership_positions_on_new_club_id"
    t.index ["new_leader_id"], name: "index_leadership_positions_on_new_leader_id"
  end

  create_table "letters", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "streak_key"
    t.text "letter_type"
    t.text "what_to_send"
    t.text "address"
    t.decimal "final_weight"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "stage_key"
    t.index ["streak_key"], name: "index_letters_on_streak_key"
  end

  create_table "net_promoter_score_surveys", id: :serial, force: :cascade do |t|
    t.integer "score"
    t.text "could_improve"
    t.text "done_well"
    t.text "anything_else"
    t.integer "leader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id"], name: "index_net_promoter_score_surveys_on_leader_id"
  end

  create_table "new_club_applications", id: :serial, force: :cascade do |t|
    t.text "high_school_name"
    t.text "high_school_url"
    t.integer "high_school_type"
    t.text "high_school_address"
    t.decimal "high_school_latitude"
    t.decimal "high_school_longitude"
    t.text "high_school_parsed_address"
    t.text "high_school_parsed_city"
    t.text "high_school_parsed_state"
    t.text "high_school_parsed_state_code"
    t.text "high_school_parsed_postal_code"
    t.text "high_school_parsed_country"
    t.text "high_school_parsed_country_code"
    t.text "leaders_team_origin_story"
    t.text "progress_general"
    t.text "progress_student_interest"
    t.text "progress_meeting_yet"
    t.text "idea_why"
    t.text "idea_other_coding_clubs"
    t.text "idea_other_general_clubs"
    t.text "formation_registered"
    t.text "formation_misc"
    t.text "curious_what_convinced"
    t.text "curious_how_did_hear"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "other_surprising_or_amusing_discovery"
    t.integer "point_of_contact_id"
    t.datetime "submitted_at"
    t.json "legacy_fields"
    t.datetime "interviewed_at"
    t.text "interview_notes"
    t.integer "interview_duration"
    t.datetime "rejected_at"
    t.integer "rejected_reason"
    t.text "rejected_notes"
    t.index ["point_of_contact_id"], name: "index_new_club_applications_on_point_of_contact_id"
  end

  create_table "new_clubs", force: :cascade do |t|
    t.text "high_school_name"
    t.text "high_school_url"
    t.integer "high_school_type"
    t.text "high_school_address"
    t.decimal "high_school_latitude"
    t.decimal "high_school_longitude"
    t.text "high_school_parsed_address"
    t.text "high_school_parsed_city"
    t.text "high_school_parsed_state"
    t.text "high_school_parsed_state_code"
    t.text "high_school_parsed_postal_code"
    t.text "high_school_parsed_country"
    t.text "high_school_parsed_country_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "new_leaders", force: :cascade do |t|
    t.text "name"
    t.text "email"
    t.date "birthday"
    t.date "expected_graduation"
    t.integer "gender"
    t.integer "ethnicity"
    t.text "phone_number"
    t.text "address"
    t.decimal "latitude"
    t.decimal "longitude"
    t.text "parsed_address"
    t.text "parsed_city"
    t.text "parsed_state"
    t.text "parsed_state_code"
    t.text "parsed_postal_code"
    t.text "parsed_country"
    t.text "parsed_country_code"
    t.text "personal_website"
    t.text "github_url"
    t.text "linkedin_url"
    t.text "facebook_url"
    t.text "twitter_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string "noteable_type"
    t.bigint "noteable_id"
    t.bigint "user_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_notes_on_deleted_at"
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.text "title"
    t.text "description"
    t.text "local_dir"
    t.text "git_url"
    t.text "live_url"
    t.json "data"
    t.integer "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slack_analytic_logs", id: :serial, force: :cascade do |t|
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slack_invite_strategies", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "greeting"
    t.text "club_name"
    t.text "primary_color"
    t.text "user_groups", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hackbot_team_id"
    t.text "theme"
    t.index ["hackbot_team_id"], name: "index_slack_invite_strategies_on_hackbot_team_id"
  end

  create_table "slack_invites", id: :serial, force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "slack_invite_id"
    t.text "full_name"
    t.text "username"
    t.text "password"
    t.text "state"
    t.text "token"
    t.integer "slack_invite_strategy_id"
    t.integer "hackbot_team_id"
    t.index ["hackbot_team_id"], name: "index_slack_invites_on_hackbot_team_id"
    t.index ["slack_invite_strategy_id"], name: "index_slack_invites_on_slack_invite_strategy_id"
  end

  create_table "tech_domain_redemptions", id: :serial, force: :cascade do |t|
    t.text "name"
    t.text "email"
    t.text "requested_domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.text "email"
    t.text "login_code"
    t.datetime "login_code_generation"
    t.text "auth_token"
    t.datetime "auth_token_generation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "admin_at"
  end

  add_foreign_key "athul_clubs", "clubs"
  add_foreign_key "athul_clubs", "leaders"
  add_foreign_key "athul_clubs", "letters"
  add_foreign_key "check_ins", "clubs"
  add_foreign_key "check_ins", "leaders"
  add_foreign_key "clubs", "leaders", column: "point_of_contact_id"
  add_foreign_key "leadership_positions", "new_clubs"
  add_foreign_key "leadership_positions", "new_leaders"
  add_foreign_key "net_promoter_score_surveys", "leaders"
  add_foreign_key "new_club_applications", "users", column: "point_of_contact_id"
  add_foreign_key "notes", "users"
  add_foreign_key "slack_invite_strategies", "hackbot_teams"
  add_foreign_key "slack_invites", "hackbot_teams"
  add_foreign_key "slack_invites", "slack_invite_strategies"
end
