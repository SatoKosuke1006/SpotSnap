# frozen_string_literal: true

Rails.application.routes.draw do
  root   'sessions#new'
  get    '/home',           to: 'static_pages#home'
  get    '/signup',         to: 'users#new'
  get    '/login',          to: 'sessions#new'
  post   '/login',          to: 'sessions#create'
  delete '/logout',         to: 'sessions#destroy'
  get     'how_to_use',     to: 'static_pages#how_to_use'
  get    '/new_post',       to: 'microposts#new'
  get    '/microposts',     to: 'static_pages#home'
  get    '/location_posts', to: 'location_posts#index'
  get    '/location_posts/count', to: 'location_posts#count'

  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :microposts do
    resource :likes, only: %i[create destroy]
  end

  resources :maps, only: [:index]
  resources :likes, only: [:index]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: %i[new create edit update]
  resources :microposts,          only: %i[create destroy show]
  resources :relationships,       only: %i[create destroy]
end
