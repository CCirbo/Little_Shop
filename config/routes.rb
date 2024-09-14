Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "/api/v1/merchants", to: "api/v1/merchants#index"
  get "/api/v1/merchants/:id", to: "api/v1/merchants#show"
  patch "/api/v1/merchants/:id", to: "api/v1/merchants#update" 
  post "/api/v1/merchants", to: "api/v1/merchants#create"

  delete "/api/v1/merchants/:id", to: "api/v1/merchants#destroy"
  get "/api/v1/items", to: "api/v1/items#index"
  get "/api/v1/items/:id", to: "api/v1/items#show"
  patch "/api/v1/items/:id", to: "api/v1/items#update" 
  post "/api/v1/items", to: "api/v1/items#create"

  get '/api/v1/items/:id/merchant', to: 'api/v1/merchant_items#show'
  get '/api/v1/merchants/:id/items', to: 'api/v1/item_merchants#index'
end
