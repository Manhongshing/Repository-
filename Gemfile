source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.8'

# Use sqlite3 as the database for Active Record
# gem 'sqlite3'

### for Google Analytics ###
gem 'google-analytics-rails'

### for JavaScript runtime ###
gem 'therubyracer', platforms: :ruby

### for session ###
gem 'bcrypt', '~> 3.1.2'

### for routine work ###
gem 'whenever', require: false

### for Notification ###
gem 'toastr-rails'

### for database ###
gem 'mysql2'

### for scraping
gem 'nokogiri', '~> 1.10.8'

### for soft-delete
gem 'paranoia', '~> 2.0'

### for fewer string Active Record
gem 'squeel'

### for using helper-method in js.erb
gem 'sprockets'

### for bulk insert
gem 'activerecord-import'

gem 'unicorn'

### for mixpanel
gem 'mixpanel-ruby'

group :deployment do
  ### for preloader
  gem 'spring'
  ### for Deploy ###
  gem 'capistrano', '~> 3.4'
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv'
  gem 'capistrano3-unicorn'
end

group :development, :test do
  ### for test
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'hirb'
  gem 'hirb-unicode'
  gem 'tapp'
  gem 'awesome_print'
  gem 'byebug'

  gem 'rspec-rails'
  gem 'guard-rails'
  ### for coverage
  gem 'coveralls', require: false
  gem 'simplecov'
  ### for rspec one-liner
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'poltergeist'
  gem 'factory_girl_rails'
  gem 'database_rewinder'
end

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# not using digit for fonts when assets:precompile
gem 'non-stupid-digest-assets'
