Rails.application.routes.draw do
  resources :blogs
  devise_for :users
  root to: 'blogs#new'
  get 'others_blogs', to: 'blogs#others_blogs', as: :others_blogs
  get 'privacy_policy', to: 'homes#privacy_policy', as: :privacy_policy
end
