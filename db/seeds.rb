# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

categories = Category.create([{name: 'Animals'}, {name: 'Food'}, {name: 'Electrical Devices'}])
products = Product.create([
    {name: "Parakeet", description: "Chirps, eats seeds.", price: 3, category_id: 1},
    {name: "Potato", description: "Starchy and nutritious.", price: 1, category_id: 2},
    {name: "Biscuits", description: "Carby and delicious.", price: 1, category_id: 2},
    {name: "Phonograph", description: "Sound-recording machine.", price: 5, category_id: 3},
                        ])
                        
products.each do |product|
  product.update_attribute(:quantity, 5)
end