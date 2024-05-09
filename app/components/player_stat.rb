# frozen_string_literal: true

class PlayerStat < ViewComponent::Base
  attr_reader :player

  delegate :display_ratio, to: :helpers

  def initialize(player, stat:, col_setup:, display_ratio: true)
    super
    @player = player
    @stat = stat
    @col_setup = col_setup
    @display_ratio = display_ratio
  end

  def container_classes
    [@col_setup, 'd-flex flex-column justify-content-between'].join(' ')
  end

  def title
    Player.human_attribute_name(@stat)
  end

  def value
    player.public_send(@stat)
  end

  def display_ratio?
    @display_ratio
  end

  def ratio
    player.public_send(:"#{@stat}_ratio")
  end

  def display_change?
    previous_day_value.present? && previous_day_value.positive?
  end

  def previous_day_value
    return if previous_day.blank?

    previous_day.public_send(@stat)
  end

  def previous_day_ratio
    return if previous_day.blank?

    previous_day.public_send(:"#{@stat}_ratio")
  end

  private

  def previous_day
    player.change_logs.previous_day.first
  end
end
