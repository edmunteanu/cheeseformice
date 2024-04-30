# frozen_string_literal: true

class PlayerUpdateJob < ApplicationJob
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform
    PlayerUpdater.new.call
    RankUpdater.new.call
  end
end
