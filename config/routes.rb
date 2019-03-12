Rails.application.routes.draw do
  resources :blogs
  devise_for :users
  get 'homes/index'
  root to: 'blogs#new'
  get 'others_blogs', to: 'blogs#others_blogs', as: :others_blogs

end
