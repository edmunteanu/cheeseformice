class PlayersController < AuthenticatedController
  MAX_LEADERBOARD_PAGES = 50
  SEARCH_TERM_REGEX_JS = /^\+?[A-Za-z0-9_#]+$/

  before_action :set_statistic, :set_category, :set_page, only: :index
  before_action :set_name, only: :show
  before_action :set_search_variables, only: :search

  def index
    @current_page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @pagy, @players = pagy_countless(Player.ranked_by(statistic: @statistic), max_pages: MAX_LEADERBOARD_PAGES)
  end

  def show
    @player = Player.find_by!(name: params[:name])
    @previous_month_logs = @player.change_logs.previous_month.to_a
    @previous_day_log = @previous_month_logs.find { |logs| logs.created_at.to_date > 1.day.ago }
  end

  def search
    return if @search_term.blank? || @search_invalid

    @search_results = []
  end

  private

  def set_statistic
    @statistic = if Player::LEADERBOARD_STATISTICS.values.flatten.include?(params[:statistic])
                   params[:statistic]
    else
                   "normal_score"
    end
  end

  def set_category
    @category = Player::LEADERBOARD_STATISTICS.key(
      Player::LEADERBOARD_STATISTICS.values.find { |types| types.include?(@statistic) }
    )
  end

  # The Pagy overflow extra does not work with the :max_pages option. Setting it to :last_page in the initializer
  # won't work with this setup, since it only allows :empty_page or :exception. Neither of these options are suitable
  # in this context, so we overwrite the page param if it exceeds the maximum number of pages.
  def set_page
    params[:page] = MAX_LEADERBOARD_PAGES if params[:page].to_i > MAX_LEADERBOARD_PAGES
  end

  # Same as the normalization in the Player model.
  def set_name
    prefix, first_alpha, remainder = params[:name].partition(/[A-Za-z]/)
    params[:name] = prefix + first_alpha.upcase + remainder.downcase
  end

  def set_search_variables
    @search_term = params[:term].to_s.strip
    @search_invalid = !valid_search_term?
  end

  SEARCH_TERM_MIN_LENGTH = 3
  SEARCH_TERM_REGEX = /\A\+?[A-Za-z0-9_#]+\z/
  def valid_search_term?
    @search_term.blank? || (@search_term.length >= SEARCH_TERM_MIN_LENGTH && @search_term.match?(SEARCH_TERM_REGEX))
  end
end
