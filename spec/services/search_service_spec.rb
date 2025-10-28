require "rails_helper"

RSpec.describe SearchService, type: :service do
  describe "#perform_search" do
    subject(:results) { described_class.new(search_term).perform_search }

    let!(:alice) { create(:player, name: "Alice#0000") }
    let!(:alicia) { create(:player, name: "Alicia#0000") }
    let!(:bob) { create(:player, name: "Bob#0000") }
    let!(:matthew) { create(:player, name: "Matthew#0000") }

    before { allow(Player).to receive(:find_by_sql).and_call_original }

    describe "result limitation" do
      let(:search_term) { "player" }

      before { (described_class::MAX_RESULTS + 1).times { |i| create(:player, name: "Player#{i}#0000") } }

      it "limits results to MAX_RESULTS" do
        expect(results.count).to be <= SearchService::MAX_RESULTS
      end
    end

    context "when the term is too short" do
      let(:search_term) { "ali" }

      it "uses a prefix search" do
        expect(results.to_sql).to match(/Ali%/)
        expect(results.to_sql).not_to match(/%ali%/)
        expect(results).to include(alice, alicia)
        expect(results).not_to include(bob, matthew)
        expect(Player).not_to have_received(:find_by_sql)
      end
    end

    context "when the term is long enough but has a low entropy" do
      let(:search_term) { "aaaaa" }

      it "uses a prefix search" do
        expect(results.to_sql).to match(/Aaaaa%/)
        expect(results.to_sql).not_to match(/%aaaaa%/)
        expect(results).to be_empty
        expect(Player).not_to have_received(:find_by_sql)
      end
    end

    context "when the term is long enough and has a high entropy" do
      let(:search_term) { "matth" }

      it "uses a substring search" do
        expect(results).to include(matthew)
        expect(results).not_to include(alice, alicia, bob)
        expect(Player).to have_received(:find_by_sql)
      end
    end
  end
end
