# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FlashMessage, type: :component do
  let(:component) { described_class.new(type, message) }

  describe '#alert_class' do
    it { expect(described_class.new('alert', '').alert_class).to eq('warning') }
    it { expect(described_class.new('notice', '').alert_class).to eq('success') }
    it { expect(described_class.new('success', '').alert_class).to eq('success') }
    it { expect(described_class.new('error', '').alert_class).to eq('danger') }
    it { expect(described_class.new('whatever', '').alert_class).to eq('info') }
  end

  describe '#icon_class' do
    it { expect(described_class.new('alert', '').icon_class).to eq('bi-exclamation-circle') }
    it { expect(described_class.new('notice', '').icon_class).to eq('bi-check-circle') }
    it { expect(described_class.new('success', '').icon_class).to eq('bi-check-circle') }
    it { expect(described_class.new('error', '').icon_class).to eq('bi-exclamation-circle') }
    it { expect(described_class.new('whatever', '').icon_class).to eq('bi-info-circle') }
  end

  describe '#dismissable?' do
    it { expect(described_class.new('alert', '').dismissable?).to be(true) }
  end
end
