# frozen_string_literal: true

class ChangeLog < ApplicationRecord
  belongs_to :player, counter_cache: true

  # Hint: If the created_at date of the latest change log is the same as the current date, the change log contains
  # player statistics accumulated the previous day. This is because of how the updating mechanism works.
  scope :previous_day, -> { where('created_at >= ?', Date.current - 1.day).order(created_at: :desc).limit(1) }
  scope :previous_week, -> { where('created_at >= ?', Date.current - 1.week).order(created_at: :desc).limit(7) }
  scope(:previous_month, lambda do
    where('created_at >= ?', Date.current - 1.month).order(created_at: :desc).limit(30)
  end)
  scope :expired, -> { where('created_at < ?', Date.current - 1.month) }
end
