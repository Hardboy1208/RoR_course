Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers
  end

  root to: "questions#index"

  patch 'choose_the_best/:id', action: :choose_the_best, controller: 'answers'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
