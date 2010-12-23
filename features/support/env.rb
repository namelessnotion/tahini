# Generated by cucumber-sinatra. (Tue Dec 21 14:21:29 -0500 2010)

ENV['RACK_ENV'] = 'test'
require 'cucumber/formatter/pretty'

begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'rest_client'
require 'json/pure'
require 'redis'

rackup_config = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'config.ru'))
puts system("thin -d -R #{rackup_config} -P /tmp/thin_tahini.pid -l /tmp/thin_tahini.log -V -p 3040 start &")
sleep 3
at_exit do
  system("kill -9 `cat /tmp/thin_tahini.pid`")
  system("rm /tmp/thin_tahini.pid")
end