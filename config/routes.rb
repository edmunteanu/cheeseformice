Rails.application.routes.draw do
  get "/up" => "rails/health#show", as: :rails_health_check

  devise_for :users

  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine, at: "/good_job"
    mount Blazer::Engine, at: "/blazer"
  end

  root to: "home#index"

  get "/leaderboard", to: "players#index"

  resources :players, only: :show, param: :name do
    collection do
      get :search
    end
  end

  get "/404", to: "errors#not_found"
  get "/500", to: "errors#internal_server_error"
end
