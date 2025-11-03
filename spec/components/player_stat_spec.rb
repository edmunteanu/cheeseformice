require "rails_helper"

RSpec.describe PlayerStat, type: :component do
  let(:component) { described_class.new(player, past_day, attribute: :cheese_gathered, style: "") }
  let(:player) { create(:player) }
  let(:past_day) { player.change_logs_past_day }

  describe "#display_change?" do
    let(:display_change) { component.display_change? }

    context "when the player has no previous day change log" do
      it "returns false" do
        expect(display_change).to be(false)
      end
    end

    context "when the player has a previous day change log" do
      before { create(:change_log, player: player, cheese_gathered: cheese_gathered) }

      context "when the cheese gathered change is zero" do
        let(:cheese_gathered) { 0 }

        it "returns false" do
          expect(display_change).to be(false)
        end
      end

      context "when the cheese gathered change is positive" do
        let(:cheese_gathered) { 100 }

        it "returns true" do
          expect(display_change).to be(true)
        end
      end
    end
  end

  describe "#past_day_value" do
    let(:past_day_value) { component.past_day_value }

    context "when the player has no previous day change log" do
      it "returns nil" do
        expect(past_day_value).to be_nil
      end
    end

    context "when the player has a previous day change log" do
      before { create(:change_log, player: player, cheese_gathered: 100) }

      it "returns the correct value" do
        expect(past_day_value).to eq(100)
      end
    end
  end
end
