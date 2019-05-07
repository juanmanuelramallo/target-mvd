# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks]

  namespace :auth do
    post 'facebook/callback', to: 'facebook_callbacks#create'
  end

  resources :compatible_targets, only: :index
  resources :targets, only: %i[create index destroy]
end
