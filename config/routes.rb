Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  get '/new', to: 'users#new'
  
  root 'static_pages#home'
  get '/help', to: 'static_pages#help', as: 'helps'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :account_activations, only: [:edit]
  resources :users do 
    member do 
      get :following, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  resources :microposts, only: [:create, :destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
