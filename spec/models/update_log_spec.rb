# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UpdateLog' do
  describe '#time_lapsed' do
    let(:update_log) { create(:update_log, created_at: 1.hour.ago, completed_at: Time.current) }

    it 'returns the time lapsed in hours and minutes' do
      expect(update_log.time_lapsed).to eq('1h 0m')
    end

    context 'when the update log is not completed' do
      let(:update_log) { create(:update_log, created_at: 1.hour.ago, completed_at: nil) }

      it 'returns nil' do
        expect(update_log.time_lapsed).to be_nil
      end
    end
  end
end
