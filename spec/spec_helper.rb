require "simplecov"

SimpleCov.start "rails" do
  add_filter "app/channels/application_cable/channel.rb"
  add_filter "app/channels/application_cable/connection.rb"
  add_filter "app/jobs/application_job.rb"
  add_filter "app/mailers/application_mailer.rb"
  add_filter "app/models/application_record.rb"
  add_filter "app/models/a801" # Exclude a801 models from coverage, since they are only used as a querying interface
  add_filter ".semaphore-cache"
  enable_coverage :branch
  minimum_coverage line: 100, branch: 90
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.disable_monkey_patching!
  config.default_formatter = "doc" if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed

  config.define_derived_metadata do |meta|
    meta[:aggregate_failures] = true
  end
end
