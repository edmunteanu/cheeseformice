class RankUpdateService
  RANK_COLUMNS = {
    normal: {
      score: "normal_score",
      rank: "normal_rank",
      previous_rank: "previous_normal_rank"
    },
    survivor: {
      score: "survivor_score",
      rank: "survivor_rank",
      previous_rank: "previous_survivor_rank"
    },
    racing: {
      score: "racing_score",
      rank: "racing_rank",
      previous_rank: "previous_racing_rank"
    },
    defilante: {
      score: "defilante_score",
      rank: "defilante_rank",
      previous_rank: "previous_defilante_rank"
    }
  }.freeze

  def initialize(batch_size: 200_000)
    @batch_size = batch_size
    @max_id = Player.where.not(stats_reliability: 2).maximum(:id) || 0
  end

  def call
    RANK_COLUMNS.each_key { |mode| update_mode_ranks(mode) }
  end

  private

  def update_mode_ranks(mode)
    cols = RANK_COLUMNS.fetch(mode)
    score_col = cols[:score]
    rank_col = cols[:rank]
    prev_col = cols[:previous_rank]
    temp_table = "ranked_#{mode}_tmp"

    # Phase 1: Copy current rank into previous rank
    snapshot_previous_ranks(prev_col, rank_col)

    # Phase 2: Compute new ranks once into a temp table
    create_rank_temp_table(temp_table, score_col)

    # Phase 3: Update only rows whose ranks changed
    update_changed_ranks(temp_table, rank_col)

    # Phase 4: Ensure temp table is dropped
    ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS #{temp_table}")
  end

  def snapshot_previous_ranks(previous_rank, rank)
    last_id = 0

    while last_id < @max_id
      batch_start_id = last_id + 1
      batch_end_id = [ last_id + @batch_size, @max_id ].min

      sql = <<-SQL.squish
        UPDATE players
        SET #{previous_rank} = #{rank}
        WHERE stats_reliability != 2
          AND id BETWEEN #{batch_start_id} AND #{batch_end_id}
      SQL
      ActiveRecord::Base.connection.execute(sql)

      last_id = batch_end_id
    end
  end

  def create_rank_temp_table(temp_table, score)
    sql = <<-SQL.squish
      CREATE TEMP TABLE #{temp_table} AS
      SELECT id,
             ROW_NUMBER() OVER (ORDER BY #{score} DESC, a801_id ASC) AS new_rank
      FROM players
      WHERE stats_reliability != 2
    SQL
    ActiveRecord::Base.connection.execute(sql)
  end

  def update_changed_ranks(temp_table, rank)
    last_id = 0

    while last_id < @max_id
      batch_start_id = last_id + 1
      batch_end_id = [ last_id + @batch_size, @max_id ].min

      sql = <<-SQL.squish
        UPDATE players p
        SET #{rank} = r.new_rank
        FROM #{temp_table} r
        WHERE p.id = r.id
          AND p.stats_reliability != 2
          AND p.id BETWEEN #{batch_start_id} AND #{batch_end_id}
          AND (p.#{rank} IS DISTINCT FROM r.new_rank)
      SQL
      ActiveRecord::Base.connection.execute(sql)

      last_id = batch_end_id
    end
  end
end
