require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks" }

  concern :retractable do
    member do
      patch 'rating_up'
      patch 'rating_down'
      patch 'rating_reset'
    end
  end

  resources :questions, concerns: :retractable do
    resources :answers, shallow: true, concerns: :retractable do
      patch 'choose_the_best', on: :member
      resource :comments
    end
    resources :subscriptions, only: [:create, :destroy], shallow: true

    resource :comments
  end

  resources :attachments, only: [:destroy]
  get :search, to: 'searchs#search'

  root to: "questions#index"
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end

end
