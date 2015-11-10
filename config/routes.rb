Rails.application.routes.draw do

  root to: 'store#home'

  get 'about', to:'store/about'
  get 'contact', to: 'store#contact'

end
