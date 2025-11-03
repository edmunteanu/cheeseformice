require "rails_helper"

RSpec.describe ChangeLogsPast30Days do
  describe "#readonly?" do
    it "returns true" do
      expect(described_class.new.readonly?).to be true
    end
  end
end
