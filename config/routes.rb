Rails.application.routes.draw do
  root to: 'bins#index'

  resources :users, except: [:index, :edit, :update]
  resources :requests, except: [:index, :edit, :new, :update]
  resources :bins

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  post 'logout', to: 'sessions#destroy'
  post '/bins/:bin_url', to: 'bins#new_request'
end
