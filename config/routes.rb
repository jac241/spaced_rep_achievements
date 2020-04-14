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

  namespace :api do
    namespace :v1 do
      resources :syncs
    end
  end

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end


  resources :notifications, only: [:index]
  resources :announcements, only: [:index]
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  root to: 'home#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
