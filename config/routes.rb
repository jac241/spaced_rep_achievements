require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  namespace :admin do
    resources :achievements
    resources :medals
    resources :families
    resources :users
    resources :announcements
    resources :notifications
    resources :services
    resources :syncs

    root to: "users#index"
  end
  get '/privacy', to: 'home#privacy'
  get '/terms', to: 'home#terms'
  get '/connect', to: 'home#connect'
  get '/chase-mode', to: 'home#chase_mode'

  authenticated :user do
    resources :families, path: :games do
      resources :leaderboards
    end

    root to: 'leaderboards#show', as: :authenticated_root, family_id: 'halo-3', id: 'monthly'
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :leaderboards

  #resources :notifications, only: [:index]
  #resources :announcements, only: [:index]

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "registrations",
  }

  namespace :api do
    namespace :v1 do
      resources :syncs
      resources :achievements
      resources :rivalries

      mount_devise_token_auth_for 'User', at: 'auth'
    end
  end

  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
