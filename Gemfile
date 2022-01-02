source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.4.4'
# Use postgresql as the database for Active Record
gem 'pg', '>= 1.2.3', '< 2.0'
# Use Puma as the app server
gem 'puma', '>= 5.5.2'
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production

gem 'hiredis'
gem 'redis', '~> 4.0'
# gem "anycable-rails"
gem 'sidekiq-cron'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'jsonapi-serializer'

# https://github.com/ffi/ffi/issues/791
gem 'ffi', '~> 1.15.4'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'factory_bot_rails'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-rails', '~> 5.0.2'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '~> 3.7.0'
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :production do
  gem 'rails_performance'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 3.36.0'
  gem 'selenium-webdriver', '~> 4.1.0'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

gem 'administrate', github: 'excid3/administrate', branch: 'jumpstart'
gem 'administrate-field-active_storage'

gem 'activerecord-import'
gem 'bootstrap', '~> 4.3', '>= 4.3.1'
gem 'data_migrate'
gem 'devise', '~> 4.8.1', '>= 4.7.0'
gem 'devise-bootstrapped', github: 'excid3/devise-bootstrapped',
                           branch: 'bootstrap4'
gem 'devise_token_auth', '~> 1.2.0'
gem 'draper'
gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'
gem 'friendly_id', '~> 5.2', '>= 5.2.5'
gem 'gravatar_image_tag', github: 'mdeering/gravatar_image_tag'
gem 'haml-rails'
gem 'image_processing', '~> 1.2'
gem 'mini_magick'
gem 'name_of_person', '~> 1.1'
gem 'scenic'
gem 'sendgrid-actionmailer'
gem 'sidekiq', '~> 6.3.1', '>= 6.0.3'
gem 'sidekiq-limit_fetch', github: 'brainopia/sidekiq-limit_fetch'
gem 'sitemap_generator', '~> 6.0', '>= 6.0.1'
gem 'whenever', require: false

gem 'kaminari', '>= 1.2.1'

gem 'client_side_validations'
gem 'client_side_validations-simple_form'
gem 'simple_form'

gem 'pundit'

gem 'permessage_deflate', '~> 0.1.4'

gem 'anycable-rails'
gem 'oj', '~> 3.13.10'

gem 'rack-cors', '~> 1.1'

gem 'bootsnap', require: false
gem 'i18n', '~> 1.8'
gem 'rack-attack', '~> 6.5'

gem 'net-smtp', '~> 0.3.1'

gem 'jsbundling-rails', '~> 1.0'

gem "store_model", "~> 0.12.0"
