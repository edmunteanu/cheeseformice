# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RankUpdateService, type: :service do
  describe '#call' do
    subject(:update_ranks) { described_class.new.call }

    let!(:disqualified_player) { create(:player, stats_reliability: 2) }
    let!(:first_player) { create(:player, stats_reliability: 1, rounds_played: 300, cheese_gathered: 150) }
    let!(:second_player) { create(:player, rounds_played: 200, cheese_gathered: 100) }
    let!(:third_player) { create(:player, a801_id: 100, rounds_played: 100, cheese_gathered: 50) }

    it 'updates the ranks for all players that are eligible for ranking' do
      update_ranks

      expect(first_player.reload.normal_rank).to eq(1)
      expect(second_player.reload.normal_rank).to eq(2)
      expect(third_player.reload.normal_rank).to eq(3)
      expect(disqualified_player.reload.normal_rank).to be_nil
    end

    context 'when multiple players have the same score' do
      let!(:fourth_player) { create(:player, a801_id: 250, rounds_played: 100, cheese_gathered: 50) }

      it 'ranks the players based on their a801_id' do
        update_ranks

        expect(first_player.reload.normal_rank).to eq(1)
        expect(second_player.reload.normal_rank).to eq(2)
        expect(third_player.reload.normal_rank).to eq(3)
        expect(fourth_player.reload.normal_rank).to eq(4)
        expect(disqualified_player.reload.normal_rank).to be_nil
      end
    end

    context 'when the player already had a rank' do
      let!(:fourth_player) { create(:player, rounds_played: 50, cheese_gathered: 25, normal_rank: 1) }

      it 'updates the previous rank and the current rank' do
        update_ranks

        expect(fourth_player.reload.previous_normal_rank).to eq(1)
        expect(fourth_player.normal_rank).to eq(4)
      end
    end
  end
end
