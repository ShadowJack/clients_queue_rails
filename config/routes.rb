Rails.application.routes.draw do
  resources :clients
  post '/clients/clean', to: 'clients#clean'
  root to: 'clients#index'

  
end
