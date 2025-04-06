Rails.application.routes.draw do
  devise_for :users
  get "home/index"
  root "home#index"
  
  resources :mood_entries
  
  get "up" => "rails/health#show", as: :rails_health_check
end
