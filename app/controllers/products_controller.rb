class ProductsController < ApplicationController
  before_action :confirm_admin!, only: :sold_out
  
  def show
    @product = Product.find(params[:id])
    @title = @product.name
  end

  def index
    @title = "All Products"
    @products = Product.available
  end
  
  def sold_out
    @title = "Sold Out :("
    @products = Product.sold_out
    render 'index'
  end
  
  private
    def confirm_admin!
      unless current_user.try(:admin?)
        redirect_to root_path
      end
    end
end
