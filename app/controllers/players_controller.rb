class PlayersController < AuthenticatedController
  MAX_LEADERBOARD_PAGES = 50

  before_action :sanitize_page, only: :index
  before_action :capitalize_name, only: :show

  def index
    # TODO: Sort by normal_rank, survivor_rank, racing_rank, defilante_rank (based on query param)
    #   once the players are sorted by the respective scores and the ranks persisted to the DB.
    @pagy, @players = pagy_countless(Player.qualified.order(:normal_rank), max_pages: MAX_LEADERBOARD_PAGES)
  end

  def show
    @player = Player.find_by!(name: params[:id])
    @previous_month_logs = @player.change_logs.previous_month.to_a
    @previous_day_log = @previous_month_logs.find { |logs| logs.created_at.to_date > 1.day.ago }
  end

  private

  # The Pagy overflow extra does not work with the :max_pages option. Setting it to :last_page in the initializer
  # won't work with this setup, since it only allows :empty_page or :exception. Neither of these options are suitable
  # in this context, so we overwrite the page param if it exceeds the maximum number of pages.
  def sanitize_page
    params[:page] = MAX_LEADERBOARD_PAGES if params[:page].to_i > MAX_LEADERBOARD_PAGES
  end

  # Same as the normalization in the Player model.
  def capitalize_name
    prefix, first_alpha, remainder = params[:id].partition(/[A-Za-z]/)
    params[:id] = prefix + first_alpha.upcase + remainder.downcase
  end
end
