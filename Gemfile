source "http://rubygems.org"

# Declare your gem's dependencies in edge-auth.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'mongoid'
gem 'simple_form'
gem 'edge-state-machine'
gem 'omniauth-twitter'
gem 'edge-captcha'
gem 'edge-layouts', git: 'https://github.com/danpersa/edge-layouts.git'
                    #path: '/home/dix/prog/rails/edge-layouts'


# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end


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