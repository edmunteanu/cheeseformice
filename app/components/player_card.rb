class PlayerCard < ViewComponent::Base
  include PlayerRankChange

  CATEGORY_ATTRIBUTES = {
    normal: %i[saved_mice cheese_gathered firsts rounds_played],
    racing: %i[racing_finished_maps racing_podiums racing_firsts racing_rounds_played],
    survivor: %i[survivor_shaman_rounds survivor_mice_killed survivor_survived_rounds survivor_rounds_played],
    defilante: %i[defilante_finished_maps defilante_points defilante_rounds_played]
  }

  attr_reader :player, :category, :statistic

  delegate :player_path, to: :helpers

  def initialize(player:, category:, statistic:, time_range:, player_index:, current_page:)
    @player = player
    @category = category
    @statistic = statistic
    @time_range = time_range
    @change_log = set_change_log
    @player_index = player_index
    @current_page = current_page
  end

  def category_score
    score = show_player_data? ? player.public_send(score_attribute) : @change_log.public_send(score_attribute)
    I18n.t(category, scope: "players.index.scores", score: number_with_delimiter(score))
  end

  def show_player_data?
    @time_range == Player::TIME_RANGE_DEFAULT
  end

  def score_attribute
    :"#{category}_score"
  end

  def current_rank
    if score_statistic? && show_player_data?
      number_with_delimiter(player.public_send(:"#{@category}_rank"))
    else
      statistic_rank = (@player_index + 1) + (@current_page - 1) * Pagy::DEFAULT[:limit]
      number_with_delimiter(statistic_rank)
    end
  end

  def score_statistic?
    %i[normal_score racing_score survivor_score defilante_score].include?(statistic)
  end

  def column_classes
    "col-6 col-md-#{12 / CATEGORY_ATTRIBUTES[category].count}"
  end

  def category_attribute_value(attribute)
    value = show_player_data? ? player.public_send(attribute) : @change_log.public_send(attribute)
    number_with_delimiter(value)
  end

  def statistic_value
    value = show_player_data? ? player.public_send(statistic) : @change_log.public_send(statistic)
    number_with_delimiter(value)
  end

  def category_rounds_played_attribute
    base = "rounds_played"
    base.prepend("#{category}_") unless category == :normal
    base.to_sym
  end

  def category_rounds_played_value
    value = if show_player_data?
              player.public_send(category_rounds_played_attribute)
    else
              @change_log.public_send(category_rounds_played_attribute)
    end

    number_with_delimiter(value)
  end

  private

  def set_change_log
    case @time_range
    when :past_day
      player.change_logs_past_day.first
    when :past_7_days
      player.change_logs_past_7_days
    when :past_30_days
      player.change_logs_past_30_days
    else
      nil
    end
  end
end
