Rails.application.routes.draw do
  resources :cars
    # global options responder -> makes sure OPTION request for CORS endpoints work
  get 'welcome/index'
 
  root 'welcome#index'
end