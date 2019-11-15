Rails.application.routes.draw do  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :watchers
  resources :votes
  resources :comments
  resources :issues
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'issues#index'
end