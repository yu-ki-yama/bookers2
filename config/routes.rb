Rails.application.routes.draw do
  root to:'homes#index'
  get '/home/about', to:'homes#about', as: 'about'
  devise_for :users

  # Todo ルート未調整
  resources :books
  resources :users

end
