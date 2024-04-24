# frozen_string_literal: true

class FlashMessage < ViewComponent::Base
  attr_reader :alert_class, :icon_class, :message

  def initialize(type, message, dismissable: true)
    super
    @alert_class, @icon_class = calculate_alert_and_icon(type)
    @message = message
    @dismissable = dismissable
  end

  def dismissable?
    @dismissable
  end

  private

  def calculate_alert_and_icon(type)
    case type
    when 'alert'
      %w[warning bi-exclamation-circle]
    when 'notice', 'success'
      %w[success bi-check-circle]
    when 'error'
      %w[danger bi-exclamation-circle]
    else
      %w[info bi-info-circle]
    end
  end
end
