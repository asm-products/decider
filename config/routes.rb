Rails.application.routes.draw do
  resources :proposals
  resources :replies

  root to: 'proposals#index'
end
