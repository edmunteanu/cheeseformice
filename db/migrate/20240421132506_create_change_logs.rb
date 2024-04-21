# frozen_string_literal: true

class CreateChangeLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :change_logs do |t|
      t.belongs_to :player, null: false, foreign_key: true

      t.integer :rounds_played, default: 0, null: false
      t.integer :shaman_cheese, default: 0, null: false
      t.integer :saved_mice, default: 0, null: false
      t.integer :saved_mice_hard, default: 0, null: false
      t.integer :saved_mice_divine, default: 0, null: false
      t.integer :saved_mice_without_skills, default: 0, null: false
      t.integer :saved_mice_hard_without_skills, default: 0, null: false
      t.integer :saved_mice_divine_without_skills, default: 0, null: false
      t.integer :cheese_gathered, default: 0, null: false
      t.integer :firsts, default: 0, null: false
      t.integer :bootcamp, default: 0, null: false

      t.integer :survivor_rounds_played, default: 0, null: false
      t.integer :survivor_mice_killed, default: 0, null: false
      t.integer :survivor_shaman_rounds, default: 0, null: false
      t.integer :survivor_survived_rounds, default: 0, null: false

      t.integer :racing_rounds_played, default: 0, null: false
      t.integer :racing_finished_maps, default: 0, null: false
      t.integer :racing_firsts, default: 0, null: false
      t.integer :racing_podiums, default: 0, null: false

      t.integer :defilante_rounds_played, default: 0, null: false
      t.integer :defilante_finished_maps, default: 0, null: false
      t.integer :defilante_points, default: 0, null: false

      t.integer :normal_score, default: 0, null: false
      t.integer :survivor_score, default: 0, null: false
      t.integer :racing_score, default: 0, null: false
      t.integer :defilante_score, default: 0, null: false

      t.timestamps
    end
  end
end
