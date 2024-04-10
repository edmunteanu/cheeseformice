require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Cheeseformice
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    config.time_zone = 'Zurich'
    config.i18n.default_locale = :en
  end
end
