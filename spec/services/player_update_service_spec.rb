# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerUpdateService, type: :service do
  describe '#call' do
    subject(:update_players) { described_class.new.call }

    let!(:existing_player) { create(:player, a801_id: 0, name: 'Double_0') }
    let(:mock_relation) { double(ActiveRecord::Relation) }

    let(:mock_players) do
      Array.new(2) do |index|
        double(A801::Player, id: index, updatedLast7days: 0, registration_date: Time.current,
                             stats_reliability: 0, name: "Double_#{index}#0000", title: title,
                             unlocked_titles: existing_player.unlocked_titles,
                             experience: 0, look: existing_player.look, badges: '', dress_list: '',
                             color1: existing_player.mouse_color, color2: existing_player.shaman_color, skills: '',
                             round_played: rounds_played, shaman_cheese: shaman_cheese, saved_mice: saved_mice,
                             saved_mice_hard: 0, saved_mice_divine: saved_mice_divine, saved_mice_ns: 0,
                             saved_mice_hard_ns: 0, saved_mice_divine_ns: 0, cheese_gathered: cheese_gathered,
                             first: firsts, bootcamp: 0, survivor_round_played: 0, survivor_mouse_killed: 0,
                             survivor_shaman_count: 0, survivor_survivor_count: 0, racing_round_played: 0,
                             racing_finished_map: 0, racing_first: 0, racing_podium: 0, defilante_round_played: 0,
                             defilante_finished_map: 0, defilante_points: 0)
      end
    end

    let(:title) { '0' }
    let(:rounds_played) { 353 }
    let(:shaman_cheese) { 38 }
    let(:saved_mice) { 674 }
    let(:saved_mice_divine) { 674 }
    let(:cheese_gathered) { 248 }
    let(:firsts) { 139 }

    before do
      allow(A801::Player).to receive(:where).and_return(mock_relation)
      allow(mock_relation).to receive(:in_batches).and_yield(mock_players)
    end

    it 'creates new Player records, updates the existing player and creates an associated ChangeLog' do
      expect { update_players }.to change(Player, :count).by(1).and(change(ChangeLog, :count).by(1))

      expect(existing_player.reload.change_logs.count).to eq(1)
      change_log = existing_player.change_logs.last

      expect(existing_player.rounds_played).to eq(rounds_played).and(eq(change_log.rounds_played))
      expect(existing_player.shaman_cheese).to eq(shaman_cheese).and(eq(change_log.shaman_cheese))
      expect(existing_player.saved_mice).to eq(saved_mice).and(eq(change_log.saved_mice))
      expect(existing_player.saved_mice_divine).to eq(saved_mice_divine).and(eq(change_log.saved_mice_divine))
      expect(existing_player.cheese_gathered).to eq(cheese_gathered).and(eq(change_log.cheese_gathered))
      expect(existing_player.firsts).to eq(firsts).and(eq(change_log.firsts))

      expect(existing_player.normal_score).to eq(2_555).and(eq(change_log.normal_score))
    end

    context 'when the existing player was not changed' do
      let(:rounds_played) { 0 }
      let(:shaman_cheese) { 0 }
      let(:saved_mice) { 0 }
      let(:saved_mice_divine) { 0 }
      let(:cheese_gathered) { 0 }
      let(:firsts) { 0 }

      it 'does not update the existing player and does not create a ChangeLog' do
        expect { update_players }.to change(Player, :count).by(1)
                                                           .and(not_change(ChangeLog, :count))
                                                           .and(not_change { existing_player.reload })
      end
    end

    context 'when the existing player was changed but no ChangeLog relevant attributes were updated' do
      let(:title) { '226' }
      let(:rounds_played) { 0 }
      let(:shaman_cheese) { 0 }
      let(:saved_mice) { 0 }
      let(:saved_mice_divine) { 0 }
      let(:cheese_gathered) { 0 }
      let(:firsts) { 0 }

      it 'updates the existing player but does not create a ChangeLog' do
        expect { update_players }.to change(Player, :count).by(1).and(not_change(ChangeLog, :count))

        expect(existing_player.reload.change_logs.count).to eq(0)
        expect(existing_player.title).to eq(title)
      end
    end

    context 'when the A801 player has null values for stat attributes' do
      let(:rounds_played) { nil }
      let(:shaman_cheese) { nil }
      let(:saved_mice) { nil }
      let(:saved_mice_divine) { nil }
      let(:cheese_gathered) { nil }
      let(:firsts) { nil }

      it 'creates the player nonetheless and sets the value to 0' do
        expect { update_players }.to change(Player, :count).by(1)
                                                           .and(not_change(ChangeLog, :count))
                                                           .and(not_change { existing_player.reload })

        created_player = Player.last
        expect(created_player.rounds_played).to eq(0)
        expect(created_player.shaman_cheese).to eq(0)
        expect(created_player.saved_mice).to eq(0)
        expect(created_player.saved_mice_divine).to eq(0)
        expect(created_player.cheese_gathered).to eq(0)
        expect(created_player.firsts).to eq(0)
      end
    end
  end
end
