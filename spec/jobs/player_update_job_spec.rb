require 'rails_helper'

RSpec.describe PlayerUpdateJob do
  describe '#perform' do
    context 'when the update is successful' do
      before do
        allow(PlayerUpdateService).to receive(:new).and_return(double(call: nil))
        allow(RankUpdateJob).to receive(:perform_later).and_call_original
      end

      it 'performs the job' do
        assert_performed_jobs 1, only: described_class do
          described_class.perform_later
        end

        expect(PlayerUpdateService).to have_received(:new)
        expect(RankUpdateJob).to have_received(:perform_later)
      end
    end

    context 'when the update raises an error' do
      before { allow(PlayerUpdateService).to receive(:new).and_raise(StandardError) }

      it 'retries the job' do
        assert_performed_jobs 5, only: described_class do
          expect { described_class.perform_later }.to raise_error(StandardError)
        end
      end
    end
  end
end
