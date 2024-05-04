# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerHelper do
  describe '#display_ratio' do
    subject(:displayed_ratio) { helper.display_ratio(decimal) }

    let(:decimal) { 0.1234 }

    it 'converts the decimal into a percentage in parentheses' do
      expect(displayed_ratio).to eq('(12.34%)')
    end

    context 'when the ratio is zero' do
      let(:decimal) { 0 }

      it 'does not display the ratio' do
        expect(displayed_ratio).to be_nil
      end
    end

    context 'when the ratio is negative' do
      let(:decimal) { -0.1234 }

      it 'does not display the ratio' do
        expect(displayed_ratio).to be_nil
      end
    end

    context 'when the ratio is nil' do
      let(:decimal) { nil }

      it 'does not display the ratio' do
        expect(displayed_ratio).to be_nil
      end
    end
  end
end
