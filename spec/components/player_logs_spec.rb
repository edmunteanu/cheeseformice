require "rails_helper"

RSpec.describe PlayerLogs, type: :component do
  let(:component) { described_class.new(past_7_days, past_30_days, category: :normal) }
  let(:past_7_days) { player.change_logs.past_7_days.to_a }
  let(:past_30_days) { player.change_logs.past_30_days.to_a }
  let(:player) { create(:player) }

  before do
    create(:change_log, player: player, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 1.day.ago)
    create(:change_log, player: player, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 2.days.ago)
    create(:change_log, player: player, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 3.days.ago)
    create(:change_log, player: player, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 14.days.ago)
  end

  describe "#past_7_days_aggregated" do
    subject(:aggregated_logs) { component.past_7_days_aggregated }

    it "returns the correct aggregated data from the logs of the previous week" do
      expect(aggregated_logs).to match(a_hash_including(firsts: 75, cheese_gathered: 225, rounds_played: 300))
    end
  end

  describe "#past_30_days_aggregated" do
    subject(:aggregated_logs) { component.past_30_days_aggregated }

    it "returns the correct aggregated data from all the logs" do
      expect(aggregated_logs).to match(a_hash_including(firsts: 100, cheese_gathered: 300, rounds_played: 400))
    end
  end

  describe "#button_class" do
    context "when the period is past 7 days" do
      let(:period) { :past_7_days }
      let(:button_class) { component.button_class(period) }

      it "returns the correct class" do
        expect(button_class).to eq("accordion-button gap-3")
      end
    end

    context "when the period is past 30 days" do
      let(:period) { :past_30_days }
      let(:button_class) { component.button_class(period) }

      it "returns the correct class" do
        expect(button_class).to eq("accordion-button gap-3 collapsed")
      end
    end
  end

  describe "#score_change" do
    let(:score_change) { component.score_change(value) }

    context "when the value is zero" do
      let(:value) { 0 }

      it "returns the correct message" do
        message = "<span class='d-flex align-items-center flex-shrink-0 ms-auto text-muted'>Score: 0" \
          "<i class='bi bi-dash-lg icon-sm ms-2'></i></span>"
        expect(score_change).to eq(message)
      end
    end

    context "when the value is positive" do
      let(:value) { 1 }

      it "returns the correct message" do
        message = "<span class='d-flex align-items-center flex-shrink-0 ms-auto text-success'>Score: 1" \
          "<i class='bi bi-chevron-up icon-sm ms-2'></i></span>"
        expect(score_change).to eq(message)
      end
    end

    context "when the value is negative" do
      let(:value) { -1 }

      it "returns the correct message" do
        message = "<span class='d-flex align-items-center flex-shrink-0 ms-auto text-danger'>Score: 1" \
          "<i class='bi bi-chevron-down icon-sm ms-2'></i></span>"
        expect(score_change).to eq(message)
      end
    end
  end

  describe "#body_class" do
    context "when the period is previous week" do
      let(:period) { :past_7_days }
      let(:body_class) { component.body_class(period) }

      it "returns the correct class" do
        expect(body_class).to eq("accordion-collapse collapse show")
      end
    end

    context "when the period is previous month" do
      let(:period) { :past_30_days }
      let(:body_class) { component.body_class(period) }

      it "returns the correct class" do
        expect(body_class).to eq("accordion-collapse collapse")
      end
    end
  end
end
