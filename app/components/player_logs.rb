# frozen_string_literal: true

class PlayerLogs < ViewComponent::Base
  attr_reader :logs

  delegate :display_ratio, to: :helpers

  def initialize(logs)
    super
    @logs = logs
  end

  def log_map
    logs.index_by { |log| log.created_at.to_date }
  end

  def score_change(value)
    return display_score(value, span_class: 'text-muted', icon_class: 'bi bi-dash-lg') if value.zero?
    return display_score(value, span_class: 'text-success', icon_class: 'bi bi-chevron-up') if value.positive?

    display_score(value.abs, span_class: 'text-danger', icon_class: 'bi bi-chevron-down')
  end

  private

  def display_score(score, span_class:, icon_class:)
    value = [
      I18n.t('players.score', score: number_with_delimiter(score)),
      "<i class='#{icon_class}'></i>"
    ].join(' ')

    "<span class='#{span_class}'>#{value}</span>"
  end
end
