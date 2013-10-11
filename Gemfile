source "http://rubygems.org"

# Declare your gem's dependencies in edge-auth.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'mongoid', '~> 4', github: 'mongoid/mongoid'
gem 'simple_form'
gem 'edge-state-machine'
gem 'omniauth-twitter'
gem 'edge-captcha', git: 'https://github.com/danpersa/edge-captcha.git', branch: "rails4"
gem 'edge-layouts', git: 'https://github.com/danpersa/edge-layouts.git', branch: "rails4"
                    #path: '/home/dix/prog/rails/edge-layouts'


# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

gem 'sass-rails',   '~> 4.0.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'



group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'spork', '~> 0.9.2'
  gem 'capybara', :git => 'https://github.com/jnicklas/capybara.git'
  gem 'launchy'
  gem 'watchr'
  gem 'execjs'
  gem 'therubyracer'
  gem 'simplecov', :require => false
end