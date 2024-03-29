require_relative 'boot'

require 'rails/all'
require_relative '../lib/middleware/uid_logging_middleware'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SpacedRepAcheivements
  class Application < Rails::Application
    # Expose our application's helpers to Administrate
    config.to_prepare do
      Administrate::ApplicationController.helper SpacedRepAcheivements::Application.helpers
    end
    config.active_job.queue_adapter = :sidekiq
    config.application_name = Rails.application.class.module_parent_name
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    config.application_name = "Anki Achievements"

    config.exceptions_app = self.routes
  end
end
