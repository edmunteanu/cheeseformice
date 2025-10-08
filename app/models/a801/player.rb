module A801
  class Player < ApplicationRecord
    establish_connection(:a801) unless Rails.env.test?

    self.abstract_class = true if Rails.env.test?
    self.table_name = "player"
  end
end
