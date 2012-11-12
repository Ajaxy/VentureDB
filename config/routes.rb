Venture::Application.routes.draw do
  devise_for :users

  resources :projects
  resources :authors

  resources :deals
  resources :investments
  resources :investors

  root to: "deals#index"
end
