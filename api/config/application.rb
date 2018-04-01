# frozen_string_literal: true

require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'active_storage/engine'
# require "sprockets/railtie"
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems you've limited to
# :test, :development, or :production.
Bundler.require(*Rails.groups)

module Api
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here. Application configuration should go into files in
    # config/initializers -- all .rb files in that directory are automatically
    # loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually. Skip
    # views, helpers and assets when generating a new resource.
    config.api_only = true

    # Automatically load files from the lib directory
    config.eager_load_paths << Rails.root.join('lib')

    # Autoload all directories in app/ called "concerns"
    Dir[Rails.root.join('app', '**', 'concerns')].each do |path|
      config.autoload_paths += [path]
    end

    # Used DelayedJob as our ActiveJob backend
    config.active_job.queue_adapter = :sidekiq

    # Properly configure generators to use RSpec and factory_bot
    config.generators do |g|
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_bot, dir: 'spec/factories'

      g.view_specs false
      g.helper_specs false
    end

    # Default URL for generated links in email templates
    config.action_mailer.default_url_options = {
      host: Rails.application.secrets.action_mailer_default_host || 'localhost'
    }

    # set default url options to same stuff as actionmailer - see
    # https://stackoverflow.com/a/48530150
    routes.default_url_options = config.action_mailer.default_url_options
  end
end
