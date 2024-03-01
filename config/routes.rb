Rails.application.routes.draw do
  root 'goals#index'

  get "auth/discord/callback", to: "users/sessions#callback"
  namespace :users do
    resources :sessions, only: %i[new destroy]
  end
  resources :goals
end
