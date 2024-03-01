Rails.application.routes.draw do
  root 'home#index'

  namespace :users do
    resources :sessions, only: %i[new destroy]
  end
end
