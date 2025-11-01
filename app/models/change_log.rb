class ChangeLog < ApplicationRecord
  include PlayerExtensions::Ratio

  MAX_AMOUNT = 30

  belongs_to :player, counter_cache: true

  # Since there can be a log for the current day, and we want to create scopes for 30, 7 and 1 day(s),
  # we need to subtract one from the start of the created_at range.
  scope :past_day, -> { where(created_at: Time.current.beginning_of_day..) }
  scope :past_7_days, -> { where(created_at: 6.days.ago.beginning_of_day..) }
  scope :past_30_days, -> { where(created_at: 29.days.ago.beginning_of_day..) }
  scope :expired, -> { where(created_at: ...29.days.ago.beginning_of_day) }
end
