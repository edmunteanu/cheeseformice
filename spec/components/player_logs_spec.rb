require "rails_helper"

RSpec.describe PlayerLogs, type: :component do
  let(:component) { described_class.new(logs, type: :normal) }
  let(:logs) { create_list(:change_log, 1) }

  describe "#previous_week_aggregated_log" do
    let(:aggregated_logs) { component.previous_week_aggregated_log }
    let(:logs) do
      [
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 1.day.ago),
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 2.days.ago),
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 3.days.ago),
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 14.days.ago)
      ]
    end

    it "returns the correct aggregated data from the logs of the previous week" do
      expect(aggregated_logs).to match(a_hash_including(firsts: 75, cheese_gathered: 225, rounds_played: 300))
    end
  end

  describe "#previous_month_aggregated_log" do
    let(:aggregated_logs) { component.previous_month_aggregated_log }
    let(:logs) do
      [
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 1.day.ago),
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 2.days.ago),
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 3.days.ago),
        create(:change_log, firsts: 25, cheese_gathered: 75, rounds_played: 100, created_at: 14.days.ago)
      ]
    end

    it "returns the correct aggregated data from all the logs" do
      expect(aggregated_logs).to match(a_hash_including(firsts: 100, cheese_gathered: 300, rounds_played: 400))
    end
  end

  describe "#button_class" do
    context "when the period is previous week" do
      let(:period) { :previous_week }
      let(:button_class) { component.button_class(period) }

      it "returns the correct class" do
        expect(button_class).to eq("accordion-button gap-3")
      end
    end

    context "when the period is previous month" do
      let(:period) { :previous_month }
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
        message = "<span class='text-muted flex-shrink-0 ms-auto'>Score: 0 <i class='bi bi-dash-lg'></i></span>"
        expect(score_change).to eq(message)
      end
    end

    context "when the value is positive" do
      let(:value) { 1 }

      it "returns the correct message" do
        message = "<span class='text-success flex-shrink-0 ms-auto'>Score: 1 <i class='bi bi-chevron-up'></i></span>"
        expect(score_change).to eq(message)
      end
    end

    context "when the value is negative" do
      let(:value) { -1 }

      it "returns the correct message" do
        message = "<span class='text-danger flex-shrink-0 ms-auto'>Score: 1 <i class='bi bi-chevron-down'></i></span>"
        expect(score_change).to eq(message)
      end
    end
  end

  describe "#body_class" do
    context "when the period is previous week" do
      let(:period) { :previous_week }
      let(:body_class) { component.body_class(period) }

      it "returns the correct class" do
        expect(body_class).to eq("accordion-collapse collapse show")
      end
    end

    context "when the period is previous month" do
      let(:period) { :previous_month }
      let(:body_class) { component.body_class(period) }

      it "returns the correct class" do
        expect(body_class).to eq("accordion-collapse collapse")
      end
    end
  end
end
