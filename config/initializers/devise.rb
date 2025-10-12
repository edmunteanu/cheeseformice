Devise.setup do |config|
  config.secret_key = Rails.application.credentials.dig(:devise, :secret_key)

  # ==> ORM configuration
  require "devise/orm/active_record"

  # ==> Configuration for any authentication mechanism
  config.case_insensitive_keys = [ :email ]
  config.strip_whitespace_keys = [ :email ]
  config.paranoid = true
  config.skip_session_storage = [ :http_auth ]

  # ==> Configuration for :database_authenticatable
  config.stretches = Rails.env.test? ? 1 : 10
  config.pepper = Rails.application.credentials.dig(:devise, :pepper)

  # ==> Configuration for :rememberable
  config.expire_all_remember_me_on_sign_out = true

  # ==> Configuration for :validatable
  config.password_length = 12..72
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  # ==> Configuration for :timeoutable
  config.timeout_in = 12.hours

  # ==> Configuration for :lockable
  config.lock_strategy = :failed_attempts
  config.unlock_keys = [ :email ]
  config.unlock_strategy = :none
  config.maximum_attempts = 5

  # ==> Navigation configuration
  config.sign_out_via = :delete

  # ==> Hotwire/Turbo configuration
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other
end
