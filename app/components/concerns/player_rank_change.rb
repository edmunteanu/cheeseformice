module PlayerRankChange
  def displayed_rank_change_for(player, category)
    return "<span class='text-success'>#{I18n.t('score_header.new')}</span>" if rank_change_for(player, category).blank?

    return if rank_change_for(player, category).zero?

    if rank_change_for(player, category).positive?
      "<span class='d-flex align-items-center text-success'><i class='bi bi-chevron-up icon-sm me-2'></i>" \
        "#{number_with_delimiter(rank_change_for(player, category))}</span>"
    else
      "<span class='d-flex align-items-center text-danger'><i class='bi bi-chevron-down icon-sm me-2'></i>" \
        "#{number_with_delimiter(rank_change_for(player, category).abs)}</span>"
    end
  end

  private

  def rank_change_for(player, category)
    current_rank = player.public_send(:"#{category}_rank")
    previous_rank = player.public_send(:"previous_#{category}_rank")

    return if previous_rank.blank?

    previous_rank - current_rank
  end
end
