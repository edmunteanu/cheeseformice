Rails.application.routes.draw do
  get "/up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine, at: "/good_job"
    mount Blazer::Engine, at: "/blazer"
  end

  authenticated :user do
    root to: "players#index", as: :authenticated_root
  end

  root to: "home#index"

  get "/leaderboard", to: "players#index"

  resources :players, only: :show

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_server_error"
end
