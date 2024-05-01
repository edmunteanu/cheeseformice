# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayersController do
  describe '#index' do
    context 'when not signed in' do
      before { get leaderboard_path }

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      let(:user) { create(:user) }
      let!(:players) do
        build_list(:player, 3).each_with_index do |player, index|
          player.normal_rank = index + 1
          player.save!
        end
      end

      before do
        sign_in(user)
        get leaderboard_path
      end

      it 'displays the player names' do
        expect(response).to have_http_status(:ok)
        players.each { |player| expect(response.body).to include(player.name) }
      end
    end
  end
end
