# frozen_string_literal: true

# rubocop:disable Metrics/BlockLength

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  # Defines the root path route ("/")

  root 'web/bulletins#index'

  scope module: 'web' do
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#destroy', as: :logout

    resources :bulletins, except: :destroy do
      member do
        patch :send_to_moderation
        patch :archive
      end
    end

    get '/profile', to: 'profile#index'

    scope module: 'admin', path: 'admin' do
      resources :categories, except: :show
      get '/', to: 'bulletins#index', defaults: { template: 'moderation' }, as: :moderation_bulletins

      resources :bulletins, as: 'admin', only: [:index] do
        member do
          patch :published
          patch :rejected
          patch :archive
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
