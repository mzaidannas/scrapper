require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :users
  resources :users
  authenticate :user do
    mount Sidekiq::Web, at: '/sidekiq'
    mount Avo::Engine, at: Avo.configuration.root_path
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "dashboard#index"
end
