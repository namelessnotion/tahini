require 'json/pure'
require 'erb'
require 'sass'
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

    get '/:bucket.css' do
      content_type :css
      data = Storage.new(:bucket => params[:bucket]).get
      puts data.inspect
      template = Tilt.new('lib/tahini/views/css/default.scss.erb')
      rendered = template.render(data)
      Sass::Engine.new( rendered, :syntax => :scss ).to_css
    end

    get '/:bucket.json' do
      content_type :json
      JSON.generate(Storage.new(:bucket => params[:bucket]).get)
     #key value pairs in json format
    end
    
    delete '/:bucket.json' do
      authenticate
      content_type :json
      if Storage.new(:bucket => params[:bucket]).delete
        JSON.generate({:status => 'success', :message => 'data successfully deleted'})
      else
        JSON.generate({:status => 'fail', :message => 'data failed to be deleted'})
      end
    end
    
    delete '/:bucket/:key.json' do
      authenticate
      content_type :json
      if Storage.new(:bucket => params[:bucket]).delete(params[:key])
        JSON.generate({:status => 'success', :message => "#{params[:key]} successfully deleted"})
      else
        JSON.generate({:status => 'fail', :message => "#{params[:key]} failed to be deleted"})
      end
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
      puts params.inspect
      if !params[:data].nil?
        if storage.store(params[:data])
          JSON.generate({:status => 'success', :message => 'data successfully stored'})
        else
          storage.errors
        end
      else
        JSON.generate({:status => 'success', :message => 'no data to store'})
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