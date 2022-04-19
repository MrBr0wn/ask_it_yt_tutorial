Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  # resources :questions, only: %i[index new create edit update destroy show]
  # it's the same as above ↑
  resources :questions

  root 'pages#index'
end
