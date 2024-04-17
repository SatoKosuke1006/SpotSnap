Rails.application.routes.draw do
  root   "sessions#new"
  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/contact", to: "static_pages#contact"
  get    "/home",    to: "static_pages#home"
  get    "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"
  get    "/new_post",   to: "microposts#new"
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :microposts do
    resource :likes, only: [:create, :destroy]
  end

  resources :maps, only: [:index]
  resources :likes, only: [:index]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:create, :destroy, :show]
  resources :relationships,       only: [:create, :destroy]
  get '/microposts', to: 'static_pages#home'
end
