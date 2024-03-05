Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  root 'goals#index'

  get "auth/discord/callback", to: "users/sessions#callback"
  namespace :users do
    resources :sessions, only: %i[new]
  end
  namespace :companies do
    resources :sessions, only: %i[new create]
    resources :passwords, only: [:new, :create, :edit, :update]
  end
  resources :goals
  resources :users, only: %i[index show edit update]
  resources :companies, only: %i[index show new create]
  resources :sessions, only: %i[destroy]
end
