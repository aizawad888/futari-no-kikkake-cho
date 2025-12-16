Rails.application.routes.draw do
  devise_for :users

  root "pages#home"
  get "main", to: "main#index"

  resources :users, only: [ :show ] do
    member do
      post :regenerate_code
    end
  end

  resources :pairs, only: [ :new, :create ] do
    member do
      patch :dissolve  # ペア解消アクション
    end
  end


  resources :posts, only: [ :new, :create, :show, :edit, :update, :destroy ]
end
