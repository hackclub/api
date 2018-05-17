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

ActiveRecord::Schema.define(version: 2018_05_17_125005) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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

  create_table "attachments", force: :cascade do |t|
    t.text "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "attachable_id"
    t.text "attachable_type"
  end

  create_table "challenge_post_clicks", force: :cascade do |t|
    t.bigint "challenge_post_id"
    t.bigint "user_id"
    t.inet "ip_address"
    t.text "referer"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["challenge_post_id"], name: "index_challenge_post_clicks_on_challenge_post_id"
    t.index ["deleted_at"], name: "index_challenge_post_clicks_on_deleted_at"
    t.index ["user_id"], name: "index_challenge_post_clicks_on_user_id"
  end

  create_table "challenge_post_comments", force: :cascade do |t|
    t.datetime "deleted_at"
    t.bigint "user_id"
    t.bigint "challenge_post_id"
    t.bigint "parent_id"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["challenge_post_id"], name: "index_challenge_post_comments_on_challenge_post_id"
    t.index ["deleted_at"], name: "index_challenge_post_comments_on_deleted_at"
    t.index ["parent_id"], name: "index_challenge_post_comments_on_parent_id"
    t.index ["user_id"], name: "index_challenge_post_comments_on_user_id"
  end

  create_table "challenge_post_upvotes", force: :cascade do |t|
    t.bigint "challenge_post_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["challenge_post_id", "user_id", "deleted_at"], name: "unique_by_post_and_user", unique: true
    t.index ["challenge_post_id"], name: "index_challenge_post_upvotes_on_challenge_post_id"
    t.index ["deleted_at"], name: "index_challenge_post_upvotes_on_deleted_at"
    t.index ["user_id"], name: "index_challenge_post_upvotes_on_user_id"
  end

  create_table "challenge_posts", force: :cascade do |t|
    t.text "name"
    t.text "url"
    t.text "description"
    t.bigint "creator_id"
    t.bigint "challenge_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "comment_count"
    t.integer "click_count"
    t.integer "upvote_count"
    t.index ["challenge_id"], name: "index_challenge_posts_on_challenge_id"
    t.index ["creator_id"], name: "index_challenge_posts_on_creator_id"
    t.index ["deleted_at"], name: "index_challenge_posts_on_deleted_at"
  end

  create_table "challenges", force: :cascade do |t|
    t.text "name"
    t.text "description"
    t.datetime "start"
    t.datetime "end"
    t.bigint "creator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["creator_id"], name: "index_challenges_on_creator_id"
    t.index ["deleted_at"], name: "index_challenges_on_deleted_at"
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

  create_table "event_email_subscribers", force: :cascade do |t|
    t.text "email"
    t.text "location"
    t.decimal "latitude"
    t.decimal "longitude"
    t.text "parsed_address"
    t.text "parsed_city"
    t.text "parsed_state"
    t.text "parsed_state_code"
    t.text "parsed_postal_code"
    t.text "parsed_country"
    t.text "parsed_country_code"
    t.datetime "unsubscribed_at"
    t.text "unsubscribe_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "confirmed_at"
    t.text "confirmation_token"
    t.text "link_tracking_token"
    t.index ["confirmation_token"], name: "index_event_email_subscribers_on_confirmation_token", unique: true
    t.index ["email"], name: "index_event_email_subscribers_on_email", unique: true
    t.index ["link_tracking_token"], name: "index_event_email_subscribers_on_link_tracking_token", unique: true
    t.index ["unsubscribe_token"], name: "index_event_email_subscribers_on_unsubscribe_token", unique: true
  end

  create_table "event_website_clicks", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "event_email_subscriber_id"
    t.inet "ip_address"
    t.text "referer"
    t.text "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_email_subscriber_id"], name: "index_event_website_clicks_on_event_email_subscriber_id"
    t.index ["event_id"], name: "index_event_website_clicks_on_event_id"
  end

  create_table "events", force: :cascade do |t|
    t.date "start"
    t.date "end"
    t.text "name"
    t.text "website"
    t.text "website_archived"
    t.integer "total_attendance"
    t.integer "first_time_hackathon_estimate"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "hack_club_associated"
    t.text "hack_club_associated_notes"
    t.boolean "public"
    t.boolean "collegiate"
    t.boolean "mlh_associated"
    t.index ["deleted_at"], name: "index_events_on_deleted_at"
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

  create_table "leadership_position_invites", force: :cascade do |t|
    t.bigint "sender_id"
    t.bigint "new_club_id"
    t.bigint "user_id"
    t.datetime "accepted_at"
    t.datetime "rejected_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["new_club_id"], name: "index_leadership_position_invites_on_new_club_id"
    t.index ["sender_id"], name: "index_leadership_position_invites_on_sender_id"
    t.index ["user_id"], name: "index_leadership_position_invites_on_user_id"
  end

  create_table "leadership_positions", force: :cascade do |t|
    t.bigint "new_club_id"
    t.bigint "new_leader_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_leadership_positions_on_deleted_at"
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
    t.bigint "new_club_id"
    t.datetime "accepted_at"
    t.index ["new_club_id"], name: "index_new_club_applications_on_new_club_id"
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

  create_table "recognized_faces", force: :cascade do |t|
    t.bigint "attachment_id"
    t.bigint "recognized_person_id"
    t.text "external_face_id"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_id"], name: "index_recognized_faces_on_attachment_id"
    t.index ["external_face_id"], name: "index_recognized_faces_on_external_face_id"
    t.index ["recognized_person_id"], name: "index_recognized_faces_on_recognized_person_id"
  end

  create_table "recognized_people", force: :cascade do |t|
    t.text "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slack_analytic_logs", id: :serial, force: :cascade do |t|
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "slack_invites", id: :serial, force: :cascade do |t|
    t.text "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "slack_invite_id"
    t.text "full_name"
    t.text "username"
    t.text "password"
    t.text "state"
    t.text "token"
    t.integer "hackbot_team_id"
    t.index ["email"], name: "index_slack_invites_on_email", unique: true
    t.index ["hackbot_team_id"], name: "index_slack_invites_on_hackbot_team_id"
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
    t.text "username"
    t.boolean "email_on_new_challenge_posts"
    t.boolean "email_on_new_challenges"
    t.boolean "email_on_new_challenge_post_comments"
    t.bigint "new_leader_id"
    t.index ["auth_token"], name: "index_users_on_auth_token"
    t.index ["email"], name: "index_users_on_email"
    t.index ["new_leader_id"], name: "index_users_on_new_leader_id"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "workshop_feedbacks", force: :cascade do |t|
    t.text "workshop_slug"
    t.json "feedback"
    t.inet "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ip_address"], name: "index_workshop_feedbacks_on_ip_address"
    t.index ["workshop_slug"], name: "index_workshop_feedbacks_on_workshop_slug"
  end

  add_foreign_key "athul_clubs", "clubs"
  add_foreign_key "athul_clubs", "leaders"
  add_foreign_key "athul_clubs", "letters"
  add_foreign_key "challenge_post_clicks", "challenge_posts"
  add_foreign_key "challenge_post_clicks", "users"
  add_foreign_key "challenge_post_comments", "challenge_post_comments", column: "parent_id"
  add_foreign_key "challenge_post_comments", "challenge_posts"
  add_foreign_key "challenge_post_comments", "users"
  add_foreign_key "challenge_post_upvotes", "challenge_posts"
  add_foreign_key "challenge_post_upvotes", "users"
  add_foreign_key "challenge_posts", "challenges"
  add_foreign_key "challenge_posts", "users", column: "creator_id"
  add_foreign_key "challenges", "users", column: "creator_id"
  add_foreign_key "check_ins", "clubs"
  add_foreign_key "check_ins", "leaders"
  add_foreign_key "clubs", "leaders", column: "point_of_contact_id"
  add_foreign_key "event_website_clicks", "event_email_subscribers"
  add_foreign_key "event_website_clicks", "events"
  add_foreign_key "leadership_position_invites", "new_clubs"
  add_foreign_key "leadership_position_invites", "users"
  add_foreign_key "leadership_position_invites", "users", column: "sender_id"
  add_foreign_key "leadership_positions", "new_clubs"
  add_foreign_key "leadership_positions", "new_leaders"
  add_foreign_key "net_promoter_score_surveys", "leaders"
  add_foreign_key "new_club_applications", "new_clubs"
  add_foreign_key "new_club_applications", "users", column: "point_of_contact_id"
  add_foreign_key "notes", "users"
  add_foreign_key "recognized_faces", "attachments"
  add_foreign_key "recognized_faces", "recognized_people"
  add_foreign_key "slack_invites", "hackbot_teams"
  add_foreign_key "users", "new_leaders"
end
