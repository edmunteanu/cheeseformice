require "rails_helper"

RSpec.describe ChangeLogsPast7Days do
  describe "#readonly?" do
    it "returns true" do
      expect(described_class.new.readonly?).to be true
    end
  end
end
