module HomeHelper
  def difference_to_previous(value, previous_value)
    delta = value - previous_value

    return display_delta(delta, span_class: "text-muted", icon_class: "bi bi-dash-lg icon-sm") if delta.zero?
    return display_delta(delta, span_class: "text-muted", icon_class: "bi bi-chevron-up icon-sm") if delta.positive?

    display_delta(delta.abs, span_class: "text-muted", icon_class: "bi bi-chevron-down icon-sm")
  end

  private

  def display_delta(value, span_class:, icon_class:)
    content = [ value, "<i class='#{icon_class} ms-2'></i>" ].join("")

    "<span class='d-flex align-items-center #{span_class} ms-3'>#{content}</span>"
  end
end
