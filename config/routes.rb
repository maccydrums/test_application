Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
end
get 'cars/upload_image', to: 'cars#upload_image'
  resources :cars
    # global options responder -> makes sure OPTION request for CORS endpoints work
  get 'welcome/index'
 
  root 'welcome#index'
end