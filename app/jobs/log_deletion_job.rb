# frozen_string_literal: true

class LogDeletionJob < ApplicationJob
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def perform
    ChangeLog.expired.destroy_all
  end
end
