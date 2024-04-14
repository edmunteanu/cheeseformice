# frozen_string_literal: true

module PlayerCalculators
  module SurvivorScore
    # These weights have been calculated based on the rounded average ratios of the top 50'000 players sorted
    # by shaman rounds descending: 60% mice killed ratio, 10% shaman rounds ratio, 40% survived rounds ratio
    # These ratios represent the baseline for the scoring. This means that these three scoring categories
    # will return roughly the same amount of points at baseline ratios.
    SURVIVOR_MICE_KILLED_WEIGHT = 0.5
    SURVIVOR_SHAMAN_ROUNDS_WEIGHT = 16
    SURVIVOR_SURVIVED_ROUNDS_WEIGHT = 1

    def calculate_survivor_score
      return 0 if survivor_rounds_played.zero?

      [
        survivor_mice_killed * survivor_mice_killed_ratio * SURVIVOR_MICE_KILLED_WEIGHT,
        survivor_shaman_rounds * survivor_shaman_rounds_ratio * SURVIVOR_SHAMAN_ROUNDS_WEIGHT,
        survivor_survived_rounds * survivor_survived_rounds_ratio * SURVIVOR_SURVIVED_ROUNDS_WEIGHT
      ].sum
    end

    def survivor_mice_killed_ratio = survivor_ratio(survivor_mice_killed)
    def survivor_shaman_rounds_ratio = survivor_ratio(survivor_shaman_rounds)
    def survivor_survived_rounds_ratio = survivor_ratio(survivor_survived_rounds)

    private

    def survivor_ratio(stat) = stat.to_f / survivor_rounds_played
  end
end
