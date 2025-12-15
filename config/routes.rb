Rails.application.routes.draw do
  devise_for :users

  root "pages#home"
  get "main", to: "main#index"

  resources :posts, only: [ :new, :create, :show ]
end
