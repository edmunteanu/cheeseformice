require 'rails_helper'

RSpec.describe ChangeLog do
  describe 'scopes' do
    describe '.previous_month' do
      context 'with no change logs created in the last month' do
        before { create(:change_log, created_at: 31.days.ago) }

        it 'does not return any change logs' do
          expect(described_class.count).to eq(1)
          expect(described_class.previous_month).to be_empty
        end
      end

      context 'with change logs created in the last month but not today (every day)' do
        let!(:change_logs) { Array.new(30) { |index| create(:change_log, created_at: (index + 1).days.ago) } }

        it 'returns all change logs from the last month' do
          expect(described_class.count).to eq(30)
          expect(described_class.previous_month.count).to eq(29)
          expect(described_class.previous_month).to match_array(change_logs.first(29))
          expect(described_class.previous_month.first&.created_at&.to_date).to eq(Date.current - 1.day)
        end
      end

      context 'with change logs created in the last month but not today (every other day)' do
        let!(:change_logs) do
          Array.new(16) { |index| create(:change_log, created_at: ((index * 2) + 1).days.ago) }
        end

        it 'returns all change logs from the last month' do
          expect(described_class.count).to eq(16)
          expect(described_class.previous_month.count).to eq(15)
          expect(described_class.previous_month).to match_array(change_logs.first(15))
          expect(described_class.previous_month.first&.created_at&.to_date).to eq(Date.current - 1.day)
        end
      end

      context 'with change logs created in the last month including today (every day)' do
        let!(:change_logs) { Array.new(31) { |index| create(:change_log, created_at: index.days.ago) } }

        it 'returns all change logs from the last month' do
          expect(described_class.count).to eq(31)
          expect(described_class.previous_month.count).to eq(30)
          expect(described_class.previous_month).to match_array(change_logs.first(30))
          expect(described_class.previous_month.first&.created_at&.to_date).to eq(Date.current)
        end
      end
    end

    describe '.expired' do
      let!(:change_logs) { Array.new(2) { |index| create(:change_log, created_at: (index + 29).days.ago) } }

      it 'returns only the change logs older than 30 days' do
        expect(described_class.count).to eq(2)
        expect(described_class.expired.count).to eq(1)
        expect(described_class.expired).to contain_exactly(change_logs.last)
      end
    end
  end
end
