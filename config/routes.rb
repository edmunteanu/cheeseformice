# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'players#index'

  authenticate :user, ->(user) { user.admin? } do
    mount GoodJob::Engine => '/good_job'
    mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  end
end
