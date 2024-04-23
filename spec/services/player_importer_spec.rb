# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerImporter, type: :service do
  describe '#call' do
    subject(:import_players) { described_class.new.call }

    let(:mock_relation) { double(ActiveRecord::Relation) }
    let(:mock_players) do
      Array.new(2) do |index|
        double(A801::Player, id: index, updatedLast7days: 0, registration_date: Time.current,
                             stats_reliability: 0, name: "Double_#{index}", title: '0', unlocked_titles: '',
                             experience: 0, look: '', badges: '', dress_list: '', color1: 'fff', color2: '000',
                             skills: '', round_played: 0, shaman_cheese: 0, saved_mice: 0, saved_mice_hard: 0,
                             saved_mice_divine: 0, saved_mice_ns: 0, saved_mice_hard_ns: 0,
                             saved_mice_divine_ns: 0, cheese_gathered: 0, first: 0, bootcamp: 0,
                             survivor_round_played: 0, survivor_mouse_killed: 0, survivor_shaman_count: 0,
                             survivor_survivor_count: 0, racing_round_played: 0, racing_finished_map: 0,
                             racing_first: 0, racing_podium: 0, defilante_round_played: 0,
                             defilante_finished_map: 0, defilante_points: 0)
      end
    end

    before do
      allow(A801::Player).to receive(:where).and_return(mock_relation)
      allow(mock_relation).to receive(:in_batches).and_yield(mock_players)
      create(:player, a801_id: 0)
    end

    it 'creates new Player records for each A801::Player record that does not exist' do
      expect { import_players }.to change(Player, :count).by(1)
    end
  end
end
