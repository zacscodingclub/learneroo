class ProductsController < ApplicationController
  def show
    @product = Product.find(params[:id])
    @title = @product.name
  end

  def index
    @title = "All Products"
    @products = Product.available
  end
end
