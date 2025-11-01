class AddCreatedAtPlayerIdIndexToChangeLogs < ActiveRecord::Migration[8.0]
  def change
    add_index :change_logs, [ :created_at, :player_id ], name: "index_change_logs_on_created_at_and_player_id"
  end
end
