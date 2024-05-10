# frozen_string_literal: true

class PlayerStat < ViewComponent::Base
  attr_reader :player, :stat, :style

  delegate :display_ratio, to: :helpers

  def initialize(player, stat:, style:, display_ratio: true)
    super
    @player = player
    @stat = stat
    @style = style
    @display_ratio = display_ratio
  end

  def display_ratio?
    @display_ratio
  end

  def display_change?
    previous_day_value.present? && previous_day_value.positive?
  end

  def previous_day_value
    return if player.previous_day_change_log.blank?

    player.previous_day_change_log.public_send(stat)
  end
end
