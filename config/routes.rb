Rails.application.routes.draw do
  get "notifications/index"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  root "pages#home"
  get "main", to: "main#index"

  # ペアID登録ページ(新規登録後専用)
  get "onboarding/pair", to: "onboarding#pair", as: :onboarding_pair
  post "onboarding/pair", to: "onboarding#create_pair"
  patch "onboarding/skip", to: "onboarding#skip", as: :onboarding_skip


  resources :users, only: [ :show, :edit, :update ] do
    post :regenerate_code, on: :member
  end

  resources :pairs, only: [ :new, :create, :destroy ]
  resources :posts, only: [ :new, :create, :show, :edit, :update, :destroy ]
  resources :post_memos, only: [ :create, :update ]

  resources :notifications, only: [ :index ] do
    patch :mark_as_read, on: :member
  end
end
