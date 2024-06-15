require_relative "boot"
require "rails/all"
Bundler.require(*Rails.groups)

Dotenv::Railtie.load if defined?(Dotenv)

module SampleApp
  class Application < Rails::Application
    config.load_defaults 7.0
    config.active_storage.variant_processor = :mini_magick
    config.i18n.default_locale = :ja
    config.active_storage.silence_invalid_content_types_warning = true
  end
end
