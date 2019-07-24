Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  root 'homes#home'
  get '/home/about', to:'homes#about', as: 'about'
  post 'book_cover_search', to:'books#cover_search', as: 'book_cover_search'
  resources :books, :only => [:index, :show, :update, :destroy, :edit, :create]
  resources :users, :only => [:index, :show, :update, :edit]
  resources :book_comments, :only => [:create, :edit, :destroy, :update]
  resources :favorites, :only => [:show, :destroy, :new]
  resources :follows, :only => [:show, :new, :destroy]
  resources :searchs, :only => [:index]
end
