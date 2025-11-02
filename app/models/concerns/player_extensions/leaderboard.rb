module PlayerExtensions
  module Leaderboard
    extend ActiveSupport::Concern

    LEADERBOARD_STATISTICS = {
      normal: %i[normal_score saved_mice saved_mice_hard saved_mice_divine saved_mice_without_skills
                 saved_mice_hard_without_skills saved_mice_divine_without_skills cheese_gathered
                 firsts bootcamp],
      racing: %i[racing_score racing_firsts racing_podiums racing_finished_maps],
      survivor: %i[survivor_score survivor_shaman_rounds survivor_mice_killed survivor_survived_rounds],
      defilante: %i[defilante_score defilante_points defilante_finished_maps]
    }
    LEADERBOARD_DEFAULT = :normal_score.freeze

    # All time ranges (except for "all_time") correspond to ChangeLog scopes.
    TIME_RANGES = %i[all_time past_day past_7_days past_30_days].freeze
    TIME_RANGE_DEFAULT = :all_time.freeze

    class_methods do
      def ranked_by(statistic, time_range)
        if time_range == TIME_RANGE_DEFAULT
          players_by_statistic(statistic)
        else
          players_by_statistic_and_time_range(statistic, time_range)
        end
      end

      private

      def players_by_statistic(statistic)
        rank_suffix = "_rank"
        statistic = statistic.to_s.sub(/_score$/, rank_suffix).to_sym

        # We first eager load the category_standing to avoid N+1 queries.
        # Then we join the category_standings table to access the statistic (and its indexed rank column).
        base_relation = Player.qualified.includes(:category_standing).joins(:category_standing)

        if statistic.ends_with?(rank_suffix)
          # Tie-breaking is already handled when calculating the ranks.
          base_relation.order({ category_standing: { statistic => :asc } })
        else
          # We break ties by ordering players with the same statistic by their a801_id in ascending order.
          base_relation.order({ statistic => :desc, a801_id: :asc })
        end
      end

      # ChangeLogs only exist for qualified players, so we don't need to filter.
      # Inclusion of CategoryStanding is also not required, since we have everything we need in the ChangeLogs.
      def players_by_statistic_and_time_range(statistic, time_range)
        eager_loaded_logs = :"change_logs_#{time_range}"

        grouped_logs = ChangeLog.public_send(time_range)
                                .group(:player_id)
                                .select(:player_id, ChangeLog.arel_table[statistic].sum.as("summed_statistic"))

        Player.select("players.*, grouped_logs.summed_statistic")
              .joins("INNER JOIN (#{grouped_logs.to_sql}) grouped_logs ON grouped_logs.player_id = players.id")
              .includes(eager_loaded_logs)
              .joins(eager_loaded_logs)
              .order("grouped_logs.summed_statistic DESC, players.a801_id")
      end
    end
  end
end
