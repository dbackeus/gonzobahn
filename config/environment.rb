# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  require 'ftools'
  
  config.gem "newrelic_rpm"
  config.gem "haml"
  config.gem "RedCloth", :lib => "redcloth"
  config.gem "thoughtbot-pacecar", :lib => "pacecar", :source => "http://gems.github.com"
  
  unless RAILS_ENV == "production"
    config.gem "thoughtbot-factory_girl", :lib => "factory_girl", :source => "http://gems.github.com"
    config.gem "thoughtbot-shoulda", :lib => "shoulda", :source => "http://gems.github.com"
    config.gem "mocha"
  end
  
  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Force all environments to use the same logger level
  # (by default production uses :info, the others :debug)
  # config.log_level = :debug

  config.action_controller.session = {
    :session_key => '_gonzoban_session',
    :secret      => '24b8cb807eb5b10f894eedd5496a4281d5f02a3c67278a4005e2ade1fa9a10756ba86aa5f3f87f5fa5e8a49ad9e420d71119dd47c3530b9daee6f984d09ea0b4'
  }
  
  # Obervers
  config.active_record.observers = :user_observer

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = "UTC"
end