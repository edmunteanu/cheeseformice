# frozen_string_literal: true

class PlayerStat < ViewComponent::Base
  attr_reader :player, :previous_day_log, :attribute, :style

  delegate :display_ratio, to: :helpers

  def initialize(player, previous_day_log, attribute:, style:, display_ratio: true)
    super
    @player = player
    @previous_day_log = previous_day_log
    @attribute = attribute
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
    return if previous_day_log.blank?

    previous_day_log.public_send(attribute)
  end
end
