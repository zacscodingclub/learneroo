class StoreController < ApplicationController
  def home
    @title = "Automated Store"
    @new = Product.newest
    @categories = Category.all
  end

  def about
    @title = "About"
  end
  
  def contact
    @title = "Contact"
  end
end
