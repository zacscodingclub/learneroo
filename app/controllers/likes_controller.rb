class LikesController < ApplicationController
  def create
    product = Product.find(params[:product_id])
    current_user.like(product)
    redirect_to :back
  end
  
  def destroy
    Like.destroy(params[:id])
    redirect_to :back
  end
end
