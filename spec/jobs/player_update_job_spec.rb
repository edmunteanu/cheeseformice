# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerUpdateJob do
  describe '#perform' do
    context 'when the update is successful' do
      before do
        allow(PlayerUpdater).to receive(:new).and_return(double(call: nil))
        allow(RankUpdater).to receive(:new).and_return(double(call: nil))
      end

      it 'performs the job' do
        assert_performed_jobs 1, only: described_class do
          described_class.perform_later
        end
      end
    end

    context 'when the player updater raises an error' do
      before { allow(PlayerUpdater).to receive(:new).and_raise(StandardError) }

      it 'retries the job' do
        assert_performed_jobs 5, only: described_class do
          expect { described_class.perform_later }.to raise_error(StandardError)
        end
      end
    end

    context 'when the rank updater raises an error' do
      before do
        allow(PlayerUpdater).to receive(:new).and_return(double(call: nil))
        allow(RankUpdater).to receive(:new).and_raise(StandardError)
      end

      it 'retries the job' do
        assert_performed_jobs 5, only: described_class do
          expect { described_class.perform_later }.to raise_error(StandardError)
        end
      end
    end
  end
end
