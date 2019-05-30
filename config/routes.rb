Rails.application.routes.draw do
  root to: "pages#home"
  devise_for :users
  resources :items do
    resources :rentals, only: [:new, :create]
  end
  resources :rentals, only: [:index, :show, :destroy]
end
