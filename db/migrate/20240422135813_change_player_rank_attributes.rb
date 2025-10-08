class ChangePlayerRankAttributes < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :previous_normal_rank, :integer
    add_column :players, :previous_survivor_rank, :integer
    add_column :players, :previous_racing_rank, :integer
    add_column :players, :previous_defilante_rank, :integer
  end
end
