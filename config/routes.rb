Rails.application.routes.draw do
  root 'timelines#index'

  get "auth/discord/callback", to: "users/sessions#callback"
  resources :users, only: %i[index show]
  namespace :users do
    resources :sessions, only: %i[new destroy]
  end
  resources :relationships, only: %i[create destroy]
  resources :goals do
    resources :tasks, only: %i[index show create update destroy], module: :goals
    resources :complete_posts, only: %i[new create], module: :goals
    resources :comments, only: %i[index create], module: :goals
  end
  resources :tasks, only: [] do
    resources :complete_posts, only: %i[new create], module: :tasks
    resources :comments, only: %i[index create], module: :tasks
  end
  resources :comments, only: [] do
    resources :reactions, only: %i[create], module: :comments
  end
  resources :complete_posts, only: [] do
    resources :reactions, only: %i[create], module: :complete_posts
  end
  resources :reactions, only: %i[destroy]
  resources :timelines, only: %i[index]
  resources :notifications, only: %i[index show]
end
