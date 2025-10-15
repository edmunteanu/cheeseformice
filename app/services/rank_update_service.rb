class RankUpdateService
  def initialize(batch_size: 50_000)
    @batch_size = batch_size
  end

  def call
    %w[normal survivor racing defilante].each do |mode|
      update_rank("#{mode}_score", "#{mode}_rank", "previous_#{mode}_rank")
    end
  end

  private

  def update_rank(score, rank, previous_rank)
    # Step 1: Precompute ranks into a temporary table
    create_temp_rank_table(score, rank)

    # Step 2: Apply updates in batches using the precomputed ranks
    apply_batch_updates(rank, previous_rank)

    # Step 3: Drop temporary table ahead of the next iteration
    ActiveRecord::Base.connection.execute("DROP TABLE tmp_ranked_players;")
  end

  # Order by score DESC first and then by a801_id ASC to ensure that players with the same score still
  # receive a different rank. This means that an older account will be ranked higher. This should not
  # pose a problem, since duplicate scores don't become apparent until around the 200'000th rank.
  def create_temp_rank_table(score, rank)
    ActiveRecord::Base.connection.execute(<<~SQL.squish)
      CREATE TEMP TABLE tmp_ranked_players AS
      SELECT id,
             #{rank} AS old_rank,
             ROW_NUMBER() OVER (ORDER BY #{score} DESC, a801_id ASC) AS new_rank
      FROM players
      WHERE stats_reliability != 2;
    SQL
  end

  def apply_batch_updates(rank, previous_rank)
    last_id = 0
    max_id = Player.qualified.maximum(:id) || 0

    while last_id < max_id
      batch_start_id = last_id + 1
      batch_end_id = [ last_id + @batch_size, max_id ].min

      ActiveRecord::Base.connection.execute(<<~SQL.squish)
        UPDATE players
        SET #{rank} = tmp.new_rank,
            #{previous_rank} = tmp.old_rank
        FROM tmp_ranked_players tmp
        WHERE players.id = tmp.id
          AND stats_reliability != 2
          AND players.id BETWEEN #{batch_start_id} AND #{batch_end_id};
      SQL

      last_id = batch_end_id
    end
  end
end
