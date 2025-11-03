class PlayerUpdateJob < ApplicationJob
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform
    PlayerUpdateService.new.call

    update_metrics_overview
    update_materialized_views

    RankUpdateJob.perform_later
  end

  private

  def update_metrics_overview
    overview = MetricsOverview.instance
    previous_player_count = overview.player_count
    previous_disqualified_player_count = overview.disqualified_player_count

    overview.update(player_count: Player.count,
                    previous_player_count: previous_player_count,
                    disqualified_player_count: Player.disqualified.count,
                    previous_disqualified_player_count: previous_disqualified_player_count)
  end

  def update_materialized_views
    ChangeLogsPast7Days.refresh
    ChangeLogsPast30Days.refresh
  end
end
