# frozen_string_literal: true

module PlayerExtensions
  module ChangeLogs
    extend ActiveSupport::Concern

    included do
      has_many :change_logs, dependent: :destroy
    end

    def previous_day_change_log
      return @previous_day_change_log if instance_variable_defined?(:@previous_day_change_log)

      @previous_day_change_log = change_logs.previous_day.first
    end

    private

    def log_changes
      return if new_record?

      tracked_attributes = ChangeLog.column_names.excluding(%w[id player_id created_at updated_at])
      changed_attributes = changes.slice(*tracked_attributes)
      return if changed_attributes.empty?

      calculated_deltas = changed_attributes.transform_values { |values| values[1] - values[0] }
      change_logs.create!(calculated_deltas)
    end
  end
end
