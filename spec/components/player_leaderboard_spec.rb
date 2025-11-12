require "rails_helper"

RSpec.describe PlayerLeaderboard, type: :component do
  let(:component) do
    described_class.new(players: players, category: category, statistic: statistic,
                        time_range: time_range, current_page: current_page)
  end
  let(:players) { create_list(:player, 3) }
  let(:category) { :normal }
  let(:statistic) { :normal_score }
  let(:time_range) { :all_time }
  let(:current_page) { 1 }

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

  describe "#category_rounds_played_attribute" do
    context "when category is normal" do
      it "returns :rounds_played" do
        expect(component.category_rounds_played_attribute).to eq(:rounds_played)
      end
    end

    context "when category is racing" do
      let(:category) { :racing }

      it "returns :racing_rounds_played" do
        expect(component.category_rounds_played_attribute).to eq(:racing_rounds_played)
      end
    end

    context "when category is survivor" do
      let(:category) { :survivor }

      it "returns :survivor_rounds_played" do
        expect(component.category_rounds_played_attribute).to eq(:survivor_rounds_played)
      end
    end

    context "when category is defilante" do
      let(:category) { :defilante }

      it "returns :defilante_rounds_played" do
        expect(component.category_rounds_played_attribute).to eq(:defilante_rounds_played)
      end
    end
  end

  describe "#current_rank" do
    context "when score statistic and showing player data" do
      before { players.first.category_standing.update!(normal_rank: 5) }

      it "returns the player's current rank with delimiters" do
        expect(component.current_rank(players.first, 0)).to eq("5")
      end
    end

    context "when not score statistic" do
      let(:statistic) { :cheese_gathered }
      let(:current_page) { 2 }

      before { allow(Pagy).to receive(:options).and_return(Pagy::DEFAULT.merge(limit: 20)) }

      it "calculates rank based on index and current page" do
        expect(component.current_rank(players.first, 3)).to eq("24")
      end
    end

    context "when not showing player data" do
      let(:time_range) { :past_7_days }
      let(:current_page) { 4 }

      before { allow(Pagy).to receive(:options).and_return(Pagy::DEFAULT.merge(limit: 20)) }

      it "calculates rank based on index and current page" do
        expect(component.current_rank(players.first, 2)).to eq("63")
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

  describe "#category_score" do
    before do
      create(:change_log, player: players.first, normal_score: 1_000, created_at: Time.current)
      create(:change_log, player: players.first, normal_score: 1_000, created_at: 1.day.ago)
      create(:change_log, player: players.first, normal_score: 1_000, created_at: 2.days.ago)
      create(:change_log, player: players.first, normal_score: 100, created_at: 14.days.ago)
    end

    context "when showing player data" do
      it "returns the player's category score with delimiters" do
        expect(component.category_score(players.first)).to eq("0")
      end
    end

    context "when showing change log data" do
      let(:time_range) { :past_day }

      it "returns the aggregated category score from change logs with delimiters" do
        expect(component.category_score(players.first)).to eq("1,000")
      end
    end
  end

  describe "#category_attribute_value" do
    before do
      create(:change_log, player: players.first, saved_mice: 500, created_at: Time.current)
      create(:change_log, player: players.first, saved_mice: 300, created_at: 1.day.ago)
      create(:change_log, player: players.first, saved_mice: 200, created_at: 2.days.ago)
      create(:change_log, player: players.first, saved_mice: 10, created_at: 14.days.ago)

      ChangeLogsPast7Days.refresh
    end

    context "when showing player data" do
      let(:statistic) { :saved_mice }

      it "returns the player's attribute value with delimiters" do
        expect(component.category_attribute_value(players.first, :saved_mice)).to eq("0")
      end
    end

    context "when showing change log data" do
      let(:statistic) { :saved_mice }
      let(:time_range) { :past_7_days }

      it "returns the aggregated attribute value from change logs with delimiters" do
        expect(component.category_attribute_value(players.first, :saved_mice)).to eq("1,000")
      end
    end
  end

  describe "#statistic_value" do
    before do
      create(:change_log, player: players.first, firsts: 1_500, created_at: Time.current)
      create(:change_log, player: players.first, firsts: 1_000, created_at: 1.day.ago)
      create(:change_log, player: players.first, firsts: 500, created_at: 2.days.ago)
      create(:change_log, player: players.first, firsts: 25, created_at: 14.days.ago)

      ChangeLogsPast30Days.refresh
    end

    context "when showing player data" do
      let(:statistic) { :firsts }

      it "returns the player's statistic value with delimiters" do
        expect(component.statistic_value(players.first)).to eq("0")
      end
    end

    context "when showing change log data" do
      let(:statistic) { :firsts }
      let(:time_range) { :past_30_days }

      it "returns the aggregated statistic value from change logs with delimiters" do
        expect(component.statistic_value(players.first)).to eq("3,025")
      end
    end
  end

  describe "#category_rounds_played_value" do
    before do
      create(:change_log, player: players.first, rounds_played: 1_500, created_at: Time.current)
      create(:change_log, player: players.first, rounds_played: 1_000, created_at: 1.day.ago)
      create(:change_log, player: players.first, rounds_played: 500, created_at: 2.days.ago)
      create(:change_log, player: players.first, rounds_played: 25, created_at: 14.days.ago)

      ChangeLogsPast7Days.refresh
    end

    context "when showing player data" do
      it "returns the player's rounds played value with delimiters" do
        expect(component.category_rounds_played_value(players.first)).to eq("0")
      end
    end

    context "when showing change log data" do
      let(:time_range) { :past_7_days }

      it "returns the aggregated rounds played value from change logs with delimiters" do
        expect(component.category_rounds_played_value(players.first)).to eq("3,000")
      end
    end
  end
end
