module PlayerHelper
  def display_ratio(ratio)
    return unless ratio.present? && ratio.positive?

    "(#{decimal_to_percentage(ratio)})"
  end

  def decimal_to_percentage(decimal)
    number_to_percentage(decimal * 100, precision: 2)
  end

  def humanized_title(title)
    translated_title = I18n.t(title, scope: "players.titles", default: title)

    formatted_title = if Player::ADMIN_TITLES.include?(title)
      "<span class='admin-title'>#{translated_title}</span>"
    else
      translated_title
    end

    "«#{formatted_title}»"
  end
end
