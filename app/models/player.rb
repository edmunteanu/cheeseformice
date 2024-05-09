# frozen_string_literal: true

class Player < ApplicationRecord
  include PlayerExtensions::Ratio
  include PlayerExtensions::NormalScore
  include PlayerExtensions::SurvivorScore
  include PlayerExtensions::RacingScore
  include PlayerExtensions::DefilanteScore
  include PlayerExtensions::Level
  include PlayerExtensions::ChangeLogs

  MAX_NAME_LENGTH = 100
  TAG_REGEX = /#\d{4}$/

  validates :a801_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true, length: { maximum: MAX_NAME_LENGTH }

  scope :qualified, -> { where.not(stats_reliability: 2) }

  after_validation :normalize_name
  before_save :update_scores, :log_changes # Order matters

  def to_param
    name.downcase
  end

  def disqualified?
    stats_reliability == 2
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
end
