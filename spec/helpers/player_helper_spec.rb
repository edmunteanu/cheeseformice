require "rails_helper"

RSpec.describe PlayerHelper do
  describe "#name_color" do
    context "when name has the admin tag" do
      it "returns text-admin" do
        expect(helper.name_color("Test#0001")).to eq("text-admin")
      end
    end

    context "when name has the moderator tag" do
      it "returns text-moderator" do
        expect(helper.name_color("Test#0010")).to eq("text-moderator")
      end
    end

    context "when name has the sentinel tag" do
      it "returns text-sentinel" do
        expect(helper.name_color("Test#0015")).to eq("text-sentinel")
      end
    end

    context "when name has the map crew tag" do
      it "returns text-map-crew" do
        expect(helper.name_color("Test#0020")).to eq("text-map-crew")
      end
    end

    context "when name has an unknown tag" do
      it "returns text-primary" do
        expect(helper.name_color("Test#0000")).to eq("text-primary")
      end
    end
  end

  describe "#display_ratio" do
    subject(:displayed_ratio) { helper.display_ratio(decimal) }

    let(:decimal) { 0.1234 }

    it "converts the decimal into a percentage in parentheses" do
      expect(displayed_ratio).to eq("(12.34%)")
    end

    context "when the ratio is zero" do
      let(:decimal) { 0 }

      it "does not display the ratio" do
        expect(displayed_ratio).to be_nil
      end
    end

    context "when the ratio is negative" do
      let(:decimal) { -0.1234 }

      it "does not display the ratio" do
        expect(displayed_ratio).to be_nil
      end
    end

    context "when the ratio is nil" do
      let(:decimal) { nil }

      it "does not display the ratio" do
        expect(displayed_ratio).to be_nil
      end
    end
  end

  describe "#decimal_to_percentage" do
    it "converts a decimal to a percentage with 2 decimal places" do
      expect(helper.decimal_to_percentage(0.1234)).to eq("12.34%")
    end

    it "handles whole numbers correctly" do
      expect(helper.decimal_to_percentage(1)).to eq("100.00%")
    end

    it "handles zero correctly" do
      expect(helper.decimal_to_percentage(0)).to eq("0.00%")
    end
  end

  describe "#humanized_title" do
    context "when title is an admin title" do
      it "wraps the translated title in a span with admin-title class and guillemets" do
        expect(helper.humanized_title("440")).to eq("«<span class='text-admin-title fw-bold'>Fromadmin</span>»")
      end
    end

    context "when title is not an admin title" do
      it "returns the translated title wrapped in guillemets" do
        expect(helper.humanized_title("235")).to eq("«*-*»")
      end
    end

    context "when no translation exists" do
      it "falls back to the original title" do
        expect(helper.humanized_title("999")).to eq("«999»")
      end
    end
  end
end
