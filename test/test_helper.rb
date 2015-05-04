ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/fail_fast' #stop on failure
require 'learneroo_gem' #medium output

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  # Add more helper methods to be used by all tests here...
end

# if add Devise in future:
class ActionController::TestCase
  include Devise::TestHelpers if Devise
end
