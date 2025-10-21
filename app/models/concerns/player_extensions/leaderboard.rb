module PlayerExtensions
  module Leaderboard
    extend ActiveSupport::Concern

    LEADERBOARD_STATISTICS = {
      normal: %w[normal_score saved_mice saved_mice_hard saved_mice_divine saved_mice_without_skills
                 saved_mice_hard_without_skills saved_mice_divine_without_skills cheese_gathered
                 firsts bootcamp],
      racing: %w[racing_score racing_firsts racing_podiums racing_finished_maps],
      survivor: %w[survivor_score survivor_shaman_rounds survivor_mice_killed survivor_survived_rounds],
      defilante: %w[defilante_score defilante_points defilante_finished_maps]
    }

    class_methods do
      def ranked_by(statistic:)
        rank_suffix = "_rank"
        statistic = statistic.sub(/_score$/, rank_suffix)

        if statistic.ends_with?(rank_suffix)
          # We first eager load the category_standing to avoid N+1 queries.
          # Then we join the category_standings table to access the statistic (and its indexed rank column).
          # Tie-breaking is already handled when calculating the ranks.
          includes(:category_standing).qualified
                                      .joins(:category_standing)
                                      .order({ category_standing: { statistic => :asc } })
        else
          # We break ties by ordering players with the same statistic by their a801_id in ascending order.
          qualified.order({ statistic => :desc, a801_id: :asc })
        end
      end
    end
  end
end
