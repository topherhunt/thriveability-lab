Rails.application.routes.draw do
  root to: 'home#home'
  get 'home'  => 'home#home'
  get 'about' => 'home#about'
  get 'throwup' => 'home#throwup'

  devise_for :users

  resources :users, only: [:show, :edit, :update] do
    member do
      get :edit_resources
    end
  end

  resources :resources, only: [:new, :create, :show]

  resources :projects, only: [:index, :new, :create, :edit, :update, :show]
end
