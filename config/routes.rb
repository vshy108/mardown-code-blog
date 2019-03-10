Rails.application.routes.draw do
  resources :blogs
  devise_for :users
  get 'homes/index'
  root to: 'blogs#new'
end
