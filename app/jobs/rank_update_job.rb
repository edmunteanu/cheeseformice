class RankUpdateJob < ApplicationJob
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform
    RankUpdateService.new.call

    LogDeletionJob.perform_later
  end
end
