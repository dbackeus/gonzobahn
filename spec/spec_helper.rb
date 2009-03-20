# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'

%w( controller_spec_helper ).each do |file| 
  require File.join(File.dirname(__FILE__), file)
end

Spec::Runner.configure do |config|
  config.include(ControllerSpecHelper, :type => :controllers)
  config.mock_with :mocha
end
