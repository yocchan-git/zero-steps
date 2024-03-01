Rails.application.routes.draw do
  root 'home#index'

  get "auth/discord/callback", to: "users/sessions#callback"
  namespace :users do
    resources :sessions, only: %i[new destroy]
  end
end
