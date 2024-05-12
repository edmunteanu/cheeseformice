# frozen_string_literal: true

class ChangeLog < ApplicationRecord
  include PlayerExtensions::Ratio

  MAX_AMOUNT = 30
  EXPIRED_AFTER = MAX_AMOUNT - 1

  belongs_to :player, counter_cache: true

  scope(:previous_month, lambda do
    where('created_at >= ?', Date.current - EXPIRED_AFTER.days).order(created_at: :desc).limit(MAX_AMOUNT)
  end)
  scope :expired, -> { where('created_at < ?', Date.current - EXPIRED_AFTER.days) }
end
