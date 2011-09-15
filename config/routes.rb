# encoding: utf-8

Horovod::Application.routes.draw do
  devise_for :users

  as :user do
    get '/login' => 'devise/sessions#new', :as => :new_user_session
    post '/login' => 'devise/sessions#create', :as => :user_session

    get '/password/reset' => 'devise/passwords#new', :as => :new_user_password
    post '/password' => 'devise/password#create', :as => :user_password
    get '/password/edit' => 'devise/passwords#edit', :as => :edit_user_password
    put '/password' => 'devise/password#create', :as => :user_password

    get '/hello' => 'devise/registrations#new', :as => :new_user_registration
    post '/profile' => 'devise/registrations#create', :as => :user_registration
    get '/profile' => 'devise/registrations#edit', :as => :edit_user_registration
    put '/profile' => 'devise/registrations#update', :as => :user_registration
    delete '/profile' => 'devise/registrations#destroy', :as => :user_registration

    get '/profile/:id' => 'users#show', :as => :user_profile,
      :constraints => { :id => /\d+/ }

    get '/logout' => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  resources :posts do
    collection do
      [ :text, :photo, :audio, :video ].each do |type|
        get type.to_s => :new, :as => type, :type => type
        post type.to_s => :create, :as => type, :type => type
      end
    end
  end
  get '/:id' => 'posts#show', :as => :post,
    :constraints => { :id => /\d+/ }
  delete '/:id' => 'posts#destroy', :as => :post,
    :constraints => { :id => /\d+/ }
  match '/:id/rate' => 'posts#rate', :as => :rate_post,
  :constraints => { :id => /\d+/, :score => /[12345]{1,1}/ }

  resources :ratings
  resources :news

  get '/recent' => 'dashboard#recent', :as => :recent
  get '/thebest' => 'dashboard#thebest', :as => :thebest

  namespace :info, :module => :pages do
    get 'general'
    get 'schedule'
    get 'song'
  end

  root :to => 'dashboard#recent'
end
