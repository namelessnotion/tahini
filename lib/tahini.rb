require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler/setup'
#Bundler.require(:default)
Bundler.setup
require 'redis'
require 'aws/s3'
RMAGICK_BYPASS_VERSION_TEST = true
require 'RMagick'

require 'sinatra'
#require 'sinatra_warden'
require 'warden'

require 'lib/sinatra/warden/helper'

class TahiniServer < Sinatra::Base

  register Sinatra::Warden
    
  use Warden::Manager do |manager|
    manager.default_strategies :token
    manager.failure_app = TahiniServer
  end
  
  post '/unauthenticated/?' do
    status 401
    warden.custom_failure! if warden.config.failure_app == self.class
    env['x-rack.flash'][:error] = options.auth_error_message if defined?(Rack::Flash)
    "access denied"
  end
  
  get '/:bucket/:filename.css' do

  end

  get '/:bucket/:filename.json' do
   #key value pairs in json format
  end

  #post here to create a css
  # bucket
  # name
  # key => value pairs
  # images with verification
  #on success redirect to get /bucket/name.json
  #on error report problem


  get '/' do
    "tahini is tasty!"
  end

  post '/' do
    authenticate
    "mmm tahini"
  end

  get '/stats.json' do
    #number of buckets
    #number of files
    #storage used on s3
  end
end