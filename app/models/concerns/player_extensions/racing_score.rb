module PlayerExtensions
  module RacingScore
    # These weights have been calculated based on the rounded average ratios of the top 50'000 players sorted
    # by racing firsts descending: 50% finished maps ratio, 20% firsts ratio, 30% podiums ratio
    # These ratios represent the baseline for the scoring. This means that these three scoring categories
    # will return roughly the same amount of points at baseline ratios.
    RACING_FINISHED_MAPS_WEIGHT = 1
    RACING_FIRSTS_WEIGHT = 6.3
    RACING_PODIUMS_WEIGHT = 2.8

    # Order matters
    RACING_ATTRIBUTES = %i[racing_finished_maps racing_podiums racing_firsts racing_rounds_played].freeze

    def calculate_racing_score
      return 0 if racing_rounds_played.zero?

      [
        racing_finished_maps * racing_finished_maps_ratio * RACING_FINISHED_MAPS_WEIGHT,
        racing_firsts * racing_firsts_ratio * RACING_FIRSTS_WEIGHT,
        racing_podiums * racing_podiums_ratio * RACING_PODIUMS_WEIGHT
      ].sum
    end
  end
end
