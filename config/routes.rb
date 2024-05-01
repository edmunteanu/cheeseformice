# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  get '/leaderboard', to: 'players#index'

  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine => '/good_job'
  end

  authenticated :user do
    root to: 'players#index', as: :authenticated_root
  end

  root to: 'home#index'
end
