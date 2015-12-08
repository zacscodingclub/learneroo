class CreateLikes < ActiveRecord::Migration
  def change
    create_table :likes do |t|
      t.integer :user_id
      t.integer :product_id
      
      t.timestamps null: false
    end
    
    add_index :likes, :user_id
    add_index :likes, :product_id
    add_index :likes, [:product_id, :user_id], unique: true
  end
end
