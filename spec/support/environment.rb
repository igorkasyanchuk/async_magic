require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require_relative "../dummy/config/environment"
require "rspec"
require "rspec/rails"

RSpec.configure do |config|
  # Additional global RSpec configuration if neededn
  config.before(:each) do
    clean_database
  end
end

# Clean up the database before each test
def clean_database
  Post.delete_all
  Visit.delete_all
end
