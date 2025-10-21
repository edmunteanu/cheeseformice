require "rails_helper"

RSpec.describe "CategoryStanding" do
  describe "validations" do
    subject { build(:category_standing) }

    it { is_expected.to validate_presence_of(:player_id) }
    it { is_expected.to validate_uniqueness_of(:player_id) }
  end
end
