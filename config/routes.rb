# frozen_string_literal: true

Rails.application.routes.draw do
  root 'timelines#index'

  get 'auth/discord/callback', to: 'users/sessions#callback'
  get 'auth/failure', to: 'users/sessions#failure'
  resources :users, only: %i[index show edit update]
  namespace :users do
    resources :sessions, only: %i[new destroy]
  end
  resources :friendships, only: %i[create destroy]
  resources :goals do
    resources :tasks, only: %i[index show create update destroy], module: :goals
    resources :complete_posts, only: %i[new create], module: :goals
    resources :comments, only: %i[index create], module: :goals
  end
  resources :tasks, only: [] do
    resources :complete_posts, only: %i[new create], module: :tasks
    resources :comments, only: %i[index create], module: :tasks
  end
  resources :comments, only: %i[destroy] do
    resources :reactions, only: %i[create], module: :comments
  end
  resources :complete_posts, only: [] do
    resources :reactions, only: %i[create], module: :complete_posts
  end
  resources :reactions, only: %i[destroy]
  resources :timelines, only: %i[index]
  resources :notifications, only: %i[index show]

  # 利用規約, プライバシーポリシー
  get '/pages/*id' => 'pages#show', as: :static_page, format: false
end
