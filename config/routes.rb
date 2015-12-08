Rails.application.routes.draw do

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :categories, only: :show
  resources :products
  resources :likes, only: [:create, :destroy]

  root to: 'store#home'

  get 'sold_out', to: 'products#sold_out'
  get 'about', to:'store#about'
  get 'contact', to: 'store#contact'
  get 'my_page', to: 'users#my_page'
end
