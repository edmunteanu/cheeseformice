# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LogDeletionJob do
  describe '#perform' do
    let!(:change_log) { create(:change_log) }
    let!(:expired_change_log) { create(:change_log, created_at: ChangeLog::EXPIRED_AFTER.days.ago.to_date) }

    context 'when the deletion is successful' do
      it 'performs the job' do
        assert_performed_jobs 1, only: described_class do
          described_class.perform_later
        end

        expect(ChangeLog.find_by(id: change_log.id)).to be_present
        expect(ChangeLog.find_by(id: expired_change_log.id)).to be_nil
      end
    end

    context 'when the deletion raises an error' do
      before { allow(ChangeLog).to receive(:expired).and_raise(StandardError) }

      it 'retries the job' do
        assert_performed_jobs 5, only: described_class do
          expect { described_class.perform_later }.to raise_error(StandardError)
        end
      end
    end
  end
end
