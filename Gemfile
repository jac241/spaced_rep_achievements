source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
#gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.3', '>= 6.0.2.2'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem "puma", ">= 4.3.5"
# Use SCSS for stylesheets
gem 'sass-rails', '>= 6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production

gem 'redis', '~> 4.0'
#gem "anycable-rails"
gem "sidekiq-cron"
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 4.0.0'
  gem 'factory_bot_rails'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :development, :production do
  gem 'rails_performance'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'administrate', github: 'excid3/administrate', branch: 'jumpstart'
gem 'administrate-field-active_storage'

gem 'bootstrap', '~> 4.3', '>= 4.3.1'
gem 'devise', '~> 4.7', '>= 4.7.0'
gem 'devise-bootstrapped', github: 'excid3/devise-bootstrapped', branch: 'bootstrap4'
gem 'font-awesome-sass', '~> 5.6', '>= 5.6.1'
gem 'friendly_id', '~> 5.2', '>= 5.2.5'
gem 'gravatar_image_tag', github: 'mdeering/gravatar_image_tag'
gem 'mini_magick'
gem 'name_of_person', '~> 1.1'
gem 'sidekiq', '~> 6.0', '>= 6.0.3'
gem 'sitemap_generator', '~> 6.0', '>= 6.0.1'
gem 'whenever', require: false
gem 'activerecord-import'
gem 'data_migrate'
gem 'image_processing', '~> 1.2'
gem 'scenic'
gem 'draper'
gem 'haml-rails'
gem 'devise_token_auth'
gem 'sendgrid-actionmailer'
gem 'sidekiq-limit_fetch'

gem "kaminari", ">= 1.2.1"

gem 'simple_form'
gem 'client_side_validations'
gem 'client_side_validations-simple_form'

gem 'pundit'

gem "permessage_deflate", "~> 0.1.4"
