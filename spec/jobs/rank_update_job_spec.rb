require 'rails_helper'

RSpec.describe RankUpdateJob do
  describe '#perform' do
    context 'when the update is successful' do
      before do
        allow(RankUpdateService).to receive(:new).and_return(double(call: nil))
        allow(LogDeletionJob).to receive(:perform_later).and_call_original
      end

      it 'performs the job' do
        assert_performed_jobs 1, only: described_class do
          described_class.perform_later
        end

        expect(RankUpdateService).to have_received(:new)
        expect(LogDeletionJob).to have_received(:perform_later)
      end
    end

    context 'when the updater update raises an error' do
      before { allow(RankUpdateService).to receive(:new).and_raise(StandardError) }

      it 'retries the job' do
        assert_performed_jobs 5, only: described_class do
          expect { described_class.perform_later }.to raise_error(StandardError)
        end
      end
    end
  end
end
