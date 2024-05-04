# frozen_string_literal: true

module PlayerHelper
  def display_ratio(ratio)
    return unless ratio.present? && ratio.positive?

    "(#{number_to_percentage(ratio * 100, precision: 2)})"
  end
end
