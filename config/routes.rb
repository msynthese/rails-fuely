Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :locations, only: %i[index create]
  resources :brands, only: %i[index create]
end
