Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resource :session, only: %i[new create destroy]

  resources :users, only: %i[new create edit update]

  # resources :questions, only: %i[index new create edit update destroy show]
  # it's the same as above ↑
  resources :questions do
    resources :answers, except: %i[new show]
  end

  # administrator resource /admin/users
  namespace :admin do
    resources :users, only: %i[index create]
  end

  root 'pages#index'
end
