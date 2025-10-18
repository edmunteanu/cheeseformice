module PlayerRankChange
  def displayed_rank_change
    return "<span class='text-success'>#{I18n.t('score_header.new')}</span>" if rank_change.blank?

    return if rank_change.zero?

    if rank_change.positive?
      "<span class='text-success'><i class='bi bi-chevron-up'></i> #{number_with_delimiter(rank_change)}</span>"
    else
      "<span class='text-danger'><i class='bi bi-chevron-down'></i> #{number_with_delimiter(rank_change.abs)}</span>"
    end
  end

  private

  def rank_change
    current_rank = @player.public_send(:"#{@category}_rank")
    previous_rank = @player.public_send(:"previous_#{@category}_rank")

    return if previous_rank.blank?

    previous_rank - current_rank
  end
end
