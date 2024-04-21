# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChangeLog do
  describe 'scopes' do
    describe '.expired' do
      let!(:change_logs) { Array.new(31) { |index| create(:change_log, created_at: index.days.ago) } }

      it 'returns only the change logs older than 29 days' do
        expect(described_class.expired.count).to eq(1)
        expect(described_class.expired).to contain_exactly(change_logs.last)
      end
    end
  end
end
