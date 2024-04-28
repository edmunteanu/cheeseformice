# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(File.join(__dir__, '.ruby-version')).strip

gem 'bootsnap', require: false
gem 'cssbundling-rails'
gem 'dartsass-sprockets'
gem 'devise'
gem 'devise-i18n'
gem 'figaro'
gem 'good_job'
gem 'jbuilder'
gem 'jsbundling-rails'
gem 'mysql2'
gem 'pagy', '~> 8.2'
gem 'pg', '~> 1.1'
gem 'puma', '>= 5.0'
gem 'rails', '~> 7.1.3', '>= 7.1.3.2'
# TODO: Point to rubygems once support for turbo-rails 2.0 is officially released
gem 'rails_admin', github: 'railsadminteam/rails_admin', branch: 'master'
gem 'redis', '>= 4.0.1'
gem 'simple_form'
gem 'sprockets-rails'
gem 'stimulus-rails'
gem 'turbo-rails'
gem 'tzinfo-data', platforms: %i[windows jruby]
gem 'view_component'

group :test do
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'super_diff'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'bullet'
  gem 'erb_lint', require: false
  gem 'factory_bot_rails'
  gem 'rspec-rails'
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false
  gem 'standard'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :production do
  gem 'lograge'
end
