source 'https://rubygems.org'
ruby "2.6.3"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "active_model_serializers", "~> 0.10.10"
gem "active_record-acts_as", "~> 4.0"
gem "activerecord-session_store", "~> 1.1"
gem "activerecord-import", "~> 1.0"
gem "ancestry", "~> 3.1"
gem "aws-sdk-s3", "~> 1.78"
gem "bcrypt", "~> 3.1"
gem "bootstrap_progressbar", "~> 0.2.0"
gem 'bootsnap', '>= 1.4.2', require: false
gem "breadcrumbs_on_rails", "~> 4.0"
gem "cancancan", "~> 3.1"
gem "cocoon", "~> 1.2"
gem "rack-cors", "~> 1.1"
gem "devise", "~> 4.7"
gem "dotenv-rails", "~> 2.7"
gem "execjs", "~> 2.7"
gem "fastlane", "~> 2.156"
gem "file_validators", "~> 2.3"
gem "friendly_id", "~> 5.4"
gem "gon", "~> 6.3"
gem "haml-rails", "~> 2.0"
gem "lol_dba", "~> 2.2"
gem "mini_magick", "~> 4.10"
gem "mysql2", "~> 0.5.3"
gem "nokogiri", "~> 1.10"
gem "paper_trail", "~> 10.3"
gem 'puma', '~> 3.11'
gem "ranked-model", "~> 0.4.6"
gem "rails_db", "~> 2.3"
gem "roo", "~> 2.8"
gem "rubyzip", "~> 2.0"
gem "shrine", "~> 3.2"
gem "smarter_csv", "~> 1.2"
gem "stripe", "~> 5.23"
gem "streamio-ffmpeg", "~> 3.0"
gem "therubyracer", "~> 0.12.3"
gem "tinymce-rails", "~> 5.4"
gem 'rails', '~> 6.0.3.2'
gem "ransack", "~> 2.3"
gem 'venice'
#gem 'sprockets', '~> 3.7', '>= 3.7.2'

# Asset Pipeline
gem 'webpacker', '~> 4.0'
# gem "bootstrap-sass", "~> 3.4"
gem "coffee-rails", "~> 5.0"
gem "jquery-rails", "~> 4.4"
gem "jquery-ui-rails", "~> 6.0"
gem 'sass-rails', '~> 5'
gem "select2-rails", "~> 4.0"
gem "turbolinks", "~> 5.2"
gem "uglifier", "~> 4.2"


# API
gem "apitome", github: "jejacks0n/apitome"
gem 'jbuilder', '~> 2.7' 
gem "jwt", "~> 2.2"
gem "rspec_api_documentation", "~> 6.1"


# Deployment
gem "capistrano", "~> 3.14"
gem "capistrano-bundler", "~> 2.0"
gem "capistrano-rails", "~> 1.6"
gem "capistrano-rails-console", "~> 2.3"
gem "capistrano-rvm", "~> 0.1.2"
gem "capistrano3-puma", "~> 3.1"


# Delayed Jobs
gem "capistrano3-delayed-job", "~> 1.7"
gem "daemons", "~> 1.3"
gem "delayed_job", "~> 4.1"
gem "delayed_job_active_record", "~> 4.1"
gem "delayed_job_web", "~> 1.4"


group :development do
  gem 'web-console'
  gem 'better_errors'
  gem 'brakeman', require: false # security vulnerabilities, code analyzer
  gem 'bundler-audit' # patch-level verification for bundler
  gem 'guard-bundler'
  gem 'guard-rails'
  gem 'guard-rspec'
  gem 'rubocop', '~> 0.52.1', require: false # code analyzer
  gem 'rb-fchange', require: false
  gem 'rb-fsevent', require: false
  gem 'rb-inotify', require: false
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'launchy'
  gem 'rspec-rails'
  gem 'simplecov', require: true
  gem 'rails-controller-testing'
end

group :test do
  gem 'codeclimate-test-reporter'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
end

group :production do
  gem 'figaro'
end
