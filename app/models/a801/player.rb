# frozen_string_literal: true

module A801
  class Player < ApplicationRecord
    establish_connection(:a801) unless Rails.env.test?

    self.table_name = 'player'
  end
end
