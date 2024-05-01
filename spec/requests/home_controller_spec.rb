# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController do
  describe '#index' do
    before { get root_path }

    it 'is successful' do
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(I18n.t('home.index.description'))
    end
  end
end
