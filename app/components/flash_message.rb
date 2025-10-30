class FlashMessage < ViewComponent::Base
  attr_reader :icon_class, :message

  def initialize(type, message, dismissible: true)
    @alert_class, @icon_class = infer_alert_and_icon(type)
    @message = message
    @dismissible = dismissible
  end

  def alert_style
    [
      "alert flash-message show",
      "alert-#{@alert_class}",
      dismissible? ? "fade alert-dismissible" : nil
    ].compact.join(" ")
  end

  def dismissible?
    @dismissible
  end

  private

  def infer_alert_and_icon(type)
    case type
    when "alert"
      %w[warning bi-exclamation-circle]
    when "notice", "success"
      %w[success bi-check-circle]
    when "error"
      %w[danger bi-exclamation-circle]
    else
      %w[info bi-info-circle]
    end
  end
end
