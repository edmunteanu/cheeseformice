require "rails_helper"

RSpec.describe RankUpdateService, type: :service do
  describe "#call" do
    subject(:update_ranks) { described_class.new.call }

    describe "single run" do
      let!(:disqualified_player) { create(:player, stats_reliability: 2) }
      let!(:first_player) do
        create(:player, stats_reliability: 1,
               rounds_played: 300, cheese_gathered: 150,
               racing_rounds_played: 200, racing_finished_maps: 100,
               survivor_rounds_played: 100, survivor_survived_rounds: 50,
               defilante_rounds_played: 300, defilante_finished_maps: 150)
      end
      let!(:second_player) do
        create(:player,
               rounds_played: 200, cheese_gathered: 100,
               racing_rounds_played: 100, racing_finished_maps: 50,
               survivor_rounds_played: 300, survivor_survived_rounds: 150,
               defilante_rounds_played: 200, defilante_finished_maps: 100)
      end
      let!(:third_player) do
        create(:player, a801_id: 100,
               rounds_played: 100, cheese_gathered: 50,
               racing_rounds_played: 300, racing_finished_maps: 150,
               survivor_rounds_played: 200, survivor_survived_rounds: 100,
               defilante_rounds_played: 100, defilante_finished_maps: 50)
      end

      # rubocop:disable RSpec/ExampleLength
      it "updates the ranks for all players that are eligible for ranking" do
        expect { update_ranks }.to change { first_player.reload.normal_rank }.from(nil).to(1)
                                 .and(change(first_player, :racing_rank).from(nil).to(2))
                                 .and(change(first_player, :survivor_rank).from(nil).to(3))
                                 .and(change(first_player, :defilante_rank).from(nil).to(1))
                                 .and(change { second_player.reload.normal_rank }.from(nil).to(2))
                                 .and(change(second_player, :racing_rank).from(nil).to(3))
                                 .and(change(second_player, :survivor_rank).from(nil).to(1))
                                 .and(change(second_player, :defilante_rank).from(nil).to(2))
                                 .and(change { third_player.reload.normal_rank }.from(nil).to(3))
                                 .and(change(third_player, :racing_rank).from(nil).to(1))
                                 .and(change(third_player, :survivor_rank).from(nil).to(2))
                                 .and(change(third_player, :defilante_rank).from(nil).to(3))
                                 .and(not_change(disqualified_player, :normal_rank))
                                 .and(not_change(disqualified_player, :racing_rank))
                                 .and(not_change(disqualified_player, :survivor_rank))
                                 .and(not_change(disqualified_player, :defilante_rank))
      end
      # rubocop:enable RSpec/ExampleLength

      context "when multiple players have the same score" do
        let!(:fourth_player) { create(:player, a801_id: 250, rounds_played: 100, cheese_gathered: 50) }

        it "ranks the players based on their a801_id" do
          expect { update_ranks }.to change { first_player.reload.normal_rank }.from(nil).to(1)
                                   .and(change { second_player.reload.normal_rank }.from(nil).to(2))
                                   .and(change { third_player.reload.normal_rank }.from(nil).to(3))
                                   .and(change { fourth_player.reload.normal_rank }.from(nil).to(4))
                                   .and(not_change(disqualified_player, :normal_rank))
        end
      end

      context "when the player already had a rank" do
        let!(:fourth_player) { create(:player, rounds_played: 50, cheese_gathered: 25, normal_rank: 1) }

        it "updates the previous rank and the current rank" do
          expect { update_ranks }.to change { fourth_player.reload.previous_normal_rank }.from(nil).to(1)
                                   .and(change(fourth_player, :normal_rank).from(1).to(4))
        end
      end

      context "when a player's rank does not change" do
        let!(:fourth_player) do
          create(:player, rounds_played: 50, cheese_gathered: 25, normal_rank: 4, previous_normal_rank: 1)
        end

        it "updates previous rank to the current rank, keeping delta at 0" do
          expect { update_ranks }.to change { fourth_player.reload.previous_normal_rank }.from(1).to(4)
                                   .and(not_change(fourth_player, :normal_rank))
        end
      end
    end

    describe "multiple runs" do
      let!(:first_player) { create(:player, rounds_played: 300, cheese_gathered: 150) }
      let!(:second_player) { create(:player, rounds_played: 200, cheese_gathered: 100) }

      it "correctly snapshots previous rank each day" do
        expect { described_class.new.call }.to change { first_player.reload.normal_rank }.from(nil).to(1)
                                             .and(not_change(first_player, :previous_normal_rank))
                                             .and(change { second_player.reload.normal_rank }.from(nil).to(2))
                                             .and(not_change(second_player, :previous_normal_rank))

        # Simulate score change
        second_player.update!(rounds_played: 300, cheese_gathered: 200)

        expect { described_class.new.call }.to change { first_player.reload.normal_rank }.from(1).to(2)
                                             .and(change { first_player.reload.previous_normal_rank }.from(nil).to(1))
                                             .and(change { second_player.reload.normal_rank }.from(2).to(1))
                                             .and(change { second_player.reload.previous_normal_rank }.from(nil).to(2))
      end
    end
  end
end
