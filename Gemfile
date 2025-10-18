source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.join(__dir__, ".ruby-version")).strip

gem "blazer"
gem "bootsnap", require: false
gem "bootstrap"
gem "dartsass-sprockets"
gem "devise"
gem "devise-i18n"
gem "figaro"
gem "good_job"
gem "importmap-rails"
gem "jbuilder"
gem "kamal"
gem "mysql2"
gem "pagy", "~> 8.6"
gem "pg"
gem "puma"
gem "rails", "~> 8.0"
gem "redis", "~> 5.0"
gem "simple_form"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "view_component", "~> 3.23"

group :test do
  gem "capybara"
  gem "db-query-matchers"
  gem "faker"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "super_diff"
end

group :development, :test do
  gem "brakeman", require: false
  gem "bullet"
  gem "erb_lint", require: false
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "rubocop-rspec", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end
