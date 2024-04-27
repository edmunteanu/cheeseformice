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

ActiveRecord::Schema[7.1].define(version: 2024_04_27_132526) do
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
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "change_logs", "players"
end
