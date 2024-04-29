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

ActiveRecord::Schema[7.1].define(version: 2024_04_29_222357) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "change_logs", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.integer "rounds_played", default: 0, null: false
    t.integer "shaman_cheese", default: 0, null: false
    t.integer "saved_mice", default: 0, null: false
    t.integer "saved_mice_hard", default: 0, null: false
    t.integer "saved_mice_divine", default: 0, null: false
    t.integer "saved_mice_without_skills", default: 0, null: false
    t.integer "saved_mice_hard_without_skills", default: 0, null: false
    t.integer "saved_mice_divine_without_skills", default: 0, null: false
    t.integer "cheese_gathered", default: 0, null: false
    t.integer "firsts", default: 0, null: false
    t.integer "bootcamp", default: 0, null: false
    t.integer "survivor_rounds_played", default: 0, null: false
    t.integer "survivor_mice_killed", default: 0, null: false
    t.integer "survivor_shaman_rounds", default: 0, null: false
    t.integer "survivor_survived_rounds", default: 0, null: false
    t.integer "racing_rounds_played", default: 0, null: false
    t.integer "racing_finished_maps", default: 0, null: false
    t.integer "racing_firsts", default: 0, null: false
    t.integer "racing_podiums", default: 0, null: false
    t.integer "defilante_rounds_played", default: 0, null: false
    t.integer "defilante_finished_maps", default: 0, null: false
    t.integer "defilante_points", default: 0, null: false
    t.integer "normal_score", default: 0, null: false
    t.integer "survivor_score", default: 0, null: false
    t.integer "racing_score", default: 0, null: false
    t.integer "defilante_score", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["player_id"], name: "index_change_logs_on_player_id"
  end

  create_table "good_job_batches", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.jsonb "serialized_properties"
    t.text "on_finish"
    t.text "on_success"
    t.text "on_discard"
    t.text "callback_queue_name"
    t.integer "callback_priority"
    t.datetime "enqueued_at"
    t.datetime "discarded_at"
    t.datetime "finished_at"
  end

  create_table "good_job_executions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id", null: false
    t.text "job_class"
    t.text "queue_name"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "finished_at"
    t.text "error"
    t.integer "error_event", limit: 2
    t.text "error_backtrace", array: true
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
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
    t.datetime "cron_at"
    t.uuid "batch_id"
    t.uuid "batch_callback_id"
    t.boolean "is_discrete"
    t.integer "executions_count"
    t.text "job_class"
    t.integer "error_event", limit: 2
    t.text "labels", array: true
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "a801_id", null: false
    t.boolean "updated_last_7_days", default: false, null: false
    t.string "name", null: false
    t.date "registration_date"
    t.text "title"
    t.text "unlocked_titles"
    t.integer "experience"
    t.text "look"
    t.text "badges"
    t.text "dress_list"
    t.text "mouse_color"
    t.text "shaman_color"
    t.text "skills"
    t.integer "stats_reliability"
    t.integer "rounds_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "saved_mice_without_skills"
    t.integer "saved_mice_hard_without_skills"
    t.integer "saved_mice_divine_without_skills"
    t.integer "cheese_gathered"
    t.integer "firsts"
    t.integer "bootcamp"
    t.integer "survivor_rounds_played"
    t.integer "survivor_mice_killed"
    t.integer "survivor_shaman_rounds"
    t.integer "survivor_survived_rounds"
    t.integer "racing_rounds_played"
    t.integer "racing_finished_maps"
    t.integer "racing_firsts"
    t.integer "racing_podiums"
    t.integer "defilante_rounds_played"
    t.integer "defilante_finished_maps"
    t.integer "defilante_points"
    t.bigint "normal_score"
    t.integer "normal_rank"
    t.bigint "survivor_score"
    t.integer "survivor_rank"
    t.bigint "racing_score"
    t.integer "racing_rank"
    t.bigint "defilante_score"
    t.integer "defilante_rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "previous_normal_rank"
    t.integer "previous_survivor_rank"
    t.integer "previous_racing_rank"
    t.integer "previous_defilante_rank"
    t.integer "change_logs_count"
    t.index ["a801_id"], name: "index_players_on_a801_id", unique: true
    t.index ["defilante_rank"], name: "index_players_on_defilante_rank"
    t.index ["defilante_score"], name: "index_players_on_defilante_score"
    t.index ["name"], name: "index_players_on_name", unique: true
    t.index ["normal_rank"], name: "index_players_on_normal_rank"
    t.index ["normal_score"], name: "index_players_on_normal_score"
    t.index ["racing_rank"], name: "index_players_on_racing_rank"
    t.index ["racing_score"], name: "index_players_on_racing_score"
    t.index ["stats_reliability"], name: "index_players_on_stats_reliability"
    t.index ["survivor_rank"], name: "index_players_on_survivor_rank"
    t.index ["survivor_score"], name: "index_players_on_survivor_score"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "role", default: "user"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "change_logs", "players"
end
