Rails.application.routes.draw do
  root 'goals#index'

  get "auth/discord/callback", to: "users/sessions#callback"
  resources :users, only: %i[index show]
  namespace :users do
    resources :sessions, only: %i[new destroy]
  end
  resources :relationships, only: %i[create destroy]
  resources :goals do
    resources :tasks, module: :goals
    resources :complete_posts, only: %i[new create], module: :goals
    resources :comments, only: %i[index create], module: :goals
  end
  resources :tasks, only: [] do
    resources :complete_posts, only: %i[new create], module: :tasks
    resources :comments, only: %i[index create], module: :tasks
  end
end
