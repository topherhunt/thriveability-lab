Rails.application.routes.draw do
  root to: "home#home"
  get "home"  => "home#home"
  get "about" => "home#about"
  get "guiding_principles" => "home#guiding_principles"
  get "how_you_can_help" => "home#how_you_can_help"
  get "throwup" => "home#throwup"
  get "ping" => "home#ping"

  get "auth/auth0_callback" => "auth#auth0_callback"
  get "auth/logout" => "auth#logout", as: "logout"
  get "auth/force_login/:user_id" => "auth#force_login", as: "force_login"

  resources :users, only: [:index, :show, :edit, :update]

  resources :conversations, only: [:index, :new, :create, :edit, :update, :show]

  resources :comments, only: [:create, :edit, :update, :destroy]

  resources :resources

  resources :projects, only: [:index, :show, :new, :create, :edit, :update]

  get "/search", to: "search#search", as: "search"

  resources :messages, only: [:new, :create]

  resources :notifications, only: [:index, :show]
  post "notifications/mark_all_read" => "notifications#mark_all_read", as: "mark_all_read_notifications"

  post   "like_flags/:target_type/:target_id" => "like_flags#create", as: "like_flag"
  delete "like_flags/:target_type/:target_id" => "like_flags#destroy"

  get    "stay_informed_flags/:target_type/:target_id" => "stay_informed_flags#index",
         as: "stay_informed_flags"
  post   "stay_informed_flags/:target_type/:target_id" => "stay_informed_flags#create",
         as: "stay_informed_flag"
  delete "stay_informed_flags/:target_type/:target_id" => "stay_informed_flags#destroy"

  get    "get_involved_flags/:target_type/:target_id" => "get_involved_flags#index",
         as: "get_involved_flags"
  post   "get_involved_flags/:target_type/:target_id" => "get_involved_flags#create",
         as: "get_involved_flag"
  delete "get_involved_flags/:target_type/:target_id" => "get_involved_flags#destroy"

  # Explicitly handle missing routes
  get '/:unknown_route', to: "home#missing_route", constraints: {unknown_route: /.*/}
end
