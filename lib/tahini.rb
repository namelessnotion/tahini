require 'rubygems' if RUBY_VERSION < '1.9'
require 'bundler/setup'
#Bundler.require(:default)
Bundler.setup
require 'redis'
require 'aws/s3'
RMAGICK_BYPASS_VERSION_TEST = true
require 'RMagick'

require 'sinatra'

configure :development do
  use Rack::Reloader
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

before do
  #authenticate
end

get '/' do
  "tahini is tasty!"
end

post '/' do
end

get '/stats.json' do
  #number of buckets
  #number of files
  #storage used on s3
end
