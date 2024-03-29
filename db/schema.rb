# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_01_01_222517) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "achievements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "sync_id"
    t.integer "client_db_id", null: false
    t.string "client_medal_id", null: false
    t.bigint "client_deck_id", null: false
    t.datetime "client_earned_at", null: false
    t.uuid "client_uuid", null: false
    t.uuid "medal_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "client_db_uuid", default: -> { "gen_random_uuid()" }, null: false
    t.index ["client_db_uuid"], name: "index_achievements_on_client_db_uuid", unique: true
    t.index ["client_earned_at"], name: "index_achievements_on_client_earned_at"
    t.index ["client_uuid", "client_db_id", "client_earned_at"], name: "index_achievements_on_uuid_db_id_and_earned_at", unique: true
    t.index ["medal_id"], name: "index_achievements_on_medal_id"
    t.index ["sync_id"], name: "index_achievements_on_sync_id"
    t.index ["user_id"], name: "index_achievements_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
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
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "announcements", force: :cascade do |t|
    t.datetime "published_at"
    t.string "announcement_type"
    t.string "name"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "battle_passes", force: :cascade do |t|
    t.integer "xp", default: 0, null: false
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_battle_passes_on_user_id"
  end

  create_table "challenges", force: :cascade do |t|
    t.string "title", null: false
    t.jsonb "dataset", default: {}, null: false
    t.integer "xp", null: false
    t.boolean "accomplished", default: false
    t.boolean "active", default: true
    t.string "type", null: false
    t.bigint "battle_pass_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["battle_pass_id", "title", "active"], name: "index_challenges_on_battle_pass_id_and_title_and_active", unique: true
    t.index ["battle_pass_id"], name: "index_challenges_on_battle_pass_id"
    t.index ["title"], name: "index_challenges_on_title", unique: true
  end

  create_table "chase_mode_configs", force: :cascade do |t|
    t.boolean "only_show_active_users", default: false, null: false
    t.bigint "user_id"
    t.integer "group_ids", default: [], array: true
    t.index ["user_id"], name: "index_chase_mode_configs_on_user_id", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id"
    t.uuid "reified_leaderboard_id"
    t.integer "score", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reified_leaderboard_id"], name: "index_entries_on_reified_leaderboard_id"
    t.index ["score"], name: "index_entries_on_score"
    t.index ["updated_at"], name: "index_entries_on_updated_at"
    t.index ["user_id", "reified_leaderboard_id"], name: "index_entries_on_user_id_and_reified_leaderboard_id", unique: true
    t.index ["user_id"], name: "index_entries_on_user_id"
  end

  create_table "expirations", force: :cascade do |t|
    t.uuid "achievement_id"
    t.uuid "reified_leaderboard_id"
    t.integer "points", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "achievement_client_earned_at", null: false
    t.index ["achievement_client_earned_at"], name: "index_expirations_on_achievement_client_earned_at"
    t.index ["achievement_id"], name: "index_expirations_on_achievement_id"
    t.index ["reified_leaderboard_id"], name: "index_expirations_on_reified_leaderboard_id"
  end

  create_table "families", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_families_on_slug", unique: true
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "public", default: false
    t.string "tag"
    t.string "color", default: "#0275d8", null: false
    t.integer "tag_text_color", default: 0, null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
  end

  create_table "medal_statistics", force: :cascade do |t|
    t.uuid "reified_leaderboard_id"
    t.uuid "medal_id"
    t.integer "count", default: 0, null: false
    t.integer "score", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "entry_id"
    t.index ["entry_id", "medal_id"], name: "index_medal_statistics_on_entry_id_and_medal_id", unique: true
    t.index ["entry_id"], name: "index_medal_statistics_on_entry_id"
    t.index ["medal_id"], name: "index_medal_statistics_on_medal_id"
    t.index ["reified_leaderboard_id"], name: "index_medal_statistics_on_reified_leaderboard_id"
    t.index ["score"], name: "index_medal_statistics_on_score"
    t.index ["updated_at"], name: "index_medal_statistics_on_updated_at"
  end

  create_table "medals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "client_medal_id", null: false
    t.integer "rank", null: false
    t.integer "score", null: false
    t.uuid "family_id"
    t.string "call"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_medals_on_family_id"
  end

  create_table "membership_requests", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "message", default: "", null: false
    t.index ["group_id", "user_id"], name: "index_membership_requests_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_membership_requests_on_group_id"
    t.index ["user_id"], name: "index_membership_requests_on_user_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.boolean "admin", default: false
    t.bigint "group_id"
    t.bigint "member_id"
    t.index ["group_id", "member_id"], name: "index_memberships_on_group_id_and_member_id", unique: true
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["member_id"], name: "index_memberships_on_member_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "recipient_id"
    t.bigint "actor_id"
    t.datetime "read_at"
    t.string "action"
    t.bigint "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reified_leaderboards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "family_id"
    t.integer "timeframe"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["family_id", "timeframe"], name: "index_reified_leaderboards_on_family_id_and_timeframe", unique: true
    t.index ["family_id"], name: "index_reified_leaderboards_on_family_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "provider"
    t.string "uid"
    t.string "access_token"
    t.string "access_token_secret"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.text "auth"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_services_on_user_id"
  end

  create_table "syncs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "client_uuid", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["client_uuid"], name: "index_syncs_on_client_uuid"
    t.index ["created_at"], name: "index_syncs_on_created_at"
    t.index ["user_id"], name: "index_syncs_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username", null: false
    t.datetime "announcements_last_read_at"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.json "tokens"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "achievements", "medals"
  add_foreign_key "achievements", "syncs"
  add_foreign_key "achievements", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "battle_passes", "users"
  add_foreign_key "challenges", "battle_passes"
  add_foreign_key "chase_mode_configs", "users"
  add_foreign_key "entries", "reified_leaderboards"
  add_foreign_key "entries", "users"
  add_foreign_key "expirations", "achievements"
  add_foreign_key "expirations", "reified_leaderboards"
  add_foreign_key "medal_statistics", "entries"
  add_foreign_key "medal_statistics", "medals"
  add_foreign_key "medal_statistics", "reified_leaderboards"
  add_foreign_key "medals", "families"
  add_foreign_key "membership_requests", "groups"
  add_foreign_key "membership_requests", "users"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users", column: "member_id"
  add_foreign_key "reified_leaderboards", "families"
  add_foreign_key "services", "users"
  add_foreign_key "syncs", "users"
end
