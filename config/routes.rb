Rails.application.routes.draw do  
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :issues
  resources :users
  resources :issues do
    resources :comments
  end


  root 'issues#index'

  get '/issues/:issue_id/comments/:id/attachment' => "comments#show_attachment"
  post '/issues/:issue_id/comments/:id/attachment' => "comments#create_attachment"
  
  get '/issues/:id/attachment' => "issues#show_attachment"
  post '/issues/:id/attachment' => "issues#create_attachment"

  post '/issues/:id/vote' => "issues#vote", as: :vote
  post '/issues/:id/watch' => "issues#watch", as: :watch
  
  put '/issues/:id/status' => "issues#update_status", as: :update_status

  get '/api/issues' => "api#issues"
  
end