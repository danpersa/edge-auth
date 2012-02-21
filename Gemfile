source "http://rubygems.org"

# Declare your gem's dependencies in edge-auth.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'mongoid', '2.4.0'
gem 'bson_ext'
gem 'mongo_ext'
gem 'simple_form'
gem 'edge-state-machine'


# jquery-rails is used by the dummy application
gem "jquery-rails"

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'


group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'spork', '~> 0.9.0.rc'
  gem 'capybara', :git => 'https://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'watchr'
  gem 'execjs'
  gem 'therubyracer'
  gem 'simplecov', :require => false
end