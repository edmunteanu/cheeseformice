# frozen_string_literal: true

class PlayerUpdateJob < ApplicationJob
  retry_on StandardError, wait: :polynomially_longer, attempts: 3

  def perform
    update_log = UpdateLog.create!

    update_players(update_log)
    update_ranks(update_log)

    update_log.update!(status: :finished, completed_at: Time.zone.now)
  rescue StandardError => e
    update_log.update!(error_message: e.message)

    raise e
  end

  private

  def update_players(update_log)
    update_log.updating_players!

    PlayerUpdater.new.call
  end

  def update_ranks(update_log)
    update_log.updating_ranks!

    RankUpdater.new.call
  end
end
