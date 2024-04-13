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

ActiveRecord::Schema[7.1].define(version: 0) do
  create_table "lastupdate_transformice", id: false, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "label", limit: 100
    t.datetime "lastupdate", precision: nil
    t.index ["label"], name: "label", unique: true
  end

  create_table "lastupdate_tribulle", id: false, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "label", limit: 100
    t.datetime "lastupdate", precision: nil
    t.index ["label"], name: "label", unique: true
  end

  create_table "map", id: :integer, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "author", limit: 100, null: false
    t.text "xml", null: false
    t.integer "p", limit: 1, null: false
  end

  create_table "member", primary_key: ["id_tribe", "id_member"], charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.bigint "id_tribe", null: false
    t.bigint "id_member", default: 0, null: false
    t.string "name", limit: 100, null: false, collation: "utf8_general_ci"
    t.bigint "id_spouse", default: 0, null: false
    t.bigint "id_gender", default: 0, null: false
    t.datetime "marriage_date", precision: nil
    t.index ["id_member"], name: "id_member"
    t.index ["name"], name: "name"
  end

  create_table "player", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "updatedLast7days", limit: 1
    t.string "name", limit: 100
    t.date "registration_date"
    t.text "title"
    t.text "unlocked_titles"
    t.integer "experience"
    t.text "look"
    t.text "badges"
    t.text "dress_list"
    t.text "color1"
    t.text "color2"
    t.text "skills"
    t.integer "stats_reliability"
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
    t.index ["name"], name: "name"
  end

  create_table "stats_season_1", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_10", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_11", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_2", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_3", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_4", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_5", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_6", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_7", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_8", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "stats_season_9", id: :bigint, default: nil, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "round_played"
    t.integer "shaman_cheese"
    t.integer "saved_mice"
    t.integer "saved_mice_hard"
    t.integer "saved_mice_divine"
    t.integer "cheese_gathered"
    t.integer "first"
    t.integer "bootcamp"
    t.integer "survivor_round_played"
    t.integer "survivor_mouse_killed"
    t.integer "survivor_shaman_count"
    t.integer "survivor_survivor_count"
    t.integer "racing_round_played"
    t.integer "racing_finished_map"
    t.integer "racing_first"
    t.integer "racing_podium"
    t.integer "defilante_round_played"
    t.integer "defilante_finished_map"
    t.integer "defilante_points"
    t.integer "saved_mice_ns"
    t.integer "saved_mice_hard_ns"
    t.integer "saved_mice_divine_ns"
  end

  create_table "tribe", id: :bigint, default: 0, charset: "utf8mb4", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.string "name", limit: 50, null: false, collation: "utf8_general_ci"
    t.index ["name"], name: "name"
  end

end
