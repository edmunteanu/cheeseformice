# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Player do
  describe 'validations' do
    subject { build(:player) }

    it { is_expected.to validate_presence_of(:a801_id) }
    it { is_expected.to validate_uniqueness_of(:a801_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(Player::MAX_NAME_LENGTH) }

    describe 'name normalization' do
      context 'when the tag is present' do
        let(:player) { create(:player, name: 'Player#1234') }

        it 'does not change the name' do
          expect(player.name).to eq('Player#1234')
        end
      end

      context 'when the tag is missing' do
        let(:player) { create(:player, name: 'Player') }

        it 'appends #0000 to the name' do
          expect(player.name).to eq('Player#0000')
        end
      end
    end
  end

  describe 'scopes' do
    describe '.eligible_for_ranking' do
      let!(:players) do
        [
          create(:player, stats_reliability: 0),
          create(:player, stats_reliability: 1),
          create(:player, stats_reliability: 2)
        ]
      end

      it 'returns only the players with stats_reliability 0 and 1' do
        expect(described_class.eligible_for_ranking).to contain_exactly(players.first, players.second)
      end
    end
  end

  describe 'score and ratio calculations' do
    let(:player) do
      create(:player, rounds_played: 100_000, saved_mice: 100_000, saved_mice_hard: 50_000, saved_mice_divine: 45_000,
                      saved_mice_without_skills: 50_000, saved_mice_hard_without_skills: 30_000,
                      saved_mice_divine_without_skills: 20_000, cheese_gathered: 50_000, firsts: 20_000,
                      bootcamp: 5000, survivor_rounds_played: 10_000, survivor_mice_killed: 25_000,
                      survivor_shaman_rounds: 2_000, survivor_survived_rounds: 3_000, racing_rounds_played: 10_000,
                      racing_finished_maps: 5_000, racing_firsts: 2_000, racing_podiums: 3_000,
                      defilante_rounds_played: 10_000, defilante_finished_maps: 5_000, defilante_points: 10_000)
    end

    it 'calculates the normal score and all the needed ratios correctly' do
      expect(player.saved_mice_ratio).to eq(1.0)
      expect(player.saved_mice_hard_ratio).to eq(0.5)
      expect(player.saved_mice_divine_ratio).to eq(0.45)
      expect(player.saved_mice_without_skills_ratio).to eq(0.5)
      expect(player.saved_mice_hard_without_skills_ratio).to eq(0.3)
      expect(player.saved_mice_divine_without_skills_ratio).to eq(0.2)
      expect(player.cheese_gathered_ratio).to eq(0.5)
      expect(player.firsts_ratio).to eq(0.2)
      expect(player.bootcamp_ratio).to eq(0.05)

      expect(player.normal_score).to eq(346_825.0)
    end

    it 'calculates the survivor score and all the needed ratios correctly' do
      expect(player.survivor_mice_killed_ratio).to eq(2.5)
      expect(player.survivor_shaman_rounds_ratio).to eq(0.2)
      expect(player.survivor_survived_rounds_ratio).to eq(0.3)

      expect(player.survivor_score).to eq(38_550.0)
    end

    it 'calculates the racing score and all the needed ratios correctly' do
      expect(player.racing_finished_maps_ratio).to eq(0.5)
      expect(player.racing_firsts_ratio).to eq(0.2)
      expect(player.racing_podiums_ratio).to eq(0.3)

      expect(player.racing_score).to eq(7_540.0)
    end

    it 'calculates the defilante score and all the needed ratios correctly' do
      expect(player.defilante_finished_maps_ratio).to eq(0.5)
      expect(player.defilante_points_ratio).to eq(1.0)

      expect(player.defilante_score).to eq(2_650.0)
    end

    context 'when the player has no rounds played' do
      let(:player) do
        create(:player, rounds_played: 0, survivor_rounds_played: 0, racing_rounds_played: 0,
                        defilante_rounds_played: 0)
      end

      it 'returns 0 for the scores' do
        expect(player.normal_score).to eq(0)
        expect(player.survivor_score).to eq(0)
        expect(player.racing_score).to eq(0)
        expect(player.defilante_score).to eq(0)
      end
    end
  end

  describe 'level and experience calculations' do
    let(:player) { create(:player, experience: experience) }

    context 'when the experience is 0' do
      let(:experience) { 0 }

      it 'returns current level 1 and current experience 0' do
        expect(player.current_level).to eq(1)
        expect(player.current_experience).to eq(0)
      end
    end

    context 'when the experience is in the range of level 1 to 29' do
      let(:experience) { 1299 } # 1300 needed for level 14

      it 'returns current level 13 and current experience 211' do
        expect(player.current_level).to eq(13)
        expect(player.current_experience).to eq(211)
      end
    end

    context 'when the experience is in the range of level 30 to 59' do
      let(:experience) { 32_659 } # 32660 needed for level 39

      it 'returns current level 38 and current experience 3959' do
        expect(player.current_level).to eq(38)
        expect(player.current_experience).to eq(3_959)
      end
    end

    context 'when the experience is in the range of level 60 and above' do
      let(:experience) { 4_312_634 } # 4312635 needed for level 130

      it 'returns current level 129 and current experience 113474' do
        expect(player.current_level).to eq(129)
        expect(player.current_experience).to eq(113_474)
      end
    end
  end
end
