# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LeaderboardPlayer, type: :component do
  let(:component) { described_class.new(player, 'normal') }

  describe '#displayed_rank_progression' do
    let(:displayed_rank_progression) { component.displayed_rank_progression }

    context 'when the player has no previous rank' do
      let(:player) { create(:player, normal_rank: 100) }

      it 'returns the correct message' do
        message = "<span class='text-success'>#{I18n.t('leaderboard_player.new')}</span>"
        expect(displayed_rank_progression).to eq(message)
      end
    end

    context 'when the rank progression is zero' do
      let(:player) { create(:player, normal_rank: 100, previous_normal_rank: 100) }

      it 'returns nothing' do
        expect(displayed_rank_progression).to be_nil
      end
    end

    context 'when the rank progression is positive' do
      let(:player) { create(:player, normal_rank: 100, previous_normal_rank: 105) }

      it 'returns the correct message' do
        message = "<span class='text-success'><i class='bi bi-chevron-up'></i> 5</span>"
        expect(displayed_rank_progression).to eq(message)
      end
    end

    context 'when the rank progression is negative' do
      let(:player) { create(:player, normal_rank: 100, previous_normal_rank: 95) }

      it 'returns the correct message' do
        message = "<span class='text-danger'><i class='bi bi-chevron-down'></i> 5</span>"
        expect(displayed_rank_progression).to eq(message)
      end
    end
  end
end
