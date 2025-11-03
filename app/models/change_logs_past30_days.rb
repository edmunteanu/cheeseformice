class ChangeLogsPast30Days < MaterializedView
  self.table_name = "change_logs_past_30_days"
  self.primary_key = :player_id

  belongs_to :player
end
