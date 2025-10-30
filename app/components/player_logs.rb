class PlayerLogs < ViewComponent::Base
  attr_reader :previous_month_logs, :category

  delegate :display_ratio, to: :helpers

  def initialize(previous_month_logs, category:)
    @previous_month_logs = previous_month_logs
    @category = category
  end

  def accordion_id
    "#{category}ChangeLogs"
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
    return display_score(value, span_class: "text-muted", icon_class: "bi bi-dash-lg icon-sm") if value.zero?
    return display_score(value, span_class: "text-success", icon_class: "bi bi-chevron-up icon-sm") if value.positive?

    display_score(value.abs, span_class: "text-danger", icon_class: "bi bi-chevron-down icon-sm")
  end

  def body_class(period)
    [
      "accordion-collapse collapse",
      expand_log?(period) ? "show" : nil
    ].compact.join(" ")
  end

  def player_score
    :"#{category}_score"
  end

  def player_attributes
    Player.const_get("#{category.upcase}_ATTRIBUTES")
  end

  def player_rounds_played
    category == :normal ? :rounds_played : :"#{category}_rounds_played"
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
      I18n.t("players.show.score", score: number_with_delimiter(score)),
      "<i class='#{icon_class} ms-2'></i>"
    ].join("")

    "<span class='d-flex align-items-center flex-shrink-0 ms-auto #{span_class}'>#{value}</span>"
  end
end
