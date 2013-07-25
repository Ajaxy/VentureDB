Venture::Application.routes.draw do
  devise_for :users, controllers: {
    registrations:  'users/registrations',
    passwords:      'users/passwords',
    sessions:       'users/sessions',
    confirmations:  'users/confirmations',
  }

  namespace :admin do
    root to: 'deals#index'

    resources :deals do
      member do
        post :publish
        post :unpublish
      end
    end

    resources :projects
    resources :investors
    resources :users do
      member do
        post :approve
      end
    end

    resources :subscriptions do
      member do
        post :approve
      end
    end

    resources :people
    resources :investments
    resources :events
    resources :companies
  end

  resources :deals, only: %w[index]
  resources :people, only: %w[show]
  resources :projects, only: %w[index show]
  resources :investors, only: %w[index show]
  resources :statistics, only: %w[index]
  resources :researches, only: %w[index]
  resources :companies, only: %w[index show]
  resources :people, only: %w[show]
  resources :informers, only: %w[show]
  resources :authors, only: %w[show]

  #get  '/about' => 'about#index'
  #post '/about' => 'about#feedback'

  get '/search' => 'search#index'
  get '/search/suggest' => 'search#suggest'

  get 'account/' => 'account#index'
  get 'account/index' => 'account#index'  #todo wtf
  get 'account/edit'
  get 'account/plan'
  get 'account/plan_order'
  put 'account/plan_order' => 'account#plan_order_update'

  root to: 'deals#index', via: 'get', constraints: lambda { |r| r.env['warden'].authenticate? }
  root to: 'promo#index', via: 'get'
  get '/promo' => 'promo#index'
  get '/login' => 'promo#login'
  get '/subscribe' => 'promo#subscribe'
  post '/subscribe' => 'promo#subscribe_post'
  get '/about' => 'promo#about'
  get '/monitoring' => 'promo#monitoring'
  get '/plans' => 'promo#plans'
  get '/analytics' => 'promo#analytics'

  # get '/subscribed'  => 'promo#subscribed'
  # post '/subscribed' => 'promo#participate'

  post '/markdown/preview' => 'markdown#preview'
end
