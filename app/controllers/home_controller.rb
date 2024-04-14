# frozen_string_literal: true

class HomeController < ApplicationController
  def check
    val = ActiveRecord::Base.connection.execute('select 1+2 as val').first['val']
    render plain: "1+2=#{val}"
  end

  # :nocov:
  def tunnel_test
    player = A801::Player.find_by(name: 'Tigrounette#0001')
    render plain: player.inspect
  end
  # :nocov
end
