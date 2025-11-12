class PlayersController < ApplicationController
  SEARCH_TERM_MIN_LENGTH = 3
  SEARCH_TERM_REGEX = /\A\+?[A-Za-z0-9_#]+\z/ # Ruby-specific for server-side validation
  SEARCH_TERM_REGEX_JS = /^\+?[A-Za-z0-9_#]+$/ # JS-specific for client-side validation

  before_action :set_statistic, :set_category, :set_time_range, only: :index

  def index
    @current_page = params[:page].to_i.zero? ? 1 : params[:page].to_i

    # We know that the Player.ranked_by is always going to return more than enough records for the max amount
    # of pages, since we simply order differently based on the statistic and time range.
    @pagy, @players = pagy(:countless, Player.ranked_by(@statistic, @time_range), last: Pagy.options[:max_pages])
  end

  def show
    @player = Player.find_by!(name: Player.normalize_name(params[:name]))
    @past_day = @player.change_logs_past_day
    @past_7_days = @player.change_logs.past_7_days.to_a
    @past_30_days = @player.change_logs.past_30_days.to_a
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
    @statistic = if params[:statistic].present? &&
                    Player::LEADERBOARD_STATISTICS.values.flatten.include?(params[:statistic].to_sym)
                   params[:statistic].to_sym
    else
                   Player::LEADERBOARD_DEFAULT
    end
  end

  def set_category
    @category = Player::LEADERBOARD_STATISTICS.key(
      Player::LEADERBOARD_STATISTICS.values.find { |types| types.include?(@statistic) }
    )
  end

  def set_time_range
    @time_range = if params[:time_range].present? && Player::TIME_RANGES.include?(params[:time_range].to_sym)
                    params[:time_range].to_sym
    else
                    Player::TIME_RANGE_DEFAULT
    end
  end

  def valid_search_term?
    @search_term.length >= SEARCH_TERM_MIN_LENGTH && @search_term.match?(SEARCH_TERM_REGEX)
  end
end
