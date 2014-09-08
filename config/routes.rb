Rails.application.routes.draw do
  resources :proposals

  root to: 'proposals#index'
end
