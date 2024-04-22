# frozen_string_literal: true

class ChangePlayerRankAttributes < ActiveRecord::Migration[7.1]
  def change
    add_column :records, :previous_normal_rank, :integer
    add_column :records, :previous_survivor_rank, :integer
    add_column :records, :previous_racing_rank, :integer
    add_column :records, :previous_defilante_rank, :integer
  end
end
