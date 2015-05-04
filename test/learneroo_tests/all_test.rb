require 'test_helper'

class ControllersTest < ActionController::TestCase

	# Make tests run in alphabetical order
	def self.test_order
		:alpha
	end

	def setup
		@prod1 = Product.create(name: "Cow", price: 10)
		@prod2 = Product.create(name: "Pencil", price: 2)
	end

	def teardown
		Product.delete_all
	end

	def setup_quantity
		@prod1.update(quantity: 1)
		@prod2.update(quantity: 2)
	end

	## Product Test

	test "01 product created with name and price" do
		puts "Starting Product Model Tests"
		assert_equal @prod1.name, "Cow"
		assert_equal @prod1.price, 10
	end

	test "02 product can belong_to category" do
		category1 = Category.create(name: "Animals")
		@prod1.update(category: category1)
		assert_equal @prod1.category, category1
	end

	test "03 category has_many products" do
		category1 = Category.create(name: "Animals")
		@prod1.update(category: category1)
		assert_equal category1.products.first, @prod1
	end

	test "04 should not save product without name" do
		product = Product.new(price: 5)
		assert_not product.save
	end

	test "05 should not save product without price" do
		product = Product.new(name: "Pen")
		assert_not product.save
	end

	test "06 should save product with name and price" do
		product = Product.new(name: "Pen", price: 5)
		assert product.save
	end

	test "07 products should have quantity" do
		assert_respond_to(@prod1, :quantity)
		@prod1.update(quantity: 5)
		assert_equal(@prod1.quantity, 5)
	end

	test "08 .purchase should decrement quantity" do
		@prod1.update(quantity: 5)
		@prod1.purchase
		@prod1.purchase
		assert_equal(@prod1.quantity, 3)
	end

	test "09 .purchase should not decrement 0 quantity" do
		@prod1.update(quantity: 0)
		@prod1.purchase
		assert_equal(@prod1.quantity, 0)
	end

	test "10 .available only returns products with positive quantity" do
		@prod1.update(quantity: 0)
		@prod2.update(quantity: 2)
		prod3 = Product.create(name: "P3", price: 1, quantity: 1)
		available_products = [@prod2, prod3]
		assert_empty(Product.available - available_products)
	end

	test "11 .newest returns newest product" do
		newest = Product.create(name: "NewProd", price: 1, quantity: 1)
		assert_equal(Product.newest, newest)
	end

	test "12 .oldest returns oldest product" do
		assert_equal(Product.oldest, @prod1)
	end

	test "13 should not save product with negative price" do
		product = Product.new(name: "Pen", quantity: 1, price: -1)
		assert_not product.save
	end

	test "14 should not save product with negative quantity" do
		product = Product.new(name: "Pen", quantity: -1, price: 5)
		assert_not product.save
	end

	test "15 should save product with positive quantity and price" do
		product = Product.new(name: "Pen", quantity: 1, price: 5)
		assert product.save
	end


	## StoreController Tests

	def setup_store
		@controller = StoreController.new
		setup_quantity
	end

	### Routes to Views

	#controller
	test "20 gets home OK" do
		puts "\nFinished Product Model Tests. Starting StoreController Tests"
		setup_store
		get :home
		assert_response :success
	end

	test "21 gets about OK" do
		setup_store
		get :about
		assert_response :success
	end

	#routes
	test "22 root should route to home" do
		assert_routing '/', { controller: "store", action: "home"}
	end

	test "23 /about should route to about" do
		setup_store
		assert_routing '/about', { controller: "store", action: "about"}
	end

	#views
	test "24 home should have h1" do
		setup_store
		get :home
		assert_select('h1', 'Automated Store')
	end

	test "25 about should have h1" do
		setup_store
		get :about
		assert_select('h1', 'About the Store')
	end

	# contact page
	test "26 contact page works and has h1" do
		setup_store
		get :contact
		assert_response :success
		assert_select('h1', 'Contact Us')
	end

	### Controllers to Views

	test "27 home should have title" do
		setup_store
		get :home
		assert_select('title', 'Automated Store')
	end

	test "28 about should have title" do
		setup_store
		get :about
		assert_select('title', 'About the Store')
	end

	# leave contact page with default
	test "29 contact page should have default title" do
		setup_store
		get :contact
		assert_select('title', 'The Automated Store')
	end

	### M-C-V
	test "30 home should have newest product" do
		setup_store
		newest = Product.create(name: "NewProd", price: 1, quantity: 1)
		get :home
		assert_select('b', newest.name)
		assert_select('p', newest.description)
	end

	### CSS
	test "31 pages should link to home page" do
		setup_store
		get :home
		assert_select "a[href=?]", "/"

		get :about
		assert_select "a[href=?]", "/"
	end

	# no tests necessary for css styles

	## ProductsController Tests

	def setup_products
		setup_quantity
		@controller = ProductsController.new
	end

	### Standard Resources
	test "41 gets index OK" do
		puts "\nFinished StoreController Tests. Starting Products Tests"
		setup_products
		get :index
		assert_response :success
	end

	test "42 gets show OK" do
		setup_products
		get :show, id: @prod1.id
		assert_response :success
	end

	test "43 products/id should route to show" do
		assert_routing '/products/1', { controller: "products", action: "show", id: "1" }
	end

	test "44 products/ should route to index" do
		assert_routing '/products', { controller: "products", action: "index"}
	end

	### Presenting Products

	test "45 index page should display products" do
		setup_products
		get :index
		assert_match @prod1.name, response.body
		assert_match @prod2.name, response.body
	end

	test "46 index page should not show unavailable products" do
		setup_products
		Product.create(name: "Nitrogen", price: 1, quantity: 0)
		get :index
		assert_no_match("Nitrogen", response.body)
	end

	test "47 show page should display product info" do
		setup_products
		get :show, id: @prod1.id
		assert_select "h1", @prod1.name
		assert_select "p", @prod1.description
		assert_match @prod1.price.to_s, response.body #html not required.
	end

	### Links

	# Home page too!
	test "48 home page should display product link" do
		setup_quantity
		newest = Product.create(name: "NewProd", price: 1, quantity: 1)
		@controller = StoreController.new
		get :home
		assert_select "a[href=?]", "/products/#{newest.id}"
	end

	test "49 index page should display product links" do
		setup_products
		get :index
		products = [@prod1, @prod2] #Product.available

		products.each do |product|
			assert_select "a[href='/products/#{product.id}\']" do |element|
				assert_match product.name, element.text
			end
		end
	end

	# see earlier test to check for link to home.

	test "51 show should link to category if applicable" do
		setup_products
		category = Category.create(name: "Animals")
		@prod1.update(category: category)

		get :show, id: @prod1.id
		category_url = "/categories/#{category.id}"
		assert_select "a[href=?]", category_url
	end

	test "52 show OK if no parent category" do
		setup_products
		@prod1.update(category_id: nil)
		get :show, id: @prod1.id
		assert_response :success
	end

	## Categories Tests

	def setup_categories
		setup_quantity

		@controller = CategoriesController.new
		@category = Category.create(name: "Animals")
	end

	### Displaying Categories
	test "53 gets show OK and displays title" do
		puts "\nStarting Categories Tests"
		setup_categories
		get :show, id: @category.id
		assert_response :success
		assert_select "h1", @category.name
	end

	# see products#index test
	test "54 show page should show product links" do
		#setup:
		setup_categories
		@prod1.update(category: @category)
		@prod2.update(category: @category)

		#test:
		get :show, id: @category.id
		products = [@prod1, @prod2] #@category.products
		assert_select "ul" do
			assert_select "li", products.size
		end
		products.each do |product|
			assert_select "a[href='/products/#{product.id}\']" do |element|
				assert_match product.name, element.text
			end
		end
	end

	# Categories on home page
	test "55 home page should display categories" do
		Category.create(name: "Animals")
		Category.create(name: "Books")
		@controller = StoreController.new

		#test
		get :home
		Category.all.each do |category|
			assert_select "a[href=?]", "/categories/#{category.id}"
		end
	end

	## Back to Products

	# all pages, such as index, should render _header
	test "56 index should render _header" do
		puts "\nPartials Tests"
		setup_products
		get :index
		assert_template layout: "layouts/application", partial: "_header"
	end

	### partials
	test "57 index should render _product" do
		setup_products
		get :index
		assert_template layout: "layouts/application", partial: "_product"
	end

	test "58 display product price" do
		setup_products
		products = Product.available
		 get :index
		 products.each do |product|
			 assert_match "$#{product.price.to_s}", response.body
		 end
	end

end