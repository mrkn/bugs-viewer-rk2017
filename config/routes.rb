Rails.application.routes.draw do
  resources :user_stats, only: [:index, :create]

  root to: 'user_stats#index'
end
