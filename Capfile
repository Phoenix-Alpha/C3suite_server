# Load environment variables on production
require 'dotenv'
Dotenv.load

# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Use Git as source code manager
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# require 'capistrano/delayed_job'

require 'capistrano/puma'
install_plugin Capistrano::Puma
