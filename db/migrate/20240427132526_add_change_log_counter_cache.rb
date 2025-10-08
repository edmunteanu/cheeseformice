class AddChangeLogCounterCache < ActiveRecord::Migration[7.1]
  def up
    add_column :players, :change_logs_count, :integer

    Player.in_batches do |batch|
      batch.each do |player|
        Player.reset_counters(player.id, :change_logs)
      end
    end
  end

  def down
    remove_column :players, :change_logs_count
  end
end
