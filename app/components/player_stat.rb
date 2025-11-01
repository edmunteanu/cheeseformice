class PlayerStat < ViewComponent::Base
  attr_reader :player, :past_day, :attribute, :style

  delegate :display_ratio, to: :helpers

  def initialize(player, past_day, attribute:, style:, display_ratio: true)
    @player = player
    @past_day = past_day
    @attribute = attribute
    @style = style
    @display_ratio = display_ratio
  end

  def display_ratio?
    @display_ratio
  end

  def display_change?
    past_day_value.present? && past_day_value.positive?
  end

  def past_day_value
    return if past_day.blank?

    past_day.public_send(attribute)
  end
end
