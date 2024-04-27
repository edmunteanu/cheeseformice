# frozen_string_literal: true

class PlayersController < ApplicationController
  def index
    # TODO: Sort by normal_rank, survivor_rank, racing_rank, defilante_rank (based on query param)
    #   once the players are sorted by the respective scores and the ranks persisted to the DB.
    # TODO: Add caching after checking the leaderboard performance in production.
    # count = Rails.cache.fetch('players_count', expires_in: 1.hour) do
    #   Player.eligible_for_ranking.count
    # end
    # @pagy, @players = pagy(Player.eligible_for_ranking.order(:normal_rank), count: count)
    @pagy, @players = pagy(Player.eligible_for_ranking.order(:normal_rank))
  end
end
