Rails.application.routes.draw do
  get "main/index"
  devise_for :users
  root "pages#home"
  get "main", to: "main#index"
end
