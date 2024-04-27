# frozen_string_literal: true

module Admin
  class BaseController < ApplicationController
    around_action { |_controller, action| I18n.with_locale(:en, &action) }
  end
end
