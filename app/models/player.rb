# frozen_string_literal: true

class Player < ApplicationRecord
  include PlayerCalculators::NormalScore
  include PlayerCalculators::SurvivorScore
  include PlayerCalculators::RacingScore
  include PlayerCalculators::DefilanteScore
  include PlayerCalculators::Level

  MAX_NAME_LENGTH = 100
  TAG_REGEX = /#\d{4}$/

  has_many :change_logs, dependent: :destroy

  validates :a801_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true, length: { maximum: MAX_NAME_LENGTH }

  scope :eligible_for_ranking, -> { where.not(stats_reliability: 2) }

  after_validation :normalize_name
  before_save :update_scores, :log_changes

  def to_param
    name
  end

  private

  def normalize_name
    return if name.blank?

    prefix, first_alpha, remainder = name.partition(/[A-Za-z]/)
    normalized_name = prefix + first_alpha.upcase + remainder.downcase
    normalized_name += '#0000' unless normalized_name.match?(TAG_REGEX)

    self.name = normalized_name
  end

  def update_scores
    self.normal_score = calculate_normal_score
    self.survivor_score = calculate_survivor_score
    self.racing_score = calculate_racing_score
    self.defilante_score = calculate_defilante_score
  end

  def log_changes
    return if new_record?

    tracked_attributes = ChangeLog.column_names.excluding(%w[id player_id created_at updated_at])
    changed_attributes = changes.slice(*tracked_attributes)
    return if changed_attributes.empty?

    calculated_deltas = changed_attributes.transform_values { |values| values[1] - values[0] }
    change_logs.create!(calculated_deltas)
  end
end
