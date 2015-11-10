Rails.application.routes.draw do

  resources :categories, only: :show
  resources :products

  root to: 'store#home'

  get 'about', to:'store#about'
  get 'contact', to: 'store#contact'

end
