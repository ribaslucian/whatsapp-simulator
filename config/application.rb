require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProjectRaw
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    
    
    
    
    #
    
    config.assets.paths << Rails.root.join('angular-application', 'owl-carousel', 'angular', 'jquery')
    

    config.action_mailer.perform_caching = false
    config.action_mailer.delivery_method = :smtp
    # config.action_mailer.perform_deliveries = true

    config.action_mailer.smtp_settings = {
      address: 'smtp.{email}.com.br',
      port: 587,
      user_name: 'no-reply@{email}',
      password: 'senha',
      authentication: 'plain',
      enable_starttls_auto: true,
      openssl_verify_mode: OpenSSL::SSL::VERIFY_NONE
    }
    
    
    Time::DATE_FORMATS[:default] = "%d/%m/%Y %H:%M" 
    config.time_zone = 'Brasilia'
    
    config.action_view.field_error_proc = Proc.new { |html_tag, instance| 
      html_tag.html_safe
    }
  end
end
