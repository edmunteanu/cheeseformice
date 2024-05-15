# frozen_string_literal: true

module PlayerExtensions
  module NormalScore
    # These weights have been calculated based on the rounded average ratios of the top 50'000 players sorted
    # by firsts descending: 40% / 20% (hard) / 10% (divine) saves ratio, 40% cheese ratio, 10% firsts ratio
    # These ratios represent the baseline for the scoring. This means that the three main score categories
    # (saves, cheese, firsts) will return roughly the same amount of points at baseline ratios, with the saves
    # receiving a slight boost due to the consideration of saves without skills. The bootcamp score is given a
    # weight based on the top bootcamp players' scores to ensure that they are not completely disregarded. The
    # bootcamp ratio is not used in the calculation though, as it is possible to collect bootcamp without
    # collecting rounds.
    SAVED_MICE_WEIGHT = 1
    SAVED_MICE_HARD_WEIGHT = 1.1
    SAVED_MICE_DIVINE_WEIGHT = 1.3
    SAVED_MICE_TOTAL_WEIGHT = 0.9
    SAVED_MICE_WITHOUT_SKILLS_TOTAL_WEIGHT = 1.1
    CHEESE_GATHERED_WEIGHT = 1
    FIRSTS_WEIGHT = 16
    BOOTCAMP_WEIGHT = 2

    # Order matters
    NORMAL_ATTRIBUTES = %i[saved_mice saved_mice_hard saved_mice_divine saved_mice_without_skills
                           saved_mice_hard_without_skills saved_mice_divine_without_skills shaman_cheese
                           firsts cheese_gathered bootcamp rounds_played].freeze

    def calculate_normal_score
      return 0 if rounds_played.zero?

      [
        total_saved_mice_score,
        cheese_gathered * cheese_gathered_ratio * CHEESE_GATHERED_WEIGHT,
        firsts * firsts_ratio * FIRSTS_WEIGHT,
        bootcamp * BOOTCAMP_WEIGHT
      ].sum
    end

    private

    def total_saved_mice_score
      [saved_mice_score, saved_mice_without_skills_score].sum * [saved_mice_ratio, saved_mice_without_skills_ratio].sum
    end

    def saved_mice_score
      [
        chain_subtraction([saved_mice, saved_mice_hard, saved_mice_divine]) * SAVED_MICE_WEIGHT,
        saved_mice_hard * SAVED_MICE_HARD_WEIGHT,
        saved_mice_divine * SAVED_MICE_DIVINE_WEIGHT
      ].sum * SAVED_MICE_TOTAL_WEIGHT
    end

    def chain_subtraction(array)
      array.inject do |acc, val|
        acc - val
      end
    end

    def saved_mice_without_skills_score
      [
        chain_subtraction(
          [saved_mice_without_skills, saved_mice_hard_without_skills, saved_mice_divine_without_skills]
        ) * SAVED_MICE_WEIGHT,
        saved_mice_hard_without_skills * SAVED_MICE_HARD_WEIGHT,
        saved_mice_divine_without_skills * SAVED_MICE_DIVINE_WEIGHT
      ].sum * SAVED_MICE_WITHOUT_SKILLS_TOTAL_WEIGHT
    end
  end
end
