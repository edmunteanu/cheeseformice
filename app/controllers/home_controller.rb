class HomeController < ApplicationController
  def index
    @metrics_overview = MetricsOverview.instance
    @last_player_update_at = GoodJob::Execution.where(job_class: "PlayerUpdateJob").last.finished_at
    @last_rank_update_at = GoodJob::Execution.where(job_class: "RankUpdateJob").last.finished_at
  end
end
