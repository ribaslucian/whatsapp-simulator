Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  root to: redirect('/login')
  
  namespace :offline, path: '/' do
    #root :to => "users#login", namespace: 'offline'
  
    # users routes
    match '/login', to: 'users#login', as: :login, via: [:get, :post]
    match '/forgot_password', to: 'users#forgot_password', as: :forgot_password, via: [:get, :post]
    match '/new_password', to: 'users#new_password', via: [:get, :post]
  end
  
  
  
  
  namespace :online, path: '/' do
  
    
    # users routes
    get '/logout', to: 'users#logout', as: :logout
    
    
    # dashboards routes
    get '/dashboard', to: 'dashboards#primary', as: :dashboard

    
    # help routes
    get '/help', to: 'protocols#help', as: :help
    post '/help', to: 'protocols#help_send', as: :help_send
    
    
    # api requests
    scope format: true, constraints: { format: 'json' } do
      get '/api/associateds', to: 'api#associateds'
      get '/api/card/:card_code/validation', to: 'api#card_validation'
    end
    
    
    # profile routes
    get '/profile', to: 'users#profile'
    post '/profile_update', to: 'users#profile_update'
    match '/update_password', to: 'users#update_password', via: [:get, :post]
    
    resources :questionnaries
    resources :messages
    get '/rooms', to: 'rooms#index'
  end
  
  get '*path' => redirect('/dashboard')
  
end
