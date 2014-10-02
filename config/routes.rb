Rails.application.routes.draw do
  resources :proposals
  resources :replies
  resources :users, only: [:new, :create]
  resources :user_sessions

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout

  root to: 'proposals#index'
end
