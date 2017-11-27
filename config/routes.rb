Rails.application.routes.draw do
  resources :categories
  devise_for :users
  resources :articles do
    resources :comments, only: %i[create destroy update]
  end
  root 'welcome#index'
  get '/dashboard', to: 'welcome#dashboard'
  put '/articles/:id/publish', to: 'articles#publish'
  # put '/articles/:id/unpublish', to: 'articles#unpublish'
end
