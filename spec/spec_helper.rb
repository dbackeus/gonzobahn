# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'spec'
require 'spec/rails'
require 'shoulda'

%w( controller_spec_helper ).each do |file| 
  require File.join(File.dirname(__FILE__), file)
end

Spec::Runner.configure do |config|
  config.include(ControllerSpecHelper, :type => :controllers)
  config.mock_with :mocha
end

def stub_recordings
  Recording.any_instance.stubs(:move_file_to_public_dir)
  Recording.any_instance.stubs(:generate_thumbnail)
  Recording.any_instance.stubs(:delete_files)
end