Rails.application.routes.draw do
  root to: 'brands#index'

  resources :brands
  resources :phones
  resources :search
end
