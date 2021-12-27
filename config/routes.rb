require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  # mount ActionCable.server => '/cable'
  namespace :admin do
    resources :users
    resources :medals
    resources :families
    resources :announcements
    resources :notifications
    resources :achievements
    resources :syncs
    resources :entries
    resources :reified_leaderboards
    resources :medal_statistics
    resources :memberships
    resources :membership_requests
    resources :groups
    resources :services

    root to: 'users#index'
  end
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  get '/connect', to: 'home#connect'
  get '/chase-mode', to: 'home#chase_mode'

  authenticated :user do
    root to: 'leaderboards#show', as: :authenticated_root
  end

  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :leaderboards
  resources :families, path: :games do
    resources :leaderboards
  end
  resources :medals
  resources :groups do
    resources :memberships
    resources :membership_requests
  end

  resources :membership_requests do
    resources :approvals
  end

  resource :chase_mode_config, path: :chase_mode_settings

  # resources :notifications, only: [:index]
  # resources :announcements, only: [:index]

  devise_for :users, controllers: {
    registrations: 'registrations'
  }

  namespace :api do
    namespace :v1 do
      resources :syncs
      resources :achievements
      resources :rivalries

      resources :entries
      resource :chase_mode_config
      resources :memberships
      resources :groups

      mount_devise_token_auth_for 'User', at: 'auth'
    end

    namespace :v2 do
      resources :rivalries
    end
  end

  get '/404', to: 'errors#not_found'
  get '/422', to: 'errors#unacceptable'
  get '/500', to: 'errors#internal_error'

  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
