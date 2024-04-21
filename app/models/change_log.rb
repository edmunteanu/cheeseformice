# frozen_string_literal: true

class ChangeLog < ApplicationRecord
  # Brand new change logs are 0 days old. To keep exactly 30 change logs, we need to expire logs older than 29 days.
  MAX_AGE = 29.days

  belongs_to :player

  scope :expired, -> { where('created_at < ?', Date.current - MAX_AGE) }
end
