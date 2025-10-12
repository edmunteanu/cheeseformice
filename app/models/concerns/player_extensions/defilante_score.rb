module PlayerExtensions
  module DefilanteScore
    # These weights have been calculated based on the rounded average ratios of the top 25'000 players sorted
    # by finished maps descending: 60% finished maps ratio, 520% points ratio
    # These ratios represent the baseline for the scoring. This means that these two scoring categories
    # will return roughly the same amount of points at baseline ratios.
    DEFILANTE_FINISHED_MAPS_WEIGHT = 1
    DEFILANTE_POINTS_WEIGHT = 0.015

    # Order matters
    DEFILANTE_ATTRIBUTES = %i[defilante_finished_maps defilante_points defilante_rounds_played].freeze

    def calculate_defilante_score
      return 0 if defilante_rounds_played.zero?

      [
        defilante_finished_maps * defilante_finished_maps_ratio * DEFILANTE_FINISHED_MAPS_WEIGHT,
        defilante_points * defilante_points_ratio * DEFILANTE_POINTS_WEIGHT
      ].sum
    end
  end
end
