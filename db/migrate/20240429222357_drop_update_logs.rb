class DropUpdateLogs < ActiveRecord::Migration[7.1]
  def up
    drop_table :update_logs
  end

  def down
    create_table :update_logs do |t|
      t.string :status, null: false, default: "started"
      t.text :error_message

      t.timestamps

      t.datetime :completed_at
    end
  end
end
