# Load the Sinatra app
require File.join(File.dirname(__FILE__), '..', 'lib', 'tahini', 'config')
Tahini.config do |c|
  c.aws_access_key_id = 'abc'
  c.aws_secret_access_key = '123'
  c.token = 'q1w2e3r4'
  c.s3_bucket = 'tahini_s3_bucket'
end
require File.join(File.dirname(__FILE__), '..', 'lib', 'tahini')

# Load the testing libraries
require 'rspec'
require 'rack/test'

Rspec.configure do |config|
  config.mock_with :rspec
  config.include Rack::Test::Methods
  def app
    Tahini::Server
  end
  app.set :environment, :test
end

def fixture_file(filename)
  File.open(File.join(File.dirname(__FILE__), 'fixtures', 'files', filename), 'rb')
end
