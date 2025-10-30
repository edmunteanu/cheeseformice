class SetPlayersNameCollation < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      ALTER TABLE players
      ALTER COLUMN name TYPE varchar
      COLLATE "C";
    SQL

    # Rebuild the unique index so it uses the new collation
    remove_index :players, name: "index_players_on_name"
    add_index :players, :name, unique: true, name: "index_players_on_name"
  end

  def down
    # Rollback to default collation
    execute <<~SQL
      ALTER TABLE players
      ALTER COLUMN name TYPE varchar;
    SQL

    remove_index :players, name: "index_players_on_name"
    add_index :players, :name, unique: true, name: "index_players_on_name"
  end
end
