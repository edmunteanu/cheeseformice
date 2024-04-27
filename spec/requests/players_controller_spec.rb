# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController do
  describe '#index' do
    let!(:players) do
      build_list(:player, 3).each_with_index do |player, index|
        player.normal_rank = index + 1
        player.save!
      end
    end

    before { get root_path }

    it 'displays the player names' do
      expect(response).to have_http_status(:ok)
      players.each { |player| expect(response.body).to include(player.name) }
    end
  end
end
