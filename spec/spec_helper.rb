# Load the Sinatra app
require File.join(File.dirname(__FILE__), '..', 'lib', 'tahini')

# Load the testing libraries
require 'rspec'
require 'rack/test'

Rspec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
  def app
    TahiniServer
  end
  app.set :environment, :test
end


# Set the Sinatra environment

# Add an app method for RSpec
