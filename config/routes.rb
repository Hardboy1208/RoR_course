Rails.application.routes.draw do
  devise_for :users

  concern :retractable do
    member do
      patch 'rating_up'
      patch 'rating_down'
      patch 'rating_reset'
    end
  end

  resources :questions, concerns: :retractable do
    resources :answers, concerns: :retractable do
      patch 'choose_the_best', on: :member
    end
  end

  resources :attachments, only: [:destroy]

  root to: "questions#index"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
