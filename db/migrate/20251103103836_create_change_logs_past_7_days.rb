class CreateChangeLogsPast7Days < ActiveRecord::Migration[8.0]
  def change
    create_view :change_logs_past_7_days, materialized: true
    add_index :change_logs_past_7_days, :player_id, unique: true
  end
end
