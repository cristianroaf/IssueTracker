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
  
  

  #-----------API-------------------

  get '/api/issues' => "api#issues"
  post '/api/issues' => "api#newissue"
  
  get '/api/issues/:issue_id' => "api#getissue"
  put '/api/issues/:issue_id' => "api#editissue"
  delete '/api/issues/:issue_id' => "api#deleteissue"
  
  post '/api/issues/:issue_id/vote' => "api#vote"
  post '/api/issues/:issue_id/unvote' => "api#unvote"
  post '/api/issues/:issue_id/watch' => "api#watch"
  post '/api/issues/:issue_id/unwatch' => "api#unwatch"
  
  put '/api/issues/:issue_id/status' => "api#editstatus"
  
  get '/api/issues/:issue_id/comments' => "api#getcomments"
  post '/api/issues/:issue_id/comments' => "api#newcomment"
  
  get '/api/issues/:issue_id/comments/:id' => "api#getcomment"
  put '/api/issues/:issue_id/comments/:id' => "api#editcomment"
  delete '/api/issues/:issue_id/comments/:id' => "api#deletecomment"
  
  
end