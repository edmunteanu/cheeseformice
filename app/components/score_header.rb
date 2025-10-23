class ScoreHeader < ViewComponent::Base
  include PlayerRankChange

  attr_reader :player, :title, :category

  def initialize(player, previous_day_log, title:, category:)
    super
    @player = player
    @previous_day_log = previous_day_log
    @title = title
    @category = category
  end

  def display_score_change?
    score_change.present?
  end

  def score_change
    return if @previous_day_log.blank?

    value = @previous_day_log.public_send(:"#{@category}_score")

    return if value.zero?

    if value.positive?
      "<span class='d-flex align-items-center text-success'>#{number_with_delimiter(value)}" \
        "<i class='bi bi-chevron-up icon-sm ms-2'></i></span>"
    else
      "<span class='d-flex align-items-center text-danger'>#{number_with_delimiter(value.abs)}" \
        "<i class='bi bi-chevron-down icon-sm ms-2'></i></span>"
    end
  end
end
