# frozen_string_literal: true

class PlayerStat < ViewComponent::Base
  attr_reader :player, :previous_day, :attribute, :style

  delegate :display_ratio, to: :helpers

  def initialize(player, previous_day, attribute:, style:, display_ratio: true)
    super
    @player = player
    @previous_day = previous_day
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
    return if previous_day.blank?

    previous_day.public_send(attribute)
  end
end
