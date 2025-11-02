class CreateMetricsOverview < ActiveRecord::Migration[8.0]
  def change
    create_table :metrics_overviews do |t|
      t.integer :player_count, null: false, default: 0
      t.integer :previous_player_count, null: false, default: 0
      t.integer :disqualified_player_count, null: false, default: 0
      t.integer :previous_disqualified_player_count, null: false, default: 0

      t.boolean :singleton_guard, null: false, default: true

      t.timestamps
    end

    add_index :metrics_overviews, :singleton_guard, unique: true
  end
end
