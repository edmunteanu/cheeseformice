# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root to: 'players#index'

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  mount GoodJob::Engine => '/admin/jobs'
end
