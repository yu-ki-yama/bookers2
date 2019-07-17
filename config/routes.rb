Rails.application.routes.draw do
  get 'follows/index'
  get 'favorites/show'
  root to:'homes#index'
  get '/home/about', to:'homes#about', as: 'about'
  devise_for :users

  resources :books, :except => 'new'
  resources :users, :except => 'new'
  resources :book_comments, :except => [:index, :new, :show]
  resources :favorites, :only => [:show, :destroy, :new]

  resources :follows
  resources :searchs, :only => [:index]
end
