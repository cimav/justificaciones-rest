require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Justificador6
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    # config.api_only = true

    #:user_name      => "servicio.cliente@cimav.edu.mx",
    #:password       => "S1gr3@2016"

    #:user_name      => "servicio.adquisiciones@cimav.edu.mx",
    #:password       => "temporal15",
    #
    # Email Configuration
    config.action_mailer.raise_delivery_errors = true
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = {
        :address   => "smtp.gmail.com",
        :port      => 587,
        :domain    => "cimav.edu.mx",
        :authentication => :plain,
        :user_name      => "servicio.adquisiciones@cimav.edu.mx",
        :password       => "temporal15",
        :enable_starttls_auto => true,
        :openssl_verify_mode => 'none'
    }

  end
end
