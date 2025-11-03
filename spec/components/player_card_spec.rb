require "rails_helper"

RSpec.describe PlayerCard, type: :component do
  let(:component) do
    described_class.new(player: player, category: category, statistic: statistic, time_range: time_range,
                        player_index: player_index, current_page: current_page)
  end
  let(:player) { create(:player) }
  let(:category) { :normal }
  let(:statistic) { :normal_score }
  let(:time_range) { :all_time }
  let(:player_index) { 0 }
  let(:current_page) { 1 }

  describe "#category_score" do
    before do
      create(:change_log, player: player, normal_score: 100, created_at: 1.day.ago)
      create(:change_log, player: player, normal_score: 100, created_at: 2.days.ago)
      create(:change_log, player: player, normal_score: 100, created_at: 3.days.ago)
      create(:change_log, player: player, normal_score: 100, created_at: 14.days.ago)

      ChangeLogsPast7Days.refresh
    end

    context "when showing player data" do
      it "returns the player's category score with delimiters" do
        expect(component.category_score).to eq(I18n.t("players.index.scores.normal", score: 0))
      end
    end

    context "when showing change log data" do
      let(:time_range) { :past_7_days }

      it "returns the aggregated category score from change logs with delimiters" do
        expect(component.category_score).to eq(I18n.t("players.index.scores.normal", score: 300))
      end
    end
  end

  describe "#show_player_data?" do
    context "when time range is all_time" do
      it "returns true" do
        expect(component.show_player_data?).to be true
      end
    end

    context "when time range is past_day" do
      let(:time_range) { :past_day }

      it "returns false" do
        expect(component.show_player_data?).to be false
      end
    end

    context "when time range is past_7_days" do
      let(:time_range) { :past_7_days }

      it "returns false" do
        expect(component.show_player_data?).to be false
      end
    end

    context "when time range is past_30_days" do
      let(:time_range) { :past_30_days }

      it "returns false" do
        expect(component.show_player_data?).to be false
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
      let(:statistic) { :saved_mice }
      let(:player_index) { 4 }
      let(:current_page) { 2 }

      before { stub_const("Pagy::DEFAULT", limit: 20) }

      it "calculates and returns the rank based on index and page" do
        expect(component.current_rank).to eq("25")
      end
    end
  end

  describe "#score_statistic?" do
    context "when statistic is a score statistic" do
      it "returns true" do
        expect(component.score_statistic?).to be true
      end
    end

    context "when statistic is not a score statistic" do
      let(:statistic) { :saved_mice }

      it "returns false" do
        expect(component.score_statistic?).to be false
      end
    end
  end

  describe "#column_classes" do
    context "when category is normal" do
      let(:category) { :normal }

      it "returns correct column classes" do
        expect(component.column_classes).to eq("col-6 col-md-3")
      end
    end

    context "when category is racing" do
      let(:category) { :racing }

      it "returns correct column classes" do
        expect(component.column_classes).to eq("col-6 col-md-3")
      end
    end

    context "when category is survivor" do
      let(:category) { :survivor }

      it "returns correct column classes" do
        expect(component.column_classes).to eq("col-6 col-md-3")
      end
    end

    context "when category is defilante" do
      let(:category) { :defilante }

      it "returns correct column classes" do
        expect(component.column_classes).to eq("col-6 col-md-4")
      end
    end
  end

  describe "#category_attribute_value" do
    before do
      create(:change_log, player: player, saved_mice: 50, created_at: 1.day.ago)
      create(:change_log, player: player, saved_mice: 30, created_at: 2.days.ago)
      create(:change_log, player: player, saved_mice: 20, created_at: 3.days.ago)
      create(:change_log, player: player, saved_mice: 10, created_at: 14.days.ago)

      ChangeLogsPast7Days.refresh
    end

    context "when showing player data" do
      let(:statistic) { :saved_mice }

      it "returns the player's attribute value with delimiters" do
        expect(component.category_attribute_value(:saved_mice)).to eq("0")
      end
    end

    context "when showing change log data" do
      let(:statistic) { :saved_mice }
      let(:time_range) { :past_7_days }

      it "returns the aggregated attribute value from change logs with delimiters" do
        expect(component.category_attribute_value(:saved_mice)).to eq("100")
      end
    end
  end

  describe "#statistic_value" do
    before do
      create(:change_log, player: player, firsts: 150, created_at: 1.day.ago)
      create(:change_log, player: player, firsts: 100, created_at: 2.days.ago)
      create(:change_log, player: player, firsts: 50, created_at: 3.days.ago)
      create(:change_log, player: player, firsts: 25, created_at: 14.days.ago)

      ChangeLogsPast7Days.refresh
    end

    context "when showing player data" do
      let(:statistic) { :firsts }

      it "returns the player's statistic value with delimiters" do
        expect(component.statistic_value).to eq("0")
      end
    end

    context "when showing change log data" do
      let(:statistic) { :firsts }
      let(:time_range) { :past_7_days }

      it "returns the aggregated statistic value from change logs with delimiters" do
        expect(component.statistic_value).to eq("300")
      end
    end
  end

  describe "#category_rounds_played_attribute" do
    context "when category is normal" do
      let(:category) { :normal }

      it "returns 'rounds_played'" do
        expect(component.category_rounds_played_attribute).to eq(:rounds_played)
      end
    end

    context "when category is racing" do
      let(:category) { :racing }

      it "returns 'racing_rounds_played'" do
        expect(component.category_rounds_played_attribute).to eq(:racing_rounds_played)
      end
    end

    context "when category is survivor" do
      let(:category) { :survivor }

      it "returns 'survivor_rounds_played'" do
        expect(component.category_rounds_played_attribute).to eq(:survivor_rounds_played)
      end
    end

    context "when category is defilante" do
      let(:category) { :defilante }

      it "returns 'defilante_rounds_played'" do
        expect(component.category_rounds_played_attribute).to eq(:defilante_rounds_played)
      end
    end
  end

  describe "#category_rounds_played_value" do
    before do
      create(:change_log, player: player, rounds_played: 40, created_at: 1.day.ago)
      create(:change_log, player: player, rounds_played: 30, created_at: 2.days.ago)
      create(:change_log, player: player, rounds_played: 20, created_at: 3.days.ago)
      create(:change_log, player: player, rounds_played: 10, created_at: 14.days.ago)

      ChangeLogsPast7Days.refresh
    end

    context "when showing player data" do
      it "returns the player's rounds played value with delimiters" do
        expect(component.category_rounds_played_value).to eq("0")
      end
    end

    context "when showing change log data" do
      let(:time_range) { :past_7_days }

      it "returns the aggregated rounds played value from change logs with delimiters" do
        expect(component.category_rounds_played_value).to eq("90")
      end
    end
  end
end
