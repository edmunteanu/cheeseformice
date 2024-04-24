# frozen_string_literal: true

class AddIndexToStatsReliability < ActiveRecord::Migration[7.1]
  def change
    add_index :players, :stats_reliability
  end
end
