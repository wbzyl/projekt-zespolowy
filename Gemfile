source 'https://rubygems.org'

gem 'rails', '~> 3.2.9'
gem 'mongoid', '~> 3.0.9'
gem 'devise', '~> 2.1.2'
gem 'simple_form', '~> 2.0.4'

gem 'jquery-rails', '~> 2.1.3'

gem 'pg', :group => :production
gem 'thin'

group :development, :test do
  gem 'rspec-rails', '~> 2.11.0'
  gem 'factory_girl_rails', '~> 4.1.0'
end

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'

  gem 'less-rails'
  gem 'therubyracer'
  gem 'twitter-bootstrap-rails', '~> 2.1.4'
  gem 'jquery-ui-rails', '~> 2.0.2'
  gem 'jquery-datatables-rails', '~> 1.11.1'
end

group :development do
  gem 'hirb', '~> 0.7.0'
  gem 'quiet_assets', '~> 1.0.1'  # wylacza logowanie *assets pipeline*
end

group :test do
  # using Capybara with RSpec:
  #   http://rubydoc.info/github/jnicklas/capybara#Using_Capybara_with_RSpec
  gem 'capybara', '~> 1.1.2'
  # gem 'factory_girl', '~> 4.1.0'
  gem 'database_cleaner', '~> 0.9.1'
  gem 'email_spec', '~> 1.2.1'
  gem 'mongoid-rspec', '~> 1.5.4'
end

gem 'json', '~> 1.7.5'
