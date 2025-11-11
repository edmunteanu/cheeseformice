require "rails_helper"

RSpec.describe ScoreHeader, type: :component do
  let(:component) { described_class.new(player, past_day, title: player.name, category: category) }
  let(:player) { create(:player) }
  let(:past_day) { player.change_logs_past_day }
  let(:category) { :normal }

  describe "#score_change" do
    let(:score_change) { component.score_change }

    context "when the player has no previous day change log" do
      it "does not return anything" do
        expect(score_change).to be_nil
      end
    end

    context "when the player has a previous day change log" do
      before { create(:change_log, player: player, normal_score: normal_score) }

      context "when the score change is zero" do
        let(:normal_score) { 0 }

        it "does not return anything" do
          expect(score_change).to be_nil
        end
      end

      context "when the score change is positive" do
        let(:normal_score) { 100 }

        it "returns the correct message" do
          message = "<span class='d-flex align-items-center text-success'>100" \
            "<i class='bi bi-chevron-up icon-sm ms-2'></i></span>"
          expect(score_change).to eq(message)
        end
      end

      context "when the score change is negative" do
        let(:normal_score) { -100 }

        it "returns the correct message" do
          message = "<span class='d-flex align-items-center text-danger'>100" \
            "<i class='bi bi-chevron-down icon-sm ms-2'></i></span>"
          expect(score_change).to eq(message)
        end
      end
    end
  end

  # components/concerns/player_rank_change.rb
  describe "#displayed_rank_change_for" do
    let(:displayed_rank_change) { component.displayed_rank_change_for(player, category) }

    context "when the player has no previous rank" do
      let(:player) { create(:player) }

      before { player.category_standing.update!(normal_rank: 100) }

      it "returns the correct message" do
        message = "<span class='text-success'>#{I18n.t('score_header.new')}</span>"
        expect(displayed_rank_change).to eq(message)
      end
    end

    context "when the rank progression is zero" do
      let(:player) { create(:player) }

      before { player.category_standing.update!(normal_rank: 100, previous_normal_rank: 100) }

      it "returns nothing" do
        expect(displayed_rank_change).to be_nil
      end
    end

    context "when the rank progression is positive" do
      let(:player) { create(:player) }

      before { player.category_standing.update!(normal_rank: 100, previous_normal_rank: 105) }

      it "returns the correct message" do
        message = "<span class='d-flex align-items-center text-success'>" \
          "<i class='bi bi-chevron-up icon-sm me-2'></i>5</span>"
        expect(displayed_rank_change).to eq(message)
      end
    end

    context "when the rank progression is negative" do
      let(:player) { create(:player) }

      before { player.category_standing.update!(normal_rank: 100, previous_normal_rank: 95) }

      it "returns the correct message" do
        message = "<span class='d-flex align-items-center text-danger'>" \
          "<i class='bi bi-chevron-down icon-sm me-2'></i>5</span>"
        expect(displayed_rank_change).to eq(message)
      end
    end
  end
end
