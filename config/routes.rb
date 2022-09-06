Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }
  root to: "pages#home"
  resources :locations, only: %i[index create]
  resources :brands, only: %i[index create edit update]
  resources :stations, only: %i[index show new]
  get "stations_map", to: "stations#index_map"
end
