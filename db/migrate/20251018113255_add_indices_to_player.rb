class AddIndicesToPlayer < ActiveRecord::Migration[8.0]
  def change
    # Normal leaderboard stats
    add_index :players, :saved_mice
    add_index :players, :saved_mice_hard
    add_index :players, :saved_mice_divine
    add_index :players, :saved_mice_without_skills
    add_index :players, :saved_mice_hard_without_skills
    add_index :players, :saved_mice_divine_without_skills
    add_index :players, :cheese_gathered
    add_index :players, :firsts
    add_index :players, :bootcamp

    # Racing leaderboard stats
    add_index :players, :racing_firsts
    add_index :players, :racing_podiums
    add_index :players, :racing_finished_maps

    # Survivor leaderboard stats
    add_index :players, :survivor_shaman_rounds
    add_index :players, :survivor_mice_killed
    add_index :players, :survivor_survived_rounds

    # Defilante leaderboard stats
    add_index :players, :defilante_points
    add_index :players, :defilante_finished_maps
  end
end
