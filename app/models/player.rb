class Player < ApplicationRecord
  include PlayerExtensions::Ratio
  include PlayerExtensions::NormalScore
  include PlayerExtensions::SurvivorScore
  include PlayerExtensions::RacingScore
  include PlayerExtensions::DefilanteScore
  include PlayerExtensions::Level
  include PlayerExtensions::Leaderboard

  MAX_NAME_LENGTH = 100
  TAG_REGEX = /#\d{4}$/
  ADMIN_TAG = "0001"
  ADMIN_TITLES = %w[440 442 444 445 446 447 448 449 450 451 452 453 454 534].freeze
  MODERATOR_TAG = "0010"
  SENTINEL_TAG = "0015"
  MAP_CREW_TAG = "0020"

  has_one :category_standing, autosave: true, dependent: :destroy
  has_many :change_logs, dependent: :destroy
  has_many :change_logs_past_day, -> { past_day }, class_name: "ChangeLog"
  has_many :change_logs_past_7_days, -> { past_7_days }, class_name: "ChangeLog"
  has_many :change_logs_past_30_days, -> { past_30_days }, class_name: "ChangeLog"

  scope :qualified, -> { where.not(stats_reliability: 2) }

  validates :a801_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true, length: { maximum: MAX_NAME_LENGTH }

  after_validation :prepare_name
  before_save :update_scores, :log_changes # Order matters

  delegate :normal_score, :normal_rank, :previous_normal_rank,
           :survivor_score, :survivor_rank, :previous_survivor_rank,
           :racing_score, :racing_rank, :previous_racing_rank,
           :defilante_score, :defilante_rank, :previous_defilante_rank,
           to: :category_standing, allow_nil: true

  def self.normalize_name(name)
    prefix, first_alpha, remainder = name.partition(/[A-Za-z]/)
    prefix + first_alpha.upcase + remainder.downcase
  end

  def to_param
    name.downcase
  end

  def disqualified?
    stats_reliability == 2
  end

  private

  def prepare_name
    return if name.blank?

    normalized_name = self.class.normalize_name(name)
    normalized_name += "#0000" unless normalized_name.match?(TAG_REGEX)

    self.name = normalized_name
  end

  def update_scores
    standing = category_standing || build_category_standing

    standing.normal_score = calculate_normal_score
    standing.survivor_score = calculate_survivor_score
    standing.racing_score = calculate_racing_score
    standing.defilante_score = calculate_defilante_score
  end

  def log_changes
    return if new_record?

    tracked_attributes = ChangeLog.column_names.excluding(%w[id player_id created_at updated_at])
    player_changes = changes.slice(*tracked_attributes)
    category_standing_changes = category_standing&.changes&.slice(*tracked_attributes) || {}
    all_changes = player_changes.merge(category_standing_changes)

    return if all_changes.empty?

    calculated_deltas = all_changes.transform_values { |(old, new)| new - old }
    change_logs.create!(calculated_deltas)
  end
end
