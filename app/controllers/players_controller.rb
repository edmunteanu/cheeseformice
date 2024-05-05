# frozen_string_literal: true

class PlayersController < AuthenticatedController
  MAX_LEADERBOARD_PAGES = 50

  before_action :sanitize_params, only: :index

  def index
    # TODO: Sort by normal_rank, survivor_rank, racing_rank, defilante_rank (based on query param)
    #   once the players are sorted by the respective scores and the ranks persisted to the DB.
    @pagy, @players = pagy_countless(Player.eligible_for_ranking.order(:normal_rank), max_pages: MAX_LEADERBOARD_PAGES)
  end

  def show
    # TODO: Handle the case where the player does not exist, otherwise there's a 500 error.
    @player = Player.find_by(name: params[:id])
  end

  private

  # The Pagy overflow extra does not work with the :max_pages option. Setting it to :last_page in the initializer
  # won't work with this setup, since it only allows :empty_page or :exception. Neither of these options are suitable
  # in this context, so we overwrite the page param if it exceeds the maximum number of pages.
  def sanitize_params
    params[:page] = MAX_LEADERBOARD_PAGES if params[:page].to_i > MAX_LEADERBOARD_PAGES
  end
end
