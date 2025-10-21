class RemoveStatsReliabilityIndexFromPlayers < ActiveRecord::Migration[8.0]
  def change
    remove_index :players, :stats_reliability
  end
end
