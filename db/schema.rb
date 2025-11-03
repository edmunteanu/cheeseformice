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

ActiveRecord::Schema[8.0].define(version: 2025_11_03_103837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_trgm"

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "category_standings", force: :cascade do |t|
    t.bigint "player_id", null: false
    t.bigint "normal_score"
    t.integer "normal_rank"
    t.integer "previous_normal_rank"
    t.bigint "racing_score"
    t.integer "racing_rank"
    t.integer "previous_racing_rank"
    t.bigint "survivor_score"
    t.integer "survivor_rank"
    t.integer "previous_survivor_rank"
    t.bigint "defilante_score"
    t.integer "defilante_rank"
    t.integer "previous_defilante_rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["defilante_rank"], name: "index_category_standings_on_defilante_rank"
    t.index ["normal_rank"], name: "index_category_standings_on_normal_rank"
    t.index ["player_id"], name: "index_category_standings_on_player_id", unique: true
    t.index ["racing_rank"], name: "index_category_standings_on_racing_rank"
    t.index ["survivor_rank"], name: "index_category_standings_on_survivor_rank"
  end

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
    t.index ["created_at", "player_id"], name: "index_change_logs_on_created_at_and_player_id"
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
    t.datetime "jobs_finished_at"
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
    t.uuid "process_id"
    t.interval "duration"
    t.index ["active_job_id", "created_at"], name: "index_good_job_executions_on_active_job_id_and_created_at"
    t.index ["process_id", "created_at"], name: "index_good_job_executions_on_process_id_and_created_at"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
    t.integer "lock_type", limit: 2
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
    t.uuid "locked_by_id"
    t.datetime "locked_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["batch_callback_id"], name: "index_good_jobs_on_batch_callback_id", where: "(batch_callback_id IS NOT NULL)"
    t.index ["batch_id"], name: "index_good_jobs_on_batch_id", where: "(batch_id IS NOT NULL)"
    t.index ["concurrency_key", "created_at"], name: "index_good_jobs_on_concurrency_key_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at_cond", where: "(cron_key IS NOT NULL)"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at_cond", unique: true, where: "(cron_key IS NOT NULL)"
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["job_class"], name: "index_good_jobs_on_job_class"
    t.index ["labels"], name: "index_good_jobs_on_labels", where: "(labels IS NOT NULL)", using: :gin
    t.index ["locked_by_id"], name: "index_good_jobs_on_locked_by_id", where: "(locked_by_id IS NOT NULL)"
    t.index ["priority", "created_at"], name: "index_good_job_jobs_for_candidate_lookup", where: "(finished_at IS NULL)"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["priority", "scheduled_at"], name: "index_good_jobs_on_priority_scheduled_at_unfinished_unlocked", where: "((finished_at IS NULL) AND (locked_by_id IS NULL))"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "metrics_overviews", force: :cascade do |t|
    t.integer "player_count", default: 0, null: false
    t.integer "previous_player_count", default: 0, null: false
    t.integer "disqualified_player_count", default: 0, null: false
    t.integer "previous_disqualified_player_count", default: 0, null: false
    t.boolean "singleton_guard", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["singleton_guard"], name: "index_metrics_overviews_on_singleton_guard", unique: true
  end

  create_table "players", force: :cascade do |t|
    t.bigint "a801_id", null: false
    t.boolean "updated_last_7_days", default: false, null: false
    t.string "name", null: false, collation: "C"
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "change_logs_count"
    t.index ["a801_id"], name: "index_players_on_a801_id", unique: true
    t.index ["bootcamp"], name: "index_players_on_bootcamp"
    t.index ["cheese_gathered"], name: "index_players_on_cheese_gathered"
    t.index ["defilante_finished_maps"], name: "index_players_on_defilante_finished_maps"
    t.index ["defilante_points"], name: "index_players_on_defilante_points"
    t.index ["firsts"], name: "index_players_on_firsts"
    t.index ["name"], name: "index_players_on_name", unique: true
    t.index ["name"], name: "index_players_on_name_trgm", opclass: :gin_trgm_ops, using: :gin
    t.index ["racing_finished_maps"], name: "index_players_on_racing_finished_maps"
    t.index ["racing_firsts"], name: "index_players_on_racing_firsts"
    t.index ["racing_podiums"], name: "index_players_on_racing_podiums"
    t.index ["saved_mice"], name: "index_players_on_saved_mice"
    t.index ["saved_mice_divine"], name: "index_players_on_saved_mice_divine"
    t.index ["saved_mice_divine_without_skills"], name: "index_players_on_saved_mice_divine_without_skills"
    t.index ["saved_mice_hard"], name: "index_players_on_saved_mice_hard"
    t.index ["saved_mice_hard_without_skills"], name: "index_players_on_saved_mice_hard_without_skills"
    t.index ["saved_mice_without_skills"], name: "index_players_on_saved_mice_without_skills"
    t.index ["survivor_mice_killed"], name: "index_players_on_survivor_mice_killed"
    t.index ["survivor_shaman_rounds"], name: "index_players_on_survivor_shaman_rounds"
    t.index ["survivor_survived_rounds"], name: "index_players_on_survivor_survived_rounds"
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

  add_foreign_key "category_standings", "players"
  add_foreign_key "change_logs", "players"

  create_view "change_logs_past_30_days", materialized: true, sql_definition: <<-SQL
      SELECT player_id,
      sum(rounds_played) AS rounds_played,
      sum(shaman_cheese) AS shaman_cheese,
      sum(saved_mice) AS saved_mice,
      sum(saved_mice_hard) AS saved_mice_hard,
      sum(saved_mice_divine) AS saved_mice_divine,
      sum(saved_mice_without_skills) AS saved_mice_without_skills,
      sum(saved_mice_hard_without_skills) AS saved_mice_hard_without_skills,
      sum(saved_mice_divine_without_skills) AS saved_mice_divine_without_skills,
      sum(cheese_gathered) AS cheese_gathered,
      sum(firsts) AS firsts,
      sum(bootcamp) AS bootcamp,
      sum(survivor_rounds_played) AS survivor_rounds_played,
      sum(survivor_mice_killed) AS survivor_mice_killed,
      sum(survivor_shaman_rounds) AS survivor_shaman_rounds,
      sum(survivor_survived_rounds) AS survivor_survived_rounds,
      sum(racing_rounds_played) AS racing_rounds_played,
      sum(racing_finished_maps) AS racing_finished_maps,
      sum(racing_firsts) AS racing_firsts,
      sum(racing_podiums) AS racing_podiums,
      sum(defilante_rounds_played) AS defilante_rounds_played,
      sum(defilante_finished_maps) AS defilante_finished_maps,
      sum(defilante_points) AS defilante_points,
      sum(normal_score) AS normal_score,
      sum(survivor_score) AS survivor_score,
      sum(racing_score) AS racing_score,
      sum(defilante_score) AS defilante_score
     FROM change_logs
    WHERE (created_at >= (CURRENT_DATE - 'P29D'::interval))
    GROUP BY player_id;
  SQL
  add_index "change_logs_past_30_days", ["player_id"], name: "index_change_logs_past_30_days_on_player_id", unique: true

  create_view "change_logs_past_7_days", materialized: true, sql_definition: <<-SQL
      SELECT player_id,
      sum(rounds_played) AS rounds_played,
      sum(shaman_cheese) AS shaman_cheese,
      sum(saved_mice) AS saved_mice,
      sum(saved_mice_hard) AS saved_mice_hard,
      sum(saved_mice_divine) AS saved_mice_divine,
      sum(saved_mice_without_skills) AS saved_mice_without_skills,
      sum(saved_mice_hard_without_skills) AS saved_mice_hard_without_skills,
      sum(saved_mice_divine_without_skills) AS saved_mice_divine_without_skills,
      sum(cheese_gathered) AS cheese_gathered,
      sum(firsts) AS firsts,
      sum(bootcamp) AS bootcamp,
      sum(survivor_rounds_played) AS survivor_rounds_played,
      sum(survivor_mice_killed) AS survivor_mice_killed,
      sum(survivor_shaman_rounds) AS survivor_shaman_rounds,
      sum(survivor_survived_rounds) AS survivor_survived_rounds,
      sum(racing_rounds_played) AS racing_rounds_played,
      sum(racing_finished_maps) AS racing_finished_maps,
      sum(racing_firsts) AS racing_firsts,
      sum(racing_podiums) AS racing_podiums,
      sum(defilante_rounds_played) AS defilante_rounds_played,
      sum(defilante_finished_maps) AS defilante_finished_maps,
      sum(defilante_points) AS defilante_points,
      sum(normal_score) AS normal_score,
      sum(survivor_score) AS survivor_score,
      sum(racing_score) AS racing_score,
      sum(defilante_score) AS defilante_score
     FROM change_logs
    WHERE (created_at >= (CURRENT_DATE - 'P6D'::interval))
    GROUP BY player_id;
  SQL
  add_index "change_logs_past_7_days", ["player_id"], name: "index_change_logs_past_7_days_on_player_id", unique: true

end
