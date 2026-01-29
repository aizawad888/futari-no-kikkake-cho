Rails.application.routes.draw do
  get "useful/index"
  root "home#index"

  get "notification_settings/show"
  get "notification_settings/update"
  get "notifications/index"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # デモモード
  devise_scope :user do
    post "demo_login", to: "users/sessions#demo", as: :demo_login
  end

  get "main", to: "main#index"

  # ペアID登録ページ(新規登録後専用)
  get "onboarding/pair", to: "onboarding#pair", as: :onboarding_pair
  post "onboarding/pair", to: "onboarding#create_pair"
  get "onboarding/skip", to: "onboarding#skip", as: :onboarding_skip


  resources :users, only: [ :show, :edit, :update ] do
    post :regenerate_code, on: :member
  end

  resource :user, only: [ :destroy ]

  resources :pairs, only: [ :new, :create, :destroy ]
  resources :posts, only: [ :new, :create, :show, :edit, :update, :destroy ]
  resources :post_memos, only: [ :create, :update ]

  resources :notifications, only: [ :index ] do
    member do
      patch :mark_as_read  # ← memberブロック内に定義
    end
    collection do
      patch :mark_all_as_read
    end
  end

  resource :notification_settings, only: [ :show, :update ]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end


  resources :anniversaries, only: [ :index, :new, :create, :show, :edit, :update, :destroy ]

  resource :board, only: [ :show, :update ]

  # お役立ちページの分岐
  get "useful", to: "useful#index", as: :useful

  # 今日できる簡単なこと
  get "daily_tasks", to: "daily_tasks#index"

  # ルールブック
  resources :rule_items, only: [ :index, :new, :create, :edit, :update, :destroy ]

  # 静的ページ
  get "about",   to: "pages#about"
  get "contact", to: "pages#contact"
  get "terms",   to: "pages#terms"
  get "privacy", to: "pages#privacy"

  # 投稿プリセット
  resources :presets, only: [ :index, :new, :create, :edit, :update, :destroy ]
end
