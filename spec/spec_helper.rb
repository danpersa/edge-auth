# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl'

#ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/factories/**/*.rb")].each {|f| require f}
Dir[Rails.root.join("../support/**/*.rb")].each {|f| require f}
#Dir[ENGINE_RAILS_ROOT].each {|f| require f}

FactoryGirl.definition_file_paths << File.join(File.dirname(__FILE__), 'spec/factories')
FactoryGirl.find_definitions



RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  config.before do
    Mongoid.purge!
  end


  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  def test_activate_user(user)
    if !user.activated?
      user.activate!
    end
  end

  def test_sign_in(user)
    test_activate_user(user)
    controller.sign_in(user)
  end
  
  def test_web_sign_in(user)
    test_activate_user(user)
    visit signin_path
    fill_in "Email",    :with => user.email
    fill_in "Password", :with => user.password
    click_button "Sign in"
    return user
  end
end
