source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.3'

gem 'rails', '~> 6.1.4'
gem 'pg', '~> 1.1'
gem 'puma', '~> 5.0'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "devise_token_auth", "~> 1.2"
gem "active_model_serializers", "~> 0.10.12"
gem "rack-cors", "~> 1.1"

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem "rspec-rails", "~> 5.0"
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 2.18"
end

group :development do
  gem "letter_opener", "~> 1.7"
end

group :test do
  gem "shoulda-matchers", "~> 5.0"
  gem "simplecov", "~> 0.21.2", require: false
  gem "database_cleaner-active_record", "~> 2.0"
end

