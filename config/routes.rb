require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :users
  authenticate :user do
    mount Sidekiq::Web, at: '/sidekiq'
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  # Defines the root path route ("/")
  root to: "avo/home#index"
end
