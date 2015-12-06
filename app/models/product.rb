class Product < ActiveRecord::Base
  validates :name, presence: true
  belongs_to :category
  
  def purchase
    if quantity > 0
      decrement(:quantity)
      return true
    end
  end
  
  def self.available
    Product.where.not(quantity: 0)
  end
  
  def self.newest
    Product.order(:created_at).last
  end
  
  def self.oldest
    Product.order(:created_at).first
  end
  
  def self.sold_out
    Product.where(quantity: 0)
  end
end
