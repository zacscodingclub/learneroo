class User < ActiveRecord::Base
  has_many :likes, dependent: :destroy
  has_many :liked_products, through: :likes, source: :product
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  def like(product)
    Like.create(user: self, product: product)
  end
  
  def likes?(product)
    liked_products.include?(product)
  end
end
