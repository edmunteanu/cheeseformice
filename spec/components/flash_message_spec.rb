# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlashMessage, type: :component do
  describe '#alert_style' do
    it 'returns the correct style for alert' do
      expect(described_class.new('alert', '').alert_style)
        .to eq('alert flash-message show alert-warning fade alert-dismissible')
    end

    it 'returns the correct style for notice' do
      expect(described_class.new('notice', '').alert_style)
        .to eq('alert flash-message show alert-success fade alert-dismissible')
    end

    it 'returns the correct style for success' do
      expect(described_class.new('success', '').alert_style)
        .to eq('alert flash-message show alert-success fade alert-dismissible')
    end

    it 'returns the correct style for error' do
      expect(described_class.new('error', '').alert_style)
        .to eq('alert flash-message show alert-danger fade alert-dismissible')
    end

    it 'returns the correct style for random' do
      expect(described_class.new('random', '').alert_style)
        .to eq('alert flash-message show alert-info fade alert-dismissible')
    end

    it 'returns the correct style for non-dismissible alert' do
      expect(described_class.new('alert', '', dismissible: false).alert_style)
        .to eq('alert flash-message show alert-warning')
    end
  end

  describe '#icon_class' do
    it { expect(described_class.new('alert', '').icon_class).to eq('bi-exclamation-circle') }
    it { expect(described_class.new('notice', '').icon_class).to eq('bi-check-circle') }
    it { expect(described_class.new('success', '').icon_class).to eq('bi-check-circle') }
    it { expect(described_class.new('error', '').icon_class).to eq('bi-exclamation-circle') }
    it { expect(described_class.new('whatever', '').icon_class).to eq('bi-info-circle') }
  end

  describe '#dismissible?' do
    it { expect(described_class.new('alert', '').dismissible?).to be(true) }
  end
end
