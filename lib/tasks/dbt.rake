# Database-specific tasks
# namespace :dbt do
#   require 'database_cleaner'

#   desc "Truncate all the database tables"
#   task :truncate => [:environment] do
#     DatabaseCleaner.strategy = :truncation
#     DatabaseCleaner.clean
#   end

# end