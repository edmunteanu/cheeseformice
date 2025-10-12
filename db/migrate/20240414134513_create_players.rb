class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.bigint :a801_id, null: false, index: { unique: true }
      t.boolean :updated_last_7_days, default: false, null: false

      t.string :name, null: false, index: { unique: true }
      t.date :registration_date

      t.text :title
      t.text :unlocked_titles

      t.integer :experience

      t.text :look
      t.text :badges
      t.text :dress_list
      t.text :mouse_color
      t.text :shaman_color
      t.text :skills

      t.integer :stats_reliability
      t.integer :rounds_played
      t.integer :shaman_cheese
      t.integer :saved_mice
      t.integer :saved_mice_hard
      t.integer :saved_mice_divine
      t.integer :saved_mice_without_skills
      t.integer :saved_mice_hard_without_skills
      t.integer :saved_mice_divine_without_skills
      t.integer :cheese_gathered
      t.integer :firsts
      t.integer :bootcamp

      t.integer :survivor_rounds_played
      t.integer :survivor_mice_killed
      t.integer :survivor_shaman_rounds
      t.integer :survivor_survived_rounds

      t.integer :racing_rounds_played
      t.integer :racing_finished_maps
      t.integer :racing_firsts
      t.integer :racing_podiums

      t.integer :defilante_rounds_played
      t.integer :defilante_finished_maps
      t.integer :defilante_points

      t.bigint :normal_score, index: true
      t.integer :normal_rank, index: true
      t.bigint :survivor_score, index: true
      t.integer :survivor_rank, index: true
      t.bigint :racing_score, index: true
      t.integer :racing_rank, index: true
      t.bigint :defilante_score, index: true
      t.integer :defilante_rank, index: true

      t.timestamps
    end
  end
end
