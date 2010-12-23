require "rubygems"
require "sinatra"

require 'lib/tahini/config'

Tahini.config do |c|
  Tahini.config do |c|
    c.aws_access_key_id = ENV['AMAZON_ACCESS_KEY_ID']
    c.aws_secret_access_key = ENV['AMAZON_SECRET_ACCESS_KEY']
    c.token = 'aa41d57ea0d92286449d276aba3ef470a21ec4a1'
    c.s3_bucket = 'tahini-cucumber'
  end
end
puts ENV.inspect
puts Tahini::Config.instance.inspect

require 'lib/tahini'

run Tahini::Server