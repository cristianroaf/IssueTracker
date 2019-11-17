Rails.application.routes.draw do  
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :issues
  resources :users
  resources :issues do
    resources :comments
  end


  root 'issues#index'

  post '/issues/:id/vote' => "issues#vote", as: :vote
  post '/issues/:id/watch' => "issues#watch", as: :watch

end