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

      describe 'page parameter' do
        before do
          stub_const('PlayersController::MAX_LEADERBOARD_PAGES', 2)
          stub_const('Pagy::DEFAULT', Pagy::DEFAULT.merge(items: 1))
          get leaderboard_path, params: { page: page }
        end

        context 'when the page parameter is lower than the maximum number of pages' do
          let(:page) { 1 }

          it 'displays the page' do
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(players.first.name)
            expect(response.body).not_to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end

        context 'when the page parameter is equal to the maximum number of pages' do
          let(:page) { 2 }

          it 'displays the last page' do
            expect(response).to have_http_status(:ok)
            expect(response.body).not_to include(players.first.name)
            expect(response.body).to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end

        context 'when the page parameter is higher than the maximum number of pages' do
          let(:page) { 3 }

          it 'displays the second page' do
            expect(response).to have_http_status(:ok)
            expect(response.body).not_to include(players.first.name)
            expect(response.body).to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end

        context 'when the page parameter is not an integer' do
          let(:page) { 'random' }

          it 'displays the first page' do
            expect(response).to have_http_status(:ok)
            expect(response.body).to include(players.first.name)
            expect(response.body).not_to include(players.second.name)
            expect(response.body).not_to include(players.third.name)
          end
        end
      end
    end
  end

  describe '#show' do
    let(:player) { create(:player) }

    context 'when not signed in' do
      before { get player_path(player) }

      it 'redirects to the sign-in page' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when signed in' do
      let(:user) { create(:user) }

      before do
        sign_in(user)
        get player_path(player)
      end

      it 'displays the player name' do
        expect(response).to have_http_status(:ok)
        expect(response.body).to include(player.name)
      end

      context 'when the player does not exist' do
        let(:player) { build_stubbed(:player) }

        it 'renders the not found page' do
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
