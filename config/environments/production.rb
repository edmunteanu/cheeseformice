# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false

  config.eager_load = true

  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true

  config.assets.compile = false

  config.active_storage.service = :local

  config.force_ssl = true

  config.logger = ActiveSupport::Logger.new($stdout)
                                       .tap  { |logger| logger.formatter = Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }
  config.log_tags = [:request_id]
  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'warn')
  config.lograge.enabled = ENV.fetch('LOGRAGE_ENABLED') == 'true'

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.active_record.dump_schema_after_migration = false

  config.good_job.poll_interval = 5
  config.good_job.shutdown_timeout = 300
  config.good_job.retry_on_unhandled_error = false
  config.good_job.preserve_job_records = true
  config.good_job.enable_cron = true
  config.good_job.cron = YAML.load_file(Rails.root.join('config/cron_jobs.yml')).deep_symbolize_keys
end
