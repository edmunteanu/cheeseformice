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
  before_save :update_scores

  private

  def normalize_name
    self.name = "#{name}#0000" if name.present? && !name.match?(TAG_REGEX)
  end

  def update_scores
    self.normal_score = calculate_normal_score
    self.survivor_score = calculate_survivor_score
    self.racing_score = calculate_racing_score
    self.defilante_score = calculate_defilante_score
  end
end
