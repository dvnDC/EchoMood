Rails.application.routes.draw do
  devise_for :users
  get "home/index"
  root "home#index"

  get 'articles', to: 'articles#index', as: :articles
  get 'articles/:id', to: 'articles#show', as: :article

  resources :mood_entries
  resources :emotion_entries

  get "up" => "rails/health#show", as: :rails_health_check
end
