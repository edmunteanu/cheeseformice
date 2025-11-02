require "rails_helper"

RSpec.describe HomeHelper do
  describe "#difference_to_previous" do
    subject(:difference) { helper.difference_to_previous(value, previous_value) }

    context "when the value is greater than the previous value" do
      let(:value) { 150 }
      let(:previous_value) { 100 }

      it "returns a positive difference with an upward chevron" do
        expect(difference).to include("50")
        expect(difference).to include("bi-chevron-up")
      end
    end

    context "when the value is less than the previous value" do
      let(:value) { 80 }
      let(:previous_value) { 100 }

      it "returns a negative difference with a downward chevron" do
        expect(difference).to include("20")
        expect(difference).to include("bi-chevron-down")
      end
    end

    context "when the value is equal to the previous value" do
      let(:value) { 100 }
      let(:previous_value) { 100 }

      it "returns a zero difference with a dash icon" do
        expect(difference).to include("0")
        expect(difference).to include("bi-dash-lg")
      end
    end
  end
end
