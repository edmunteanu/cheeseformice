# frozen_string_literal: true

class ScoreHeader < ViewComponent::Base
  attr_reader :player, :title, :title_path

  def initialize(player, title:, type:, display_score_change: true, title_path: nil)
    super
    @player = player
    @title = title
    @type = type
    @display_score_change = display_score_change
    @title_path = title_path
  end

  def score
    player.public_send(:"#{@type}_score")
  end

  def display_score_change?
    @display_score_change && score_change.present?
  end

  def score_change
    return if previous_day.blank?

    value = previous_day.public_send(:"#{@type}_score")

    return if value.zero?

    if value.positive?
      "<span class='text-success'>#{number_with_delimiter(value)} <i class='bi bi-chevron-up'></i></span>"
    else
      "<span class='text-danger'>#{number_with_delimiter(value.abs)} <i class='bi bi-chevron-down'></i></span>"
    end
  end

  def rank
    player.public_send(:"#{@type}_rank")
  end

  def displayed_rank_change
    return "<span class='text-success'>#{I18n.t('score_header.new')}</span>" if rank_change.blank?

    return if rank_change.zero?

    if rank_change.positive?
      "<span class='text-success'><i class='bi bi-chevron-up'></i> #{number_with_delimiter(rank_change)}</span>"
    else
      "<span class='text-danger'><i class='bi bi-chevron-down'></i> #{number_with_delimiter(rank_change.abs)}</span>"
    end
  end

  private

  def previous_day
    player.change_logs.previous_day.first
  end

  def rank_change
    current_rank = player.public_send(:"#{@type}_rank")
    previous_rank = player.public_send(:"previous_#{@type}_rank")

    return if previous_rank.blank?

    previous_rank - current_rank
  end
end
