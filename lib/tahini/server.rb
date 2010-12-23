require 'json/pure'
module Tahini
  class Server < Sinatra::Base


    register Sinatra::Warden

    use Warden::Manager do |manager|
      manager.default_strategies :token
      manager.failure_app = Server
    end

    post '/unauthenticated/?' do
      status 401
      warden.custom_failure! if warden.config.failure_app == self.class
      env['x-rack.flash'][:error] = options.auth_error_message if defined?(Rack::Flash)
      "access denied"
    end

    get '/:bucket/:filename.css' do
      content_type :css
      #Sass.Engine.new( {rendered_erb} ).to_css
    end

    get '/:bucket/:filename.json' do
      content_type :json
      
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
      content_type :json
      storage = Storage.new(:bucket => params[:bucket])
      if storage.store(params[:data])
        JSON.generate({:status => 'success', :message => 'data successfully stored'})
      else
        storage.errors
      end
    end

    get '/stats.json' do
      content_type :json
      
      #number of buckets
      #number of files
      #storage used on s3
    end
  end
end