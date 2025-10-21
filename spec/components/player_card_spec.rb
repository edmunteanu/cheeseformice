require "rails_helper"

RSpec.describe PlayerCard, type: :component do
  let(:component) do
    described_class.new(player: player, category: category, statistic: statistic,
                        player_index: player_index, current_page: current_page)
  end
  let(:player) { create(:player) }
  let(:category) { "normal" }
    let(:statistic) { "normal_score" }
  let(:player_index) { 0 }
  let(:current_page) { 1 }

  describe "#score_statistic?" do
    context "when statistic is a score statistic" do
      it "returns true" do
        expect(component.score_statistic?).to be true
      end
    end

    context "when statistic is not a score statistic" do
      let(:statistic) { "saved_mice" }

      it "returns false" do
        expect(component.score_statistic?).to be false
      end
    end
  end

  describe "#current_rank" do
    context "when statistic is a score statistic" do
      let(:player) { create(:player) }

      before { player.category_standing.update!(normal_rank: 5) }

      it "returns the player's rank with delimiters" do
        expect(component.current_rank).to eq("5")
      end
    end

    context "when statistic is not a score statistic" do
      let(:statistic) { "saved_mice" }
      let(:player_index) { 4 }
      let(:current_page) { 2 }

      before { stub_const("Pagy::DEFAULT", items: 20) }

      it "calculates and returns the rank based on index and page" do
        expect(component.current_rank).to eq("25")
      end
    end
  end
end
