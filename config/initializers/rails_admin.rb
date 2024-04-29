# frozen_string_literal: true

RailsAdmin.config do |config|
  config.asset_source = :sprockets
  config.authenticate_with { warden.authenticate! scope: :user }
  config.current_user_method(&:current_user)
  config.main_app_name = %w[CheeseForMice Admin]
  config.included_models = %w[User Player ChangeLog UpdateLog]

  config.actions do
    dashboard
    index
    show
  end

  config.model 'User' do
    list { include_fields :id, :email, :role, :created_at, :updated_at }
  end

  config.model 'Player' do
    list do
      filters %i[name]
      include_fields :id, :a801_id, :name, :registration_date, :stats_reliability, :updated_last_7_days

      field(:change_logs) { pretty_value { bindings[:object].change_logs.size } }
    end

    show do
      include_all_fields

      field(:created_at)
    end
  end

  config.model 'ChangeLog' do
    list do
      filters %i[player created_at]
      include_fields :id, :player, :normal_score, :survivor_score, :racing_score, :defilante_score, :created_at
    end

    show do
      field(:created_at)

      include_all_fields
    end
  end

  config.model 'UpdateLog' do
    list do
      filters %i[created_at]
      include_fields :id, :status, :created_at, :completed_at

      field(:time_lapsed)
    end

    show do
      field(:status)
      field(:created_at)
      field(:completed_at)
      field(:time_lapsed)
    end
  end
end
