Rails.application.routes.draw do
  resources :proposals
  resources :replies
  resources :users, only: [:new, :create]

  root to: 'proposals#index'
end
