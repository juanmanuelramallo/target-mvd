# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server, at: '/cable'
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:omniauth_callbacks], controllers: {
    registrations: 'auth/registrations',
    passwords: 'auth/passwords'
  }

  namespace :auth do
    post 'facebook/callback', to: 'facebook_callbacks#create'
    post 'cable', to: 'cable#create'
  end

  resources :compatible_targets, only: :index
  resources :conversations, only: %i[create index show update] do
    resources :messages, only: %i[create index]
  end
  resources :targets, only: %i[create index destroy update]
  resources :topics, only: :index
end
