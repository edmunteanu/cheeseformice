class PlayerUpdateJob < ApplicationJob
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform
    PlayerUpdateService.new.call

    RankUpdateJob.perform_later
  end
end
