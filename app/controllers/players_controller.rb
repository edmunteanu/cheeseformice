class PlayersController < AuthenticatedController
  MAX_LEADERBOARD_PAGES = 50
  SEARCH_TERM_MIN_LENGTH = 3
  SEARCH_TERM_REGEX = /\A\+?[A-Za-z0-9_#]+\z/ # Ruby-specific for server-side validation
  SEARCH_TERM_REGEX_JS = /^\+?[A-Za-z0-9_#]+$/ # JS-specific for client-side validation

  before_action :set_statistic, :set_category, :set_page, only: :index

  def index
    @current_page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @pagy, @players = pagy_countless(Player.ranked_by(statistic: @statistic), max_pages: MAX_LEADERBOARD_PAGES)
  end

  def show
    @player = Player.find_by!(name: Player.normalize_name(params[:name]))
    @previous_month_logs = @player.change_logs.previous_month.to_a
    @previous_day_log = @previous_month_logs.find { |logs| logs.created_at.to_date > 1.day.ago }
  end

  def search
    @search_term = params[:term].to_s.strip
    return @search_valid = true if @search_term.blank?

    @search_valid = valid_search_term?
    return unless @search_valid

    exact_match = Player.find_by(name: Player.normalize_name(@search_term))
    return redirect_to player_path(name: exact_match.name) if exact_match

    @search_results = SearchService.new(@search_term).perform_search
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
    params[:page] = params[:page].to_i.clamp(1, MAX_LEADERBOARD_PAGES)
  end

  def valid_search_term?
    @search_term.length >= SEARCH_TERM_MIN_LENGTH && @search_term.match?(SEARCH_TERM_REGEX)
  end
end
