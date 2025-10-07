# frozen_string_literal: true

class PlayerLogs < ViewComponent::Base
  attr_reader :previous_month_logs, :type

  delegate :display_ratio, to: :helpers

  def initialize(previous_month_logs, type:)
    super
    @previous_month_logs = previous_month_logs
    @type = type
  end

  def accordion_id
    "#{type}ChangeLogs"
  end

  def previous_week_aggregated_log
    previous_week_logs = previous_month_logs.select { |log| log.created_at.to_date > 1.week.ago }

    aggregate_log_data(previous_week_logs)
  end

  def previous_month_aggregated_log
    aggregate_log_data(previous_month_logs)
  end

  def log_map
    @log_map ||= previous_month_logs.index_by { |log| log.created_at.to_date }
  end

  def button_class(period)
    [
      "accordion-button gap-3",
      expand_log?(period) ? nil : "collapsed"
    ].compact.join(" ")
  end

  def score_change(value)
    return display_score(value, span_class: "text-muted", icon_class: "bi bi-dash-lg") if value.zero?
    return display_score(value, span_class: "text-success", icon_class: "bi bi-chevron-up") if value.positive?

    display_score(value.abs, span_class: "text-danger", icon_class: "bi bi-chevron-down")
  end

  def body_class(period)
    [
      "accordion-collapse collapse",
      expand_log?(period) ? "show" : nil
    ].compact.join(" ")
  end

  def player_score
    :"#{type}_score"
  end

  def player_attributes
    Player.const_get("#{type.upcase}_ATTRIBUTES")
  end

  def player_rounds_played
    type == :normal ? :rounds_played : :"#{type}_rounds_played"
  end

  private

  def aggregate_log_data(logs)
    attributes = [ player_score ] + player_attributes
    aggregated = attributes.index_with { |_attr| 0 }

    attributes.each do |attr|
      aggregated[attr] = logs.sum { |log| log.public_send(attr) }
    end

    aggregated
  end

  def expand_log?(period)
    period == :previous_week
  end

  def display_score(score, span_class:, icon_class:)
    value = [
      I18n.t("players.score", score: number_with_delimiter(score)),
      "<i class='#{icon_class}'></i>"
    ].join(" ")

    "<span class='#{span_class} flex-shrink-0 ms-auto'>#{value}</span>"
  end
end
