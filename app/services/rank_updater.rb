# frozen_string_literal: true

class RankUpdater
  BATCH_SIZE = 100_000

  class << self
    def call
      %w[normal survivor racing defilante].each do |mode|
        update_rank("#{mode}_score", "#{mode}_rank", "previous_#{mode}_rank")
      end
    end

    private

    def update_rank(score, rank, previous_rank)
      last_id = 0
      max_id = Player.where.not(stats_reliability: 2).maximum(:id) || 0

      while last_id < max_id
        batch_start_id = last_id + 1
        batch_end_id = [last_id + BATCH_SIZE, max_id].min

        ActiveRecord::Base.connection.execute(update_rank_sql(score, rank, previous_rank, batch_start_id, batch_end_id))

        last_id = batch_end_id
      end
    end

    # Order by score DESC first and then by a801_id ASC to ensure that players with the same score still
    # receive a different rank. This means that an older account will be ranked higher. This should not
    # pose a problem, since duplicate scores don't become apparent until around the 200'000th rank.
    def update_rank_sql(score, rank, previous_rank, batch_start_id, batch_end_id)
      <<-SQL.squish
        WITH ranked_players AS (
          SELECT id, #{rank}, RANK() OVER (ORDER BY #{score} DESC, a801_id ASC) AS new_rank
          FROM players
          WHERE stats_reliability != 2
        )
        UPDATE players
        SET #{rank} = ranked_players.new_rank,
            #{previous_rank} = ranked_players.#{rank}
        FROM ranked_players
        WHERE players.id = ranked_players.id
          AND stats_reliability != 2
          AND players.id BETWEEN #{batch_start_id} AND #{batch_end_id};
      SQL
    end
  end
end
