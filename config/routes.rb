Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', registrations: 'registrations' }
  root to: "pages#home"
  resources :locations, only: %i[index new create]
  resources :brands, only: %i[index create]
  resources :stations, only: %i[index show new]
end
