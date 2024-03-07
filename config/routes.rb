Rails.application.routes.draw do
  root 'goals#index'

  get "auth/discord/callback", to: "users/sessions#callback"
  resources :users, only: %i[index show]
  namespace :users do
    resources :sessions, only: %i[new destroy]
  end
  resources :goals do
    resources :complete_posts, only: %i[new create], module: :goals
  end
end
