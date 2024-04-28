# frozen_string_literal: true

class UpdateLog < ApplicationRecord
  enum status: { started: 'started', updating_players: 'updating_players', updating_ranks: 'updating_ranks',
                 finished: 'finished' }

  def time_lapsed
    return if created_at.blank? || completed_at.blank?

    time_lapsed = (completed_at - created_at).to_i
    hours = time_lapsed / 1.hour
    minutes = (time_lapsed % 1.hour) / 1.minute

    "#{hours}h #{minutes}m"
  end
end
