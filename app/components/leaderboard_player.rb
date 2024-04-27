# frozen_string_literal: true

class LeaderboardPlayer < ViewComponent::Base
  attr_reader :player

  def initialize(player, score_type)
    super
    @player = player
    @score_type = score_type
  end

  def displayed_rank_progression
    return "<span class='text-success'>#{I18n.t('leaderboard_player.new')}</span>" if rank_progression.blank?

    return if rank_progression.zero?

    if rank_progression.positive?
      "<span class='text-success'><i class='bi bi-chevron-up'></i> #{rank_progression}</span>"
    else
      "<span class='text-danger'><i class='bi bi-chevron-down'></i> #{rank_progression.abs}</span>"
    end
  end

  private

  def rank_progression
    current_rank = player.public_send(:"#{@score_type}_rank")
    previous_rank = player.public_send(:"previous_#{@score_type}_rank")

    return if previous_rank.blank?

    previous_rank - current_rank
  end
end
