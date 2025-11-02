class PopulateMetricsOverview < ActiveRecord::Migration[8.0]
  def up
    MetricsOverview.instance.update(player_count: Player.count,
                                    previous_player_count: Player.count,
                                    disqualified_player_count: Player.disqualified.count,
                                    previous_disqualified_player_count: Player.disqualified.count)
  end

  def down
    MetricsOverview.instance.update(player_count: 0,
                                    previous_player_count: 0,
                                    disqualified_player_count: 0,
                                    previous_disqualified_player_count: 0)
  end
end
