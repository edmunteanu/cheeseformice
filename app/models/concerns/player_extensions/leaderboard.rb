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
        statistic = statistic.sub(/_score$/, "_rank")

        # We break ties by ordering players with the same statistic by their a801_id in ascending order.
        qualified.order(statistic => statistic.ends_with?("_rank") ? :asc : :desc, "a801_id" => :asc)
      end
    end
  end
end
