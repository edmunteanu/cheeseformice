class AddTrgmIndexToPlayersName < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      CREATE INDEX index_players_on_name_trgm
        ON players USING gin (name gin_trgm_ops);
    SQL
  end

  def down
    execute <<~SQL
      DROP INDEX IF EXISTS index_players_on_name_trgm;
    SQL
  end
end
