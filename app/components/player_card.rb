class PlayerCard < ViewComponent::Base
  include PlayerRankChange

  CATEGORY_FIELDS = {
    normal: %w[saved_mice cheese_gathered firsts rounds_played],
    racing: %w[racing_finished_maps racing_podiums racing_firsts racing_rounds_played],
    survivor: %w[survivor_shaman_rounds survivor_mice_killed survivor_survived_rounds survivor_rounds_played],
    defilante: %w[defilante_finished_maps defilante_points defilante_rounds_played]
  }

  attr_reader :player, :category, :statistic

  delegate :player_path, to: :helpers

  def initialize(player:, category:, statistic:, player_index:, current_page:)
    super
    @player = player
    @category = category
    @statistic = statistic
    @player_index = player_index
    @current_page = current_page
  end

  def score_statistic?
    %w[normal_score racing_score survivor_score defilante_score].include?(@statistic)
  end

  def current_rank
    if score_statistic?
      number_with_delimiter(@player.public_send(:"#{@category}_rank"))
    else
      # Calculate rank based on current page and index for non-score statistics, because they are not explicitly ranked
      statistic_rank = (@player_index + 1) + (@current_page - 1) * Pagy::DEFAULT[:limit]
      number_with_delimiter(statistic_rank)
    end
  end
end
