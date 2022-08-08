require_relative 'boot'
require 'csv'
require 'rails/all'
require "active_job/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module C3Suite
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.0

    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true
        g.fixture_replacement :factory_bot, :dir => "spec/factories"
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.assets.paths << Rails.root.join('node_modules')
    config.autoload_paths += %W(#{config.root}/lib/BootstrapBreadcrumbsBuilder.rb #{config.root}/config/constants.rb)
    config.assets.precompile += ['jquery.countdown.js', 'jquery.countdown.css','jquery.plugin.js']
    
    config.active_job.queue_adapter = :delayed_job

    # Configure CORS
    Rails.application.config.middleware.insert_before 0, Rack::Cors do
      allow do
        # origins 'localhost:3000', '127.0.0.1:3000'
        # TODO: Don't allow for all, only temporary
        origins '*'
        resource '*',
          headers: :any,
          methods: [:get, :post, :put, :patch, :delete, :options, :head]
      end
    end
  end


end
