# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'action_mailer/railtie'
require 'active_job/railtie'
require 'action_cable/engine'
# require "action_mailbox/engine"
require 'action_text/engine'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)

module Cheeseformice
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.time_zone = 'Zurich'
    config.i18n.default_locale = :en
  end
end
