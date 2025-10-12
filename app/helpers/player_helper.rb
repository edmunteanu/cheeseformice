module PlayerHelper
  def display_ratio(ratio)
    return unless ratio.present? && ratio.positive?

    "(#{decimal_to_percentage(ratio)})"
  end

  def decimal_to_percentage(decimal)
    number_to_percentage(decimal * 100, precision: 2)
  end
end
