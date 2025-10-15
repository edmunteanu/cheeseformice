class RankUpdateService
  def call
    # Step 1: Precompute all ranks into a single temporary table
    create_tmp_ranking_table

    # Step 2: Apply updates in batches using the precomputed ranks
    apply_batch_updates

    # Step 3: Drop temporary table
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS tmp_player_ranking;")
  end

  private

  # Order by score DESC first and then by a801_id ASC to ensure that players with the same score still
  # receive a different rank. This means that an older account will be ranked higher. This should not
  # pose a problem, since duplicate scores don't become apparent until around the 200'000th rank.
  def create_tmp_ranking_table
    ActiveRecord::Base.connection.execute(create_tmp_ranking_table_sql)
  end

  def create_tmp_ranking_table_sql
    <<~SQL.squish
      CREATE TEMP TABLE tmp_player_ranking AS
      SELECT id,
             normal_rank AS previous_normal_rank,
             survivor_rank AS previous_survivor_rank,
             racing_rank AS previous_racing_rank,
             defilante_rank AS previous_defilante_rank,
             ROW_NUMBER() OVER (ORDER BY normal_score DESC, a801_id ASC) AS new_normal_rank,
             ROW_NUMBER() OVER (ORDER BY survivor_score DESC, a801_id ASC) AS new_survivor_rank,
             ROW_NUMBER() OVER (ORDER BY racing_score DESC, a801_id ASC) AS new_racing_rank,
             ROW_NUMBER() OVER (ORDER BY defilante_score DESC, a801_id ASC) AS new_defilante_rank
      FROM players
      WHERE stats_reliability != 2;
    SQL
  end

  BATCH_SIZE = 50_000
  def apply_batch_updates
    last_id = 0
    max_id = Player.qualified.maximum(:id) || 0

    while last_id < max_id
      batch_start_id = last_id + 1
      batch_end_id = [ last_id + BATCH_SIZE, max_id ].min

      ActiveRecord::Base.connection.execute(apply_batch_updates_sql(batch_start_id, batch_end_id))

      last_id = batch_end_id
    end
  end

  def apply_batch_updates_sql(batch_start_id, batch_end_id)
    <<~SQL.squish
      UPDATE players
      SET normal_rank = tmp.new_normal_rank,
          previous_normal_rank = tmp.previous_normal_rank,
          survivor_rank = tmp.new_survivor_rank,
          previous_survivor_rank = tmp.previous_survivor_rank,
          racing_rank = tmp.new_racing_rank,
          previous_racing_rank = tmp.previous_racing_rank,
          defilante_rank = tmp.new_defilante_rank,
          previous_defilante_rank = tmp.previous_defilante_rank
      FROM tmp_player_ranking tmp
      WHERE players.id = tmp.id
        AND stats_reliability != 2
        AND players.id BETWEEN #{batch_start_id} AND #{batch_end_id};
    SQL
  end
end
