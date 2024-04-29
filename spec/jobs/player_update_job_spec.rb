# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerUpdateJob do
  describe '#perform' do
    context 'when the update is successful' do
      let(:update_log) { UpdateLog.last }

      before do
        allow(PlayerUpdater).to receive(:new).and_return(double(call: nil))
        allow(RankUpdater).to receive(:new).and_return(double(call: nil))
      end

      it 'creates an update log' do
        assert_performed_jobs 1, only: described_class do
          expect { described_class.perform_later }.to change(UpdateLog, :count).by(1)
        end

        expect(update_log).to be_finished
        expect(update_log.completed_at).to be_present
      end
    end

    context 'when the player updater raises an error' do
      before { allow(PlayerUpdater).to receive(:new).and_raise(StandardError) }

      it 'creates an update log for each retry' do
        assert_performed_jobs 3, only: described_class do
          expect { described_class.perform_later }.to raise_error(StandardError).and(change(UpdateLog, :count).by(3))
        end

        expect(UpdateLog.count).to eq(3)

        UpdateLog.find_each do |update_log|
          expect(update_log).to be_updating_players
          expect(update_log.error_message).to be_present
          expect(update_log.completed_at).not_to be_present
        end
      end
    end

    context 'when the rank updater raises an error' do
      before do
        allow(PlayerUpdater).to receive(:new).and_return(double(call: nil))
        allow(RankUpdater).to receive(:new).and_raise(StandardError)
      end

      it 'creates an update log for each retry' do
        assert_performed_jobs 3, only: described_class do
          expect { described_class.perform_later }.to raise_error(StandardError).and(change(UpdateLog, :count).by(3))
        end

        expect(UpdateLog.count).to eq(3)

        UpdateLog.find_each do |update_log|
          expect(update_log).to be_updating_ranks
          expect(update_log.error_message).to be_present
          expect(update_log.completed_at).not_to be_present
        end
      end
    end
  end
end
