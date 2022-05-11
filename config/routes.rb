Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  concern :commentable do
    resources :comments, only: %i[create destroy]
  end

  # example: localhost:3000/[ru|en]/questions as
  # specified in the config.i18n.available_locales
  scope '(:locale)', locale: /#{I18n.available_locales.join("|")}/ do
    resource :session, only: %i[new create destroy]

    resources :users, only: %i[new create edit update]

    # resources :questions, only: %i[index new create edit update destroy show]
    # it's the same as above ↑
    # using concern instead doubling
    resources :questions, concerns: :commentable do
      resources :answers, except: %i[new show]
    end

    # using concern instead doubling
    resources :answers, except: %i[new show], concerns: :commentable

    # administrator resource /admin/users
    namespace :admin do
      resources :users, only: %i[index create]
    end

    root 'pages#index'
  end
end
