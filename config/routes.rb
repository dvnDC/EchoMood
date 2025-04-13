Rails.application.routes.draw do
  devise_for :users
  get "home/index"
  root "home#index"
  get 'meditation', to: 'meditation#index', as: :meditation

  get 'articles', to: 'articles#index', as: :articles
  get 'articles/:id', to: 'articles#show', as: :article

  resources :mood_entries do
    collection do
      get :all
    end
  end
  resources :emotion_entries do
    collection do
      get :all
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
