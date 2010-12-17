Warden::Manager.before_failure do |env, opts|
  # Sinatra is very sensitive to the request method
  # since authentication could fail on any type of method, we need
  # to set it for the failure app so it is routed to the correct block
  env['REQUEST_METHOD'] = "POST"
end

Warden::Strategies.add(:token) do
  def valid?
    true
  end

  def authenticate!
    token = "q1w2e3r4"
    authed = false
    authed = (request.env['X-Tahini-Token'] == token unless request.env['X-Tahini-Token'].nil?)
    authed = (params['tahini_token'] == token)
    if !authed
      fail!("Unauthorized")
    else      
      success!( { :name => "user" })
    end
  end
end

module Sinatra
  module Warden
    module Helpers
      def warden
        request.env['warden']
      end
  
      def authenticate(*args)
        warden.authenticate!(*args)
      end
    end
    def self.registered(app)
      app.helpers Warden::Helpers
      app.set :sessions, true
      app.set :auth_use_referrer, false

      app.set :auth_error_message,   "Could not log you in."
      app.set :auth_success_message, "You have logged in successfully."
    end
  end
  register Warden
end