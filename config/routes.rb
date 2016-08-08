Rails.application.routes.draw do
  root to: 'home#home'
  get 'home'  => 'home#home'
  get 'about' => 'home#about'
  get 'throwup' => 'home#throwup'

  devise_for :users

  resources :users, only: [:show, :edit, :update]

  resources :resources, only: [:new, :create, :edit, :update, :show]

  resources :projects, only: [:index, :new, :create, :edit, :update, :show]

  resources :posts, only: [:index, :create, :edit, :update, :show] do
    collection do
      get :drafts
      get :reply
    end
  end

  resources :post_conversants, only: [:new, :create]
end
