# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlayerLogs, type: :component do
  let(:component) { described_class.new(logs) }

  describe '#button_class' do
    let(:logs) { create_list(:change_log, 2) }

    context 'when the log is the first one' do
      let(:log) { logs.first }
      let(:button_class) { component.button_class(log) }

      it 'returns the correct class' do
        expect(button_class).to eq('accordion-button gap-3')
      end
    end

    context 'when the log is not the first one' do
      let(:log) { logs.last }
      let(:button_class) { component.button_class(log) }

      it 'returns the correct class' do
        expect(button_class).to eq('accordion-button gap-3 collapsed')
      end
    end
  end

  describe '#score_change' do
    let(:logs) { create_list(:change_log, 1) }
    let(:score_change) { component.score_change(value) }

    context 'when the value is zero' do
      let(:value) { 0 }

      it 'returns the correct message' do
        message = "<span class='text-muted'>Score: 0 <i class='bi bi-dash-lg'></i></span>"
        expect(score_change).to eq(message)
      end
    end

    context 'when the value is positive' do
      let(:value) { 1 }

      it 'returns the correct message' do
        message = "<span class='text-success'>Score: 1 <i class='bi bi-chevron-up'></i></span>"
        expect(score_change).to eq(message)
      end
    end

    context 'when the value is negative' do
      let(:value) { -1 }

      it 'returns the correct message' do
        message = "<span class='text-danger'>Score: 1 <i class='bi bi-chevron-down'></i></span>"
        expect(score_change).to eq(message)
      end
    end
  end

  describe '#body_class' do
    let(:logs) { create_list(:change_log, 2) }

    context 'when the log is the first one' do
      let(:log) { logs.first }
      let(:body_class) { component.body_class(log) }

      it 'returns the correct class' do
        expect(body_class).to eq('accordion-collapse collapse show')
      end
    end

    context 'when the log is not the first one' do
      let(:log) { logs.last }
      let(:body_class) { component.body_class(log) }

      it 'returns the correct class' do
        expect(body_class).to eq('accordion-collapse collapse')
      end
    end
  end
end
