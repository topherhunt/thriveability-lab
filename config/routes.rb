Rails.application.routes.draw do
  root to: 'home#home'
  get 'home'  => 'home#home'
  get 'about' => 'home#about'
  get 'throwup' => 'home#throwup'

  # Thanks to https://github.com/plataformatec/devise/wiki/OmniAuth:-Overview
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  delete 'users/omniauth_accounts/:provider' => 'users/omniauth_accounts#destroy', as: 'users_omniauth_account'

  resources :users, only: [:show, :edit, :update] do
    member do
      post :reset_password
    end
  end

  resources :resources

  resources :projects, only: [:index, :show, :new, :create, :edit, :update]

  resources :posts, only: [:index, :show, :create, :edit, :update, :destroy] do
    collection do
      get :reply
    end
  end

  resources :post_conversants, only: [:new, :create]
end
